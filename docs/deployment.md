Deployment & Docker consolidation
================================

What changed
------------
- All primary Docker assets have been consolidated under the `docker/` directory for clarity and maintainability.
- The repository root `docker-compose.yaml` is intentionally kept in the repo root (it's the canonical compose file used by `make docker-test` and developers). Other compose examples and auxiliary compose files have been moved to `docker/`:
  - `docker/docker-compose.memory.yml` — memory service compose snippet for local builds
  - `docker/docker-compose.backup.yml` — backup service compose snippet
  - `docker/docker-compose.raw.yaml` — upstream/raw published compose (kept for reference)
  - `docker/docker-compose.example.yml` — developer example
  - `docker/Dockerfile` — canonical Dockerfile used for CI and local builds

How to build locally
---------------------
1. Ensure prerequisites: Docker, Go toolchain.
2. Build the binary locally:

   ```sh
   make deps
   make build
   ```

3. Build the Docker image (uses consolidated `docker/Dockerfile`):

   ```sh
   make docker-build
   ```

4. Run services via the canonical root compose file:

   ```sh
   docker compose up -d
   ```

Notes and best practices
------------------------
- Keep `docker-compose.yaml` at repo root (this file is the canonical compose used by CI and `make docker-test`). Other compose files in `docker/` are supporting artifacts for examples and reference.
- DO NOT commit secrets to ENV/ARG in Dockerfiles. Use `.env` files or CI secrets for production credentials.
- When updating Dockerfiles, update `Makefile` if the Dockerfile path changes (current `Makefile` references `-f docker/Dockerfile`).

Rollback
--------
If you need to restore previous layout, you can refer to the moved files under `docker/` — they contain the original contents and can be copied back.


