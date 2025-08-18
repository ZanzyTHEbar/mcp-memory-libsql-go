#!/bin/bash
set -euo pipefail

# entrypoint.sh - choose runtime args based on MODE env var
# MODE: single | multi | voyageai

# Preference: if MODE is explicitly provided (non-empty), it takes precedence
# over any CMD/compose `command:`. If MODE is not provided and CMD args exist,
# honor the CMD args. If neither MODE nor CMD are provided, default to single.
mode_provided=0
if [ "${MODE+set}" = "set" ] && [ -n "${MODE}" ]; then
    mode_provided=1
fi

# If running in single mode and using a local file DB, ensure the DB file exists
# This helps scenarios where SKIP_CHOWN=1 or mounts deny ownership changes.
if [ "${MODE}" = "single" ]; then
    if [ -n "${LIBSQL_URL:-}" ] && echo "${LIBSQL_URL}" | grep -q '^file:'; then
        DB_PATH=$(echo "${LIBSQL_URL}" | sed 's%^file:%%')
        if [ -z "${DB_PATH}" ]; then
            DB_PATH="/data/libsql.db"
        fi
        DB_DIR=$(dirname "${DB_PATH}")
        mkdir -p "${DB_DIR}" || true
        if [ ! -f "${DB_PATH}" ]; then
            echo "entrypoint: creating local database file at ${DB_PATH}" >&2
            touch "${DB_PATH}" || true
            # If running as root and SKIP_CHOWN is not set, attempt to chown the file
            if [ "$(id -u)" -eq 0 ] && [ "${SKIP_CHOWN}" != "1" ]; then
                chown "${TARGET_UID:-1000}:${TARGET_GID:-1000}" "${DB_PATH}" || true
            fi
        else
            echo "entrypoint: local database file ${DB_PATH} already exists" >&2
        fi
    fi
fi

if [ "$mode_provided" -eq 0 ]; then
    # MODE not explicitly provided; if CMD args exist, execute them
    if [ "$#" -gt 0 ]; then
        exec /usr/local/bin/mcp-memory-libsql-go "$@"
    fi
fi

# Determine MODE and defaults (if MODE was provided use it, else default to single)
MODE=${MODE:-single}
PORT=${PORT}
METRICS_PORT=${METRICS_PORT:-9090}
PROJECTS_DIR=${PROJECTS_DIR:-/data/projects}
# Allow deployments to opt-out of performing chown/chmod/setfacl on mounted
# host paths. When running the container as a non-root user (e.g. via
# `user:` in docker-compose) set SKIP_CHOWN=1 to avoid permission operations
# that would otherwise fail on bind-mounted host directories.
SKIP_CHOWN=${SKIP_CHOWN:-0}

# Build common args; ensure addr includes leading colon
COMMON_ARGS=("-transport" "${TRANSPORT:-sse}" "-addr" ":${PORT}" "-sse-endpoint" "${SSE_ENDPOINT:-/sse}")
echo "entrypoint: MODE=${MODE} PORT=${PORT} TRANSPORT=${TRANSPORT:-sse} SSE_ENDPOINT=${SSE_ENDPOINT:-/sse}" >&2

# If running as root, ensure PROJECTS_DIR exists and is owned by the target
# UID/GID. Allow overriding via PROJECTS_UID/PROJECTS_GID env vars so host
# users can map ownership into the container.
if [ "$(id -u)" -eq 0 ]; then
    TARGET_UID=${PROJECTS_UID:-1000}
    TARGET_GID=${PROJECTS_GID:-1000}
    echo "entrypoint: running as root, ensuring ${PROJECTS_DIR} exists and owned by ${TARGET_UID}:${TARGET_GID}" >&2
    if [ "${SKIP_CHOWN}" = "1" ]; then
        echo "entrypoint: SKIP_CHOWN=1 set, skipping chown/chmod/ACL operations for ${PROJECTS_DIR}" >&2
    else
        mkdir -p "${PROJECTS_DIR}" || true
        mkdir -p /data || true
        # create group/user if necessary (ignore errors if they already exist)
        if ! getent group app >/dev/null 2>&1; then
            groupadd --gid "${TARGET_GID}" app || true
        fi
        if ! id -u app >/dev/null 2>&1; then
            useradd --system --gid app --home /app --shell /usr/sbin/nologin app || true
        fi

        # Helper: only chown paths when the owner differs from TARGET_UID:TARGET_GID
        ensure_owned() {
            local path="$1"
            if [ ! -e "$path" ]; then
                mkdir -p "$path" || true
            fi
            # Get current owner uid:gid
            cur_owner=$(stat -c '%u:%g' "$path" 2>/dev/null || echo '')
            if [ "$cur_owner" != "${TARGET_UID}:${TARGET_GID}" ]; then
                echo "entrypoint: changing ownership of $path from ${cur_owner:-unknown} to ${TARGET_UID}:${TARGET_GID}" >&2
                chown -R "${TARGET_UID}:${TARGET_GID}" "$path" || true
            else
                echo "entrypoint: $path already owned by ${TARGET_UID}:${TARGET_GID}, skipping chown" >&2
            fi
        }

        ensure_owned "${PROJECTS_DIR}"
        ensure_owned "/data"

        # Ensure libsql DB file is owned correctly if present
        if [ -f /data/libsql.db ]; then
            cur_db_owner=$(stat -c '%u:%g' /data/libsql.db 2>/dev/null || echo '')
            if [ "$cur_db_owner" != "${TARGET_UID}:${TARGET_GID}" ]; then
                chown "${TARGET_UID}:${TARGET_GID}" /data/libsql.db || true
            fi
        fi

        # Make the projects dir group-writable and set SGID so new subdirs inherit
        # the group. This helps when the host and container share a group for access.
        chmod 2775 "${PROJECTS_DIR}" || true
        # If setfacl is available, set default ACLs so new files/dirs are group-writable
        if command -v setfacl >/dev/null 2>&1; then
            setfacl -R -m d:g:${TARGET_GID}:rwx "${PROJECTS_DIR}" || true
            setfacl -R -m g:${TARGET_GID}:rwx "${PROJECTS_DIR}" || true
        fi
    fi
    # detect privilege-drop helpers
    if command -v gosu >/dev/null 2>&1; then
        PRIV_DROP_TOOL=gosu
    elif command -v su-exec >/dev/null 2>&1; then
        PRIV_DROP_TOOL=su-exec
    else
        PRIV_DROP_TOOL=
    fi
fi

# --- Explicit init step ---
# Run a safe initialization that ensures mounts created by the host are
# writable by the configured runtime user/group. This is idempotent and
# will run at container startup when the entrypoint executes.
if [ "$(id -u)" -eq 0 ]; then
    echo "entrypoint: performing explicit init of /data and ${PROJECTS_DIR}" >&2
    if [ "${SKIP_CHOWN}" = "1" ]; then
        echo "entrypoint: SKIP_CHOWN=1 set, skipping explicit init (chown/chmod/setfacl)" >&2
        mkdir -p "${PROJECTS_DIR}" || true
    else
        mkdir -p "${PROJECTS_DIR}" || true
        # Use the same ensure_owned helper to avoid unnecessary chown operations
        if declare -f ensure_owned >/dev/null 2>&1; then
            ensure_owned "/data"
            ensure_owned "${PROJECTS_DIR}"
        else
            chown -R "${TARGET_UID}:${TARGET_GID}" /data || true
            chown -R "${TARGET_UID}:${TARGET_GID}" "${PROJECTS_DIR}" || true
        fi
        # set SGID on projects dir so new subdirs inherit group
        chmod 2775 "${PROJECTS_DIR}" || true
        # set default ACLs if available
        if command -v setfacl >/dev/null 2>&1; then
            echo "entrypoint: applying default ACLs to ${PROJECTS_DIR}" >&2
            setfacl -R -m d:g:${TARGET_GID}:rwx "/data" || true
            setfacl -R -m g:${TARGET_GID}:rwx "/data" || true
            setfacl -R -m d:g:${TARGET_GID}:rwx "${PROJECTS_DIR}" || true
            setfacl -R -m g:${TARGET_GID}:rwx "${PROJECTS_DIR}" || true
        fi
    fi
fi

case "$MODE" in
single)
    if [ "${PRIV_DROP_TOOL:-}" = "gosu" ]; then
        exec gosu app /usr/local/bin/mcp-memory-libsql-go "${COMMON_ARGS[@]}"
    elif [ "${PRIV_DROP_TOOL:-}" = "su-exec" ]; then
        exec su-exec app /usr/local/bin/mcp-memory-libsql-go "${COMMON_ARGS[@]}"
    else
        # No privilege drop helper available; attempt to run as app user via
        # su -s; if that fails, run as current user (may be root)
        exec su -s /bin/sh -c "/usr/local/bin/mcp-memory-libsql-go \"${COMMON_ARGS[@]}\"" app || exec /usr/local/bin/mcp-memory-libsql-go "${COMMON_ARGS[@]}"
    fi
    ;;
multi)
    if [ "${PRIV_DROP_TOOL:-}" = "gosu" ]; then
        exec gosu app /usr/local/bin/mcp-memory-libsql-go "${COMMON_ARGS[@]}" -projects-dir "${PROJECTS_DIR}"
    elif [ "${PRIV_DROP_TOOL:-}" = "su-exec" ]; then
        exec su-exec app /usr/local/bin/mcp-memory-libsql-go "${COMMON_ARGS[@]}" -projects-dir "${PROJECTS_DIR}"
    else
        exec su -s /bin/sh -c "/usr/local/bin/mcp-memory-libsql-go \"${COMMON_ARGS[@]}\" -projects-dir \"${PROJECTS_DIR}\"" app || exec /usr/local/bin/mcp-memory-libsql-go "${COMMON_ARGS[@]}" -projects-dir "${PROJECTS_DIR}"
    fi
    ;;
voyageai)
    # voyageai uses same multi-project flags but expects VOYAGE env vars to be present
    if [ "${PRIV_DROP_TOOL:-}" = "gosu" ]; then
        exec gosu app /usr/local/bin/mcp-memory-libsql-go "${COMMON_ARGS[@]}" -projects-dir "${PROJECTS_DIR}"
    elif [ "${PRIV_DROP_TOOL:-}" = "su-exec" ]; then
        exec su-exec app /usr/local/bin/mcp-memory-libsql-go "${COMMON_ARGS[@]}" -projects-dir "${PROJECTS_DIR}"
    else
        exec su -s /bin/sh -c "/usr/local/bin/mcp-memory-libsql-go \"${COMMON_ARGS[@]}\" -projects-dir \"${PROJECTS_DIR}\"" app || exec /usr/local/bin/mcp-memory-libsql-go "${COMMON_ARGS[@]}" -projects-dir "${PROJECTS_DIR}"
    fi
    ;;
*)
    echo "Unknown MODE='${MODE}' - expected single|multi|voyageai" >&2
    exit 2
    ;;
esac
