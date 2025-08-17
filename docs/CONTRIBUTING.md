Contributing
============

Quick checklist for contributors
--------------------------------

1. Run formatting and basic checks before opening a PR:

   ```sh
   gofmt -w .
   go vet ./...
   go test ./...
   ```

2. When changing Docker assets:
   - Put new Dockerfiles or compose examples under `docker/`.
   - Keep `docker-compose.yaml` in the repository root if you intend the change to affect the canonical developer flow.
   - Update `Makefile` and `.github/workflows/release.yml` if you move the main Dockerfile.

3. Write tests for new behavior and run the full test suite.

4. Follow Conventional Commits for commit messages so the release pipeline produces changelogs.

5. If adding secrets or credentials, never commit them. Use CI secrets or `.env` files listed in `.gitignore`.

Thanks for contributing!


