#!/bin/sh
set -eu

# create_app_user_helper.sh
# Helper to create a system group and user named `app` with a specific
# UID/GID. Intended to be run inside the container (as root) or during image
# build if you want to pin the runtime uid/gid to match host users.
#
# Usage:
#   PROJECTS_UID=1000 PROJECTS_GID=1000 ./create_app_user_helper.sh

TARGET_UID=${PROJECTS_UID:-1000}
TARGET_GID=${PROJECTS_GID:-1000}

echo "create_app_user_helper: creating group 'app' with GID=${TARGET_GID} and user 'app' with UID=${TARGET_UID}'"

if ! getent group app >/dev/null 2>&1; then
    groupadd --gid "${TARGET_GID}" app || {
        echo "warning: groupadd failed (maybe group exists)" >&2
    }
else
    echo "group 'app' already exists" >&2
fi

if ! id -u app >/dev/null 2>&1; then
    useradd --system --uid "${TARGET_UID}" --gid app --home /app --shell /usr/sbin/nologin app || {
        echo "warning: useradd failed" >&2
    }
else
    echo "user 'app' already exists" >&2
fi

echo "create_app_user_helper: done"
