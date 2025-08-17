Deploying mcp-memory-libsql-go on Coolify
======================================

This guide explains deploying the service on Coolify, how to configure the
bind-mount for project data, recommended environment variables, and backup
strategies.

1) Prepare host directories
---------------------------
On the Coolify host (or a node accessible to your Coolify instance) create
the application data and backup directories that will be bind-mounted into the
container:

sudo mkdir -p /data/coolify/applications/<id>
sudo mkdir -p /data/coolify/backups/<id>
sudo chown root:root /data/coolify/applications/<id>

2) Recommended service configuration
------------------------------------
- Image: `ghcr.io/zanzythebar/mcp-memory-libsql-go:latest` (or your built image)
- Command / Mode: `MODE=multi` and `PROJECTS_DIR=/data/projects`
- Bind-mount: `/data/coolify/applications/<id>` → `/data`
- Backups: `/data/coolify/backups/<id>` → `/backup` (if using the included backup container)

Example environment variables (set in Coolify):
- `PROJECTS_UID`: 1000
- `PROJECTS_GID`: 1000
- `HOST_UID` / `HOST_GID`: optional, if you want the container process to run
  as a specific host uid/gid

3) Coolify-specific notes
-------------------------
- Coolify will manage the container lifecycle; ensure the host path exists
  before launching the service so the bind mount succeeds.
- If you need the host (Coolify) to access files as a different user, use
  `PROJECTS_GID` to choose a shared group and ensure both sides have group
  permissions (the entrypoint sets SGID and ACLs).

4) Backups
----------
You can use the included `backup` service in `docker-compose.coolify.yml`,
which tars `/data` hourly into the bind-mounted backup path. Alternatively,
use your own backup tooling to snapshot `/data/coolify/applications/<id>`.

5) Testing & validation
-----------------------
- Use the `build_and_test.sh` script locally to validate the image behavior.
- The container's entrypoint performs an init step at startup to ensure
  `/data` is owned by `PROJECTS_UID:PROJECTS_GID` and that SGID/ACLs are
  applied so the `app` user can create project directories at runtime.


