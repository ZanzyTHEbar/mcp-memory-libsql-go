FROM alpine:3.18
RUN apk add --no-cache bash coreutils tar findutils curl wget unzip
# Install rclone (optional) - will be a no-op if download fails
RUN set -e; \
    mkdir -p /tmp/rclone && \
    wget -qO /tmp/rclone.zip https://downloads.rclone.org/rclone-current-linux-amd64.zip && \
    unzip -q /tmp/rclone.zip -d /tmp/rclone || true; \
    if [ -f /tmp/rclone/*/rclone ]; then mv /tmp/rclone/*/rclone /usr/local/bin/rclone || true; fi; \
    rm -rf /tmp/rclone /tmp/rclone.zip || true

WORKDIR /backup
# When the build context is the repository root, copy the scripts from ./scripts
COPY scripts/backup_runner.sh /usr/local/bin/backup_runner.sh
RUN chmod +x /usr/local/bin/backup_runner.sh || true

ENTRYPOINT ["/usr/local/bin/backup_runner.sh"]


