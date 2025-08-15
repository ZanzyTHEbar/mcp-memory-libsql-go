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

# Build common args; ensure addr includes leading colon
COMMON_ARGS=("-transport" "${TRANSPORT}" "-addr" ":${PORT}" "-sse-endpoint" "${SSE_ENDPOINT}")
echo "entrypoint: MODE=${MODE} PORT=${PORT} TRANSPORT=${TRANSPORT} SSE_ENDPOINT=${SSE_ENDPOINT}" >&2

case "$MODE" in
single)
    exec /usr/local/bin/mcp-memory-libsql-go "${COMMON_ARGS[@]}"
    ;;
multi)
    exec /usr/local/bin/mcp-memory-libsql-go "${COMMON_ARGS[@]}" -projects-dir "${PROJECTS_DIR}"
    ;;
voyageai)
    # voyageai uses same multi-project flags but expects VOYAGE env vars to be present
    exec /usr/local/bin/mcp-memory-libsql-go "${COMMON_ARGS[@]}" -projects-dir "${PROJECTS_DIR}"
    ;;
*)
    echo "Unknown MODE='${MODE}' - expected single|multi|voyageai" >&2
    exit 2
    ;;
esac
