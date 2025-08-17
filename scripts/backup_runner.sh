#!/bin/bash
set -euo pipefail

# backup_runner.sh
# Periodically archive /data into timestamped tarballs with rotation and
# optional remote upload via RCLONE_REMOTE (rclone must be configured).

DATA_DIR=${DATA_DIR:-/data}
BACKUP_DIR=${BACKUP_DIR:-/backup}
RETENTION=${RETENTION:-7} # keep N latest backups
SLEEP_SECONDS=${SLEEP_SECONDS:-3600}
RCLONE_REMOTE=${RCLONE_REMOTE:-}
RUN_ONCE=${RUN_ONCE:-false}
RCLONE_CONFIG_PATH=${RCLONE_CONFIG_PATH:-}
EXCLUDE_PATTERNS=${EXCLUDE_PATTERNS:-backups}

mkdir -p "${BACKUP_DIR}"

while true; do
    TS=$(date +%Y%m%d%H%M%S)
    FNAME="backup-${TS}.tgz"
    echo "backup: creating ${BACKUP_DIR}/${FNAME} from ${DATA_DIR}"

    # Build tar --exclude args from EXCLUDE_PATTERNS (space-separated)
    IFS=' ' read -r -a _patterns <<<"${EXCLUDE_PATTERNS}"
    _exclude_args=()
    for _p in "${_patterns[@]}"; do
        # Exclude relative paths inside the tar (prefix with ./)
        _exclude_args+=("--exclude=./${_p}")
    done

    echo "backup: excluding patterns: ${EXCLUDE_PATTERNS}"
    tar -czf "${BACKUP_DIR}/${FNAME}" -C "${DATA_DIR}" "${_exclude_args[@]}" .
    echo "backup: created ${FNAME}"
    # Log archive size (human-readable)
    if command -v du >/dev/null 2>&1; then
        echo -n "backup: archive size: "
        du -sh "${BACKUP_DIR}/${FNAME}" || true
    fi

    # Rotation: keep only the newest $RETENTION files
    ls -1t "${BACKUP_DIR}"/backup-*.tgz 2>/dev/null | tail -n +$((RETENTION + 1)) | xargs -r rm -f || true

    # Optional remote upload via rclone
    if [ -n "${RCLONE_REMOTE}" ]; then
        # If RCLONE_CONFIG_PATH is provided, export RCLONE_CONFIG to point to it
        if [ -n "${RCLONE_CONFIG_PATH:-}" ] && [ -f "${RCLONE_CONFIG_PATH}" ]; then
            export RCLONE_CONFIG="${RCLONE_CONFIG_PATH}"
        fi
        echo "backup: uploading ${FNAME} to ${RCLONE_REMOTE}"
        rclone copy "${BACKUP_DIR}/${FNAME}" "${RCLONE_REMOTE}" --no-traverse || echo "rclone upload failed"
    fi

    # If RUN_ONCE=true, exit after one iteration (useful for CI/test runs)
    if [ "${RUN_ONCE}" = "true" ] || [ "${RUN_ONCE}" = "1" ]; then
        echo "backup: RUN_ONCE set, exiting after single run"
        break
    fi

    sleep ${SLEEP_SECONDS}
done
