# Makefile for mcp-memory-libsql-go

SHELL := /bin/sh

# Variables
BINARY_NAME=mcp-memory-libsql-go
MAIN_PACKAGE=./cmd/${BINARY_NAME}
BINARY_LOCATION=$(shell pwd)/bin/$(BINARY_NAME)
INTEGRATION_TESTER=./cmd/integration-tester
INTEGRATION_TESTER_BINARY=$(shell pwd)/bin/integration-tester
VERSION ?= $(shell git describe --tags --always --dirty)
REVISION ?= $(shell git rev-parse HEAD)
BUILD_DATE = $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')
LDFLAGS = -ldflags "-X github.com/ZanzyTHEbar/${BINARY_NAME}/internal/buildinfo.Version=$(VERSION) -X github.com/ZanzyTHEbar/${BINARY_NAME}/internal/buildinfo.Revision=$(REVISION) -X github.com/ZanzyTHEbar/${BINARY_NAME}/internal/buildinfo.BuildDate=$(BUILD_DATE)"

# Docker config
IMAGE ?= $(BINARY_NAME)
TAG ?= local
DOCKER_IMAGE := $(IMAGE):$(TAG)
ENV_FILE ?=
ENV_FILE_ARG := $(if $(ENV_FILE),--env-file $(ENV_FILE),)
PORT_SSE ?= 8080
PORT_METRICS ?= 9090
PROFILES ?= memory
PROFILE_FLAGS := $(foreach p,$(PROFILES),--profile $(p))

# Default target
.PHONY: all
all: build

# Build the binary
.PHONY: build
build:
	CGO_ENABLED=1 go build $(LDFLAGS) -o $(BINARY_LOCATION) $(MAIN_PACKAGE)

# Build the integration tester into bin/
.PHONY: build-integration
build-integration:
	mkdir -p $(shell pwd)/bin
	CGO_ENABLED=1 go build $(LDFLAGS) -o $(INTEGRATION_TESTER_BINARY) $(INTEGRATION_TESTER)

# Install dependencies
.PHONY: deps
deps:
	go mod tidy

# Run tests
.PHONY: test
test:
	go test ./...

# Run the server
.PHONY: run
run: build
	$(BINARY_LOCATION)

# Build the docker image
.PHONY: docker docker-build
docker: docker-build
docker-build:
	docker build \
		--build-arg VERSION=$(VERSION) \
		--build-arg REVISION=$(REVISION) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		-t $(DOCKER_IMAGE) .

.PHONY: docker-rebuild
docker-rebuild:
	docker build --no-cache \
		--build-arg VERSION=$(VERSION) \
		--build-arg REVISION=$(REVISION) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		-t $(DOCKER_IMAGE) .

# Ensure local data directory exists
.PHONY: data
data:
	mkdir -p ./data ./data/projects ./ollama_models
	chmod -R 777 ./data ./ollama_models

# Run the docker image (SSE default)
.PHONY: docker-run
docker-run: docker-run-sse

# Run the docker image with sse transport
.PHONY: docker-run-sse
docker-run-sse: data
	docker run --rm $(ENV_FILE_ARG) \
		-p $(PORT_SSE):$(PORT_SSE) -p $(PORT_METRICS):$(PORT_METRICS) \
		-v $(shell pwd)/data:/data \
		-e MODE=$(MODE) \
		-e PORT=$(PORT_SSE) \
		-e METRICS_PORT=$(PORT_METRICS) \
		$(DOCKER_IMAGE) -transport sse -addr :$(PORT_SSE) -sse-endpoint /sse

# Run the docker image with stdio transport
.PHONY: docker-run-stdio
docker-run-stdio: data
	docker run --rm $(ENV_FILE_ARG) \
		-v $(shell pwd)/data:/data \
		$(DOCKER_IMAGE) -transport stdio

# Run the docker image with multi-project mode (SSE)
.PHONY: docker-run-multi
docker-run-multi: data
	docker run --rm $(ENV_FILE_ARG) \
		-p $(PORT_SSE):$(PORT_SSE) -p $(PORT_METRICS):$(PORT_METRICS) \
		-v $(shell pwd)/data:/data \
		-e MODE=multi \
		-e PORT=$(PORT_SSE) \
		-e METRICS_PORT=$(PORT_METRICS) \
		$(DOCKER_IMAGE) -transport sse -addr :$(PORT_SSE) -sse-endpoint /sse -projects-dir /data/projects

# End-to-end docker test workflow
## Silence command echoing for docker-test target while still printing our own echoes
	.SILENT: docker-test
	.PHONY: docker-test
	docker-test: data
		echo "Checking for existing image $(DOCKER_IMAGE)..."; \
		# Prepare env-file for compose: prefer user-supplied ENV_FILE, otherwise ensure .env.ci exists and use it
		if [ -z "$(ENV_FILE)" ]; then \
			if [ ! -f .env.ci ]; then \
				# Create .env.ci. Do NOT set a global /data/libsql.db when running in multi mode.
				if [ "$(MODE)" = "multi" ]; then \
					cat > .env.ci <<'EOF'
EMBEDDING_DIMS=4
MODE=multi
PROJECTS_DIR=/data/projects
PORT=8090
METRICS_PORT=9090
SSE_ENDPOINT=/sse
EOF
				else \
					cat > .env.ci <<'EOF'
LIBSQL_URL=file:/data/libsql.db
EMBEDDING_DIMS=4
MODE=single
PROJECTS_DIR=/data/projects
PORT=8090
METRICS_PORT=9090
SSE_ENDPOINT=/sse
EOF
				fi; \
			fi; \
			env_file_arg="--env-file .env.ci"; \
		else \
			env_file_arg="--env-file $(ENV_FILE)"; \
		fi; \
		if docker image inspect $(DOCKER_IMAGE) >/dev/null 2>&1; then \
			echo "Found image $(DOCKER_IMAGE)"; \
		else \
			echo "Image $(DOCKER_IMAGE) not found; building..."; \
			$(MAKE) docker-build; \
		fi; \
		# Check for existing container for service 'memory'
		cid=$$(docker compose $$env_file_arg $(PROFILE_FLAGS) ps -q memory 2>/dev/null || true); \
		started=0; \
		if [ -n "$$cid" ]; then \
			running=$$(docker inspect -f '{{.State.Running}}' $$cid 2>/dev/null || echo false); \
			if [ "$$running" = "true" ]; then \
				echo "Service 'memory' already running (container $$cid)"; \
			else \
				echo "Service 'memory' container exists but not running; starting..."; \
				docker compose $$env_file_arg $(PROFILE_FLAGS) up -d memory; \
				started=1; \
			fi; \
		else \
			echo "No existing 'memory' container; starting..."; \
			docker compose $$env_file_arg $(PROFILE_FLAGS) up -d memory; \
			started=1; \
		fi; \
		# Wait for health (container health or metrics endpoint), up to 90s
		echo "Waiting for health (up to 90s)..."; \
		echo "Host data perms:"; ls -la ./data || true; \
		for i in $$(seq 1 90); do \
		  cid=$$(docker compose $$env_file_arg $(PROFILE_FLAGS) ps -q memory 2>/dev/null || true); \
		  if [ -n "$$cid" ]; then \
		    status=$$(docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{end}}' $$cid 2>/dev/null || true); \
		    if [ "$$status" = "healthy" ]; then echo "Container reported healthy"; break; fi; \
		  fi; \
		  if curl -fsS http://127.0.0.1:$(PORT_METRICS)/healthz >/dev/null 2>&1; then echo "Metrics endpoint healthy"; break; fi; \
		  sleep 1; \
		  if [ $$i -eq 90 ]; then \
		    echo "Health check timed out"; \
		    echo "--- docker compose ps ---"; \
		    docker compose $$env_file_arg $(PROFILE_FLAGS) ps; \
		    echo "--- Recent logs (memory) ---"; \
		    docker compose $$env_file_arg $(PROFILE_FLAGS) logs --tail=200 memory | cat; \
		    exit 1; \
		  fi; \
		done; \
		# Run integration tester against live SSE endpoint (increase timeout to 75s)
		go run $(INTEGRATION_TESTER) -sse-url http://127.0.0.1:$(PORT_SSE)/sse -project default -timeout 75s | tee integration-report.json; \
		# Tear down only if we started the containers
		if [ "$$started" = "1" ]; then \
			echo "Stopping containers brought up by test..."; \
			docker compose $$env_file_arg $(PROFILE_FLAGS) down; \
		else \
			echo "Leaving existing containers running"; \
		fi; \
		# Audit/report
		echo "--- Integration Test Report (integration-report.json) ---"; \
		cat integration-report.json | jq '.' || cat integration-report.json

# Compose helpers
.PHONY: compose-up compose-down compose-logs compose-ps
compose-up:
	docker compose $(PROFILE_FLAGS) up --build -d

compose-down:
	docker compose down $(if $(WITH_VOLUMES),-v,)

compose-logs:
	docker compose logs -f --tail=200 $(if $(SERVICE),$(SERVICE),)

compose-ps:
	docker compose ps

# Coolify production-style targets: separate build and run commands
.PHONY: coolify-prod-build coolify-prod-run coolify-prod-down coolify-prod-logs coolify-prod-ps

# Build the docker image and prepare data (no run)
coolify-prod-build: docker-build data
	@echo "Coolify: building image for production-style (multi-project, SSE, auth off, ollama)"

# Run using existing image (separate from build)
# Rely on environment variables provided by Coolify's UI or the shell. Do NOT inline-set ENVs here.
# Use COOLIFY_PROFILES (defaults to 'memory ollama') so both services are started by default
coolify-prod-run:
	@echo "Coolify: starting production-style (multi-project, SSE, auth off, ollama) (envs must be provided by environment/Coolify UI)"
	docker compose up -d

coolify-prod-down:
	@echo "Coolify: stopping production-style services"
	docker compose down $(if $(WITH_VOLUMES),-v,)

coolify-prod-logs:
	docker compose logs -f --tail=200 memory

coolify-prod-ps:
	docker compose ps

# Legacy docker-compose aliases (optional)
.PHONY: docker-compose
docker-compose: compose-up

# Production run profile (Ollama, SSE, multi-project, hybrid, pooling, metrics)
.PHONY: env-prod prod prod-down prod-logs prod-ps

# Generate a production env file used by compose
env-prod:
	@echo "Writing .env.prod..."
	@{ \
	  echo "EMBEDDINGS_PROVIDER=ollama"; \
	  echo "OLLAMA_HOST=http://ollama:11434"; \
	  echo "OLLAMA_EMBEDDINGS_MODEL=nomic-embed-text"; \
	  echo "EMBEDDING_DIMS=768"; \
	  echo "EMBEDDINGS_ADAPT_MODE=pad_or_truncate"; \
	  echo; \
	  echo "HYBRID_SEARCH=true"; \
	  echo "HYBRID_TEXT_WEIGHT=0.4"; \
	  echo "HYBRID_VECTOR_WEIGHT=0.6"; \
	  echo "HYBRID_RRF_K=60"; \
	  echo; \
	  echo "DB_MAX_OPEN_CONNS=16"; \
	  echo "DB_MAX_IDLE_CONNS=8"; \
	  echo "DB_CONN_MAX_IDLE_SEC=60"; \
	  echo "DB_CONN_MAX_LIFETIME_SEC=300"; \
	  echo; \
	  echo "METRICS_PROMETHEUS=true"; \
	  echo "METRICS_PORT=9090"; \
	  echo; \
	  echo "TRANSPORT=sse"; \
	  echo "PORT=8080"; \
	  echo "SSE_ENDPOINT=/sse"; \
	  echo; \
	  echo "# Multi-project auth toggles"; \
	  echo "MULTI_PROJECT_AUTH_REQUIRED=false"; \
	  echo "MULTI_PROJECT_AUTO_INIT_TOKEN=true"; \
	  echo "MULTI_PROJECT_DEFAULT_TOKEN=dev-token"; \
	  echo; \
	  echo "# Optional remote DB settings (leave blank for local files)"; \
	  echo "LIBSQL_URL="; \
	  echo "LIBSQL_AUTH_TOKEN="; \
	} > .env.prod

prod: docker-build data env-prod
	# Default prod: multi-project SSE, auth off, embeddings=ollama
	docker compose --env-file .env.prod --profile ollama --profile multi up --build -d

prod-down: env-prod
	docker compose --env-file .env.prod --profile ollama --profile multi down $(if $(WITH_VOLUMES),-v,)

prod-logs: env-prod
	docker compose --env-file .env.prod logs -f --tail=200 memory-multi

prod-ps: env-prod
	docker compose --env-file .env.prod ps

# VoyageAI profile env file
.PHONY: env-voyage voyage-up voyage-down
env-voyage:
	@echo "Writing .env.voyage..."
	@{ \
	  echo "EMBEDDINGS_PROVIDER=voyageai"; \
	  echo "VOYAGEAI_EMBEDDINGS_MODEL=voyage-3-lite"; \
	  echo "EMBEDDING_DIMS=1024"; \
	  echo "EMBEDDINGS_ADAPT_MODE=pad_or_truncate"; \
	  echo "TRANSPORT=sse"; \
	  echo "PORT=8080"; \
	  echo "SSE_ENDPOINT=/sse"; \
	  echo "METRICS_PROMETHEUS=true"; \
	  echo "METRICS_PORT=9090"; \
	  echo "HYBRID_SEARCH=true"; \
	} > .env.voyage

voyage-up: docker-build data env-voyage
	docker compose --env-file .env.voyage --profile voyageai up --build -d

voyage-down: env-voyage
	docker compose --env-file .env.voyage --profile voyageai down $(if $(WITH_VOLUMES),-v,)


# Clean build artifacts
.PHONY: clean
clean:
	rm -f $(BINARY_LOCATION)

# Install the binary globally
.PHONY: install
install:
	@echo "Installing $(BINARY_NAME) globally..."
	@chmod +x install.sh
	./install.sh $(BINARY_LOCATION)

# Help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all - Build the project (default)"
	@echo "  build - Build the binary"
	@echo "  deps - Install dependencies"
	@echo "  test - Run tests"
	@echo "  run - Build and run the server"
	@echo "  clean - Clean build artifacts"
	@echo "  docker - Build the docker image (alias of docker-build)"
	@echo "  docker-build - Build the docker image"
	@echo "  docker-rebuild - Build the docker image with --no-cache"
	@echo "  docker-run - Run container (SSE, mounts ./data)"
	@echo "  docker-run-stdio - Run container (stdio)"
	@echo "  docker-run-multi - Run container (SSE, multi-project mode)"
	@echo "  docker-test - Run end-to-end docker test workflow"
	@echo "  compose-up - docker compose up (use PROFILES=single|multi|ollama|localai)"
	@echo "  compose-down - docker compose down (WITH_VOLUMES=1 to remove volumes)"
	@echo "  compose-logs - docker compose logs (SERVICE=memory)"
	@echo "  compose-ps - docker compose ps"
	@echo "  install - Install the binary globally"
	@echo "  help    - Show this help message"

