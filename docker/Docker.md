Docker / deployment notes for mcp-memory-libsql-go
===============================================

This file documents recommended runtime environment variables, permission handling,
backup/restore commands, and quick test scripts for containerized deployments.

Recommended environment variables
---------------------------------
- `MODE` - `single|multi|voyageai` (default: `single`)
- `PORT` - main service port (default 8090 via compose)
- `PROJECTS_DIR` - directory inside the container for dynamic projects (default `/data/projects`)
- `PROJECTS_UID` / `PROJECTS_GID` - UID/GID that should own `PROJECTS_DIR` (defaults: 1000)
- `HOST_UID` / `HOST_GID` - if you run the container as a specific host uid/gid via compose `user:` setting

Installing privilege-drop helper and ACLs
----------------------------------------
The container image includes `gosu` and `acl` so the entrypoint can:
- chown the mount to `PROJECTS_UID:PROJECTS_GID`
- set SGID on `PROJECTS_DIR` (chmod 2775)
- set default ACLs so new subdirectories inherit group rwx permissions
- drop privileges to the `app` user using `gosu` or `su-exec`

Compose usage (bind mount)
--------------------------
Use a single bind mount for all projects, since projects are created dynamically:

services:
  memory:
    image: ghcr.io/zanzythebar/mcp-memory-libsql-go:latest
    environment:
      - MODE=multi
      - PROJECTS_DIR=/data/projects
      - PROJECTS_UID=1000
      - PROJECTS_GID=1000
    volumes:
      - type: bind
        source: /data/coolify/applications/<id>
        target: /data
        bind:
          create_host_path: true
    user: "${HOST_UID:-}:${HOST_GID:-}"

Backup & restore (named-volume equivalent approach using tar)
------------------------------------------------------------
To backup the bind-mounted data (example writes to /tmp/backup on host):

docker run --rm -v /data/coolify/applications/<id>:/data -v /tmp/backup:/backup alpine \
  sh -c "tar czf /backup/project_data_<id>.tgz -C /data ."

To restore:
docker run --rm -v /data/coolify/applications/<id>:/data -v /tmp/backup:/backup alpine \
  sh -c "tar xzf /backup/project_data_<id>.tgz -C /data"

Quick test & validation
------------------------
Run the included helper scripts inside the container (or during image build) to
create the `app` user and validate permissions:

Inside container (as root):
  /scripts/create_app_user_helper.sh
  /scripts/permission_test.sh /data/projects

Note: The entrypoint now performs an explicit init step at container startup
which will ensure mounted bind paths (like `/data`) are chowned and have the
SGID/ACLs required for runtime creation of project directories. The helper
scripts are still useful for local testing and CI.

Notes on multi-tenant access
---------------------------
- If Coolify (host) needs to access project files, choose PROJECTS_GID to be a
  group both host side and container side can use. Use SGID + ACLs so both
  parties can read/write.
- If you must preserve host ownership of files, do not chown the mount; instead
  add `app` to the host group and rely on SGID/ACLs to allow write access.


