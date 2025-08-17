#!/bin/sh
set -eu

# permission_test.sh - test creation of project directories as unprivileged user
# Usage: ./permission_test.sh /data/projects

TARGET_DIR=${1:-/data/projects}
TEST_PROJECT_DIR="${TARGET_DIR}/test-project-$(date +%s)"

echo "permission_test: will test creating ${TEST_PROJECT_DIR} as user 'app'"

mkdir -p "${TARGET_DIR}"

if id -u app >/dev/null 2>&1; then
    echo "running mkdir as user 'app'"
    su -s /bin/sh -c "mkdir -p \"${TEST_PROJECT_DIR}\" && touch \"${TEST_PROJECT_DIR}/ok.txt\"" app
    ls -l "${TEST_PROJECT_DIR}"
    echo "permission_test: success"
else
    echo "user 'app' not found; attempting as current user"
    mkdir -p "${TEST_PROJECT_DIR}"
    touch "${TEST_PROJECT_DIR}/ok.txt"
    ls -l "${TEST_PROJECT_DIR}"
    echo "permission_test: success (ran as current user)"
fi
