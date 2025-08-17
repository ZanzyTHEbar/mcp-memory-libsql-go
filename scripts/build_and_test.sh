#!/bin/sh
set -eu

# build_and_test.sh - builds the docker image with pinned UID/GID and runs
# an ephemeral container to execute the permission test script.

IMAGE_NAME="mcp-memory-libsql-go:local-test"
APP_UID=${APP_UID:-1000}
APP_GID=${APP_GID:-1000}

echo "Building image ${IMAGE_NAME} with APP_UID=${APP_UID} APP_GID=${APP_GID}"
docker build --build-arg APP_UID=${APP_UID} --build-arg APP_GID=${APP_GID} -t ${IMAGE_NAME} .

echo "Running ephemeral container to test permissions"
mkdir -p /tmp/mcp_test_data

# Start container so entrypoint runs and performs chown/ACL setup
CONTAINER_NAME="mcp_test_run_$$"
docker run -d --name ${CONTAINER_NAME} \
    -e MODE=multi -e PROJECTS_UID=${APP_UID} -e PROJECTS_GID=${APP_GID} \
    -v $(pwd)/scripts:/scripts:ro \
    -v /tmp/mcp_test_data:/data \
    ${IMAGE_NAME}

echo "Waiting for entrypoint to initialize mounts..."
sleep 4

echo "Stopping initialization container ${CONTAINER_NAME}"
docker stop ${CONTAINER_NAME} >/dev/null || true
docker rm ${CONTAINER_NAME} >/dev/null || true

# Now run a short-lived container that executes the permission test (entrypoint skipped)
docker run --rm -it \
    --entrypoint /bin/sh \
    -e PROJECTS_UID=${APP_UID} -e PROJECTS_GID=${APP_GID} \
    -v $(pwd)/scripts:/scripts:ro \
    -v /tmp/mcp_test_data:/data \
    ${IMAGE_NAME} -c \
    "/bin/sh /scripts/permission_test.sh /data/projects"

# If the entrypoint didn't chown the mount (e.g., initial run didn't run as root),
# perform an explicit chown/init step now so the permission test can proceed.
echo "Ensuring /tmp/mcp_test_data ownership and ACLs via explicit init run"
docker run --rm --entrypoint /bin/sh -v /tmp/mcp_test_data:/data ${IMAGE_NAME} -c "chown -R ${APP_UID}:${APP_GID} /data || true; mkdir -p /data/projects || true; chmod 2775 /data/projects || true; if command -v setfacl >/dev/null 2>&1; then setfacl -R -m d:g:${APP_GID}:rwx /data/projects || true; fi"

echo "Running permission test container"
docker run --rm -it \
    --entrypoint /bin/sh \
    -e PROJECTS_UID=${APP_UID} -e PROJECTS_GID=${APP_GID} \
    -v $(pwd)/scripts:/scripts:ro \
    -v /tmp/mcp_test_data:/data \
    ${IMAGE_NAME} -c "/bin/sh /scripts/permission_test.sh /data/projects"

echo "Test complete. Inspect /tmp/mcp_test_data on host for results"
