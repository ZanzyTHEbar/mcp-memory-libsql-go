# We cannot use an Alpine image for building because the go-libsql package uses pre-compiled binaries that were built-against glibc

##### Build stage ###############################################################
FROM golang:1.24.3 AS build

WORKDIR /src
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates git build-essential gcc g++ && \
    rm -rf /var/lib/apt/lists/*

COPY go.mod go.sum ./
RUN go mod tidy
COPY . .

# Build metadata
ARG VERSION=dev
ARG REVISION=dev
ARG BUILD_DATE

# Build binary with CGO (libsql requires glibc)
RUN CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -trimpath \
    -ldflags "-s -w -X github.com/ZanzyTHEbar/mcp-memory-libsql-go/internal/buildinfo.Version=${VERSION} -X github.com/ZanzyTHEbar/mcp-memory-libsql-go/internal/buildinfo.Revision=${REVISION} -X github.com/ZanzyTHEbar/mcp-memory-libsql-go/internal/buildinfo.BuildDate=${BUILD_DATE}" \
    -o /out/mcp-memory-libsql-go ./cmd/mcp-memory-libsql-go

# Base final stage with shared runtime configuration (glibc)
FROM debian:bookworm-slim AS base

# Allow pinning the runtime UID/GID for the unprivileged `app` user at build
# time. Defaults to 1000/1000 which matches most Linux desktop users.
ARG APP_UID=1000
ARG APP_GID=1000

# Create the app group/user with the provided IDs so host/containers can
# share predictable ownership (useful for backups and host integration).
RUN groupadd --gid ${APP_GID} app || true && \
    useradd --system --uid ${APP_UID} --gid app --home /app --shell /usr/sbin/nologin app || true
WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates tzdata curl procps gosu acl && \
    rm -rf /var/lib/apt/lists/*

COPY --from=build /out/mcp-memory-libsql-go /usr/local/bin/mcp-memory-libsql-go
# copy entrypoint and make executable (keep ownership change after)
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
# Do not switch to the unprivileged user here so the entrypoint can
# create and chown bind-mounted paths (like /data/projects) at startup.
# The entrypoint will drop privileges to the `app` user when starting the
# service process.

# Default environment variables (non-sensitive defaults only)
# NOTE: Do NOT bake sensitive API keys or tokens into the image. Provide
# sensitive values (API keys, DB auth tokens, etc.) at runtime via an
# env-file, `-e`/--env, or container secret mechanism. Keeping secrets out of
# the image avoids accidental leakage and silences static analysis warnings.
ENV LIBSQL_URL="file:/data/libsql.db" \
    EMBEDDING_DIMS=4 \
    DB_MAX_OPEN_CONNS="" \
    DB_MAX_IDLE_CONNS="" \
    DB_CONN_MAX_IDLE_SEC="" \
    DB_CONN_MAX_LIFETIME_SEC="" \
    METRICS_PROMETHEUS="" \
    METRICS_PORT="9090" \
    EMBEDDINGS_PROVIDER="" \
    HYBRID_SEARCH="" \
    HYBRID_TEXT_WEIGHT=0.4 \
    HYBRID_VECTOR_WEIGHT=0.6 \
    HYBRID_RRF_K=60 \
    OPENAI_EMBEDDINGS_MODEL="text-embedding-3-small" \
    OLLAMA_HOST="" \
    OLLAMA_EMBEDDINGS_MODEL="nomic-embed-text" \
    GEMINI_EMBEDDINGS_MODEL="text-embedding-004" \
    LOCALAI_BASE_URL="http://localhost:8080/v1" \
    LOCALAI_EMBEDDINGS_MODEL="text-embedding-ada-002"

# Allow deployments to opt-out of performing chown/chmod/ACL operations at
# container startup. When running the container as a non-root user (for
# example via `user:` in docker-compose) set `SKIP_CHOWN=1` in your
# environment to avoid permission operations that would otherwise fail on
# bind-mounted host directories.
ENV SKIP_CHOWN="0"

# Volumes and ports
VOLUME ["/data"]
#EXPOSE 8080 9090

# Healthcheck hits metrics healthz if enabled, otherwise process check
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s CMD curl -fsS http://127.0.0.1:9090/healthz || pgrep -x mcp-memory-libsql-go >/dev/null || exit 1

# Entrypoint handles MODE selection (single|multi|voyageai)
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Single DB SSE stage
#FROM base AS single-db-sse
#CMD ["-transport", "sse"]
#
## Single DB Stdio stage
#FROM base AS single-db-stdio
#CMD ["-transport", "stdio"]
#
## Multi-project SSE stage
#FROM base AS multi-project-sse
#CMD ["-transport", "sse", "-projects-dir", "/data/projects"]
#
## Multi-project Stdio stage
#FROM base AS multi-project-stdio
#CMD ["-transport", "stdio", "-projects-dir", "/data/projects"]


