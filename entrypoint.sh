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
    mkdir -p "${PROJECTS_DIR}" || true
    mkdir -p /data || true
    # create group/user if necessary (ignore errors if they already exist)
    if ! getent group app >/dev/null 2>&1; then
        groupadd --gid "${TARGET_GID}" app || true
    fi
    if ! id -u app >/dev/null 2>&1; then
        useradd --system --gid app --home /app --shell /usr/sbin/nologin app || true
    fi
    chown -R "${TARGET_UID}:${TARGET_GID}" "${PROJECTS_DIR}" || true
    chown -R "${TARGET_UID}:${TARGET_GID}" /data || true
    # Ensure libsql DB file is owned correctly if present
    if [ -f /data/libsql.db ]; then
        chown "${TARGET_UID}:${TARGET_GID}" /data/libsql.db || true
    fi
    # Make the projects dir group-writable and set SGID so new subdirs inherit
    # the group. This helps when the host and container share a group for access.
    chmod 2775 "${PROJECTS_DIR}" || true
    # If setfacl is available, set default ACLs so new files/dirs are group-writable
    if command -v setfacl >/dev/null 2>&1; then
        setfacl -R -m d:g:${TARGET_GID}:rwx "${PROJECTS_DIR}" || true
        setfacl -R -m g:${TARGET_GID}:rwx "${PROJECTS_DIR}" || true
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
    mkdir -p "${PROJECTS_DIR}" || true
    # chown again (idempotent)
    chown -R "${TARGET_UID}:${TARGET_GID}" /data || true
    chown -R "${TARGET_UID}:${TARGET_GID}" "${PROJECTS_DIR}" || true
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
