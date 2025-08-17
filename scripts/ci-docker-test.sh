#!/usr/bin/env bash
set -euo pipefail

# CI/local test script extracted from Makefile to avoid Makefile recipe fragility.
# Usage: ./scripts/ci-docker-test.sh [env-file]

ENV_FILE=${1:-.env.ci}
PORT_SSE=${PORT_SSE:-8080}
PORT_METRICS=${PORT_METRICS:-9090}
PROFILE=${PROFILES:-memory}

echo "Preparing test environment..."
mkdir -p ./data ./data/projects ./ollama_models
chmod -R 777 ./data ./ollama_models

# Always write a deterministic env file for CI/test runs to avoid stale state
cat >"$ENV_FILE" <<EOF
MODE=multi
LIBSQL_URL=
LIBSQL_AUTH_TOKEN=
EMBEDDING_DIMS=4
PROJECTS_DIR=/data/projects
PORT=${PORT_SSE}
METRICS_PORT=${PORT_METRICS}
SSE_ENDPOINT=/sse
MULTI_PROJECT_AUTH_REQUIRED=false
MULTI_PROJECT_AUTO_INIT_TOKEN=true
MULTI_PROJECT_DEFAULT_TOKEN=ci-token
BUILD_DATE=${BUILD_DATE:-ci}
EOF
echo "Wrote $ENV_FILE"

echo "Ensuring project directory exists"
mkdir -p ./data/projects/default
chmod -R 777 ./data/projects

STARTED=0

DOCKER_IMAGE=${DOCKER_IMAGE:-mcp-memory-libsql-go:local}
if docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
    echo "Found image $DOCKER_IMAGE"
else
    echo "Image $DOCKER_IMAGE not found; building..."
    make docker-build
fi

echo "Bringing up 'memory' service using $ENV_FILE"
docker compose --env-file "$ENV_FILE" --profile "$PROFILE" up -d memory
STARTED=1

echo "Waiting for service healthy (up to 90s)..."
for i in $(seq 1 90); do
    if curl -fsS "http://127.0.0.1:${PORT_METRICS}/healthz" >/dev/null 2>&1; then
        echo "Metrics endpoint healthy"
        break
    fi
    # fallback to container health
    CID=$(docker compose --env-file "$ENV_FILE" --profile "$PROFILE" ps -q memory 2>/dev/null || true)
    if [ -n "$CID" ]; then
        STATUS=$(docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{end}}' "$CID" 2>/dev/null || true)
        if [ "$STATUS" = "healthy" ]; then
            echo "Container reported healthy"
            break
        fi
    fi
    sleep 1
    if [ "$i" -eq 90 ]; then
        echo "Health check timed out"
        docker compose --env-file "$ENV_FILE" --profile "$PROFILE" ps || true
        docker compose --env-file "$ENV_FILE" --profile "$PROFILE" logs --tail=200 memory || true
        EXIT_CODE=1
        break
    fi
done

EXIT_CODE=0
if [ ${EXIT_CODE:-0} -eq 0 ]; then
    echo "Running integration tester against SSE endpoint..."
    if ! go run ./cmd/integration-tester -sse-url "http://127.0.0.1:${PORT_SSE}/sse" -project default -timeout 75s | tee integration-report.json; then
        echo "Integration tester failed"
        EXIT_CODE=1
    fi
fi

echo "Tearing down containers (if started by this script)..."
if [ "$STARTED" -eq 1 ]; then
    docker compose --env-file "$ENV_FILE" --profile "$PROFILE" down || true
fi

echo "--- Integration Test Report ---"
if [ -f integration-report.json ]; then
    cat integration-report.json
fi

exit ${EXIT_CODE:-0}
