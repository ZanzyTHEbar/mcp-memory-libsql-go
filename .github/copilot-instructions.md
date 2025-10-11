# GitHub Copilot Instructions for mcp-memory-libsql-go

This document provides guidance for GitHub Copilot when working on this repository.

## Project Overview

`mcp-memory-libsql-go` is a high-performance Go implementation of the MCP (Model Context Protocol) Memory Server using libSQL for persistent storage with vector search capabilities. It provides:

- **Persistent Knowledge Graph**: Store entities, observations, and relations
- **Vector Search**: Cosine similarity search using libSQL's vector capabilities
- **Hybrid Search**: Combines semantic and vector search using RRF (Reciprocal Rank Fusion)
- **Multi-Project Support**: Manage separate databases for multiple projects
- **Multiple Transports**: stdio and SSE (Server-Sent Events)
- **Multiple Embeddings Providers**: OpenAI, Ollama, Google Gemini, Vertex AI, LocalAI, VoyageAI

## Technology Stack

- **Language**: Go 1.24.3
- **Database**: libSQL (SQLite fork by Turso)
- **Database Driver**: `tursodatabase/go-libsql`
- **MCP SDK**: `modelcontextprotocol/go-sdk`
- **Metrics**: Prometheus (optional)
- **Testing**: `stretchr/testify`

## Code Organization

```
.
├── cmd/
│   ├── mcp-memory-libsql-go/     # Main server binary
│   └── integration-tester/        # Integration testing tool
├── internal/
│   ├── apptype/                   # Application type definitions
│   ├── buildinfo/                 # Build metadata
│   ├── database/                  # Database operations and schema
│   ├── embeddings/                # Embeddings provider implementations
│   ├── metrics/                   # Prometheus metrics
│   └── server/                    # MCP server implementation
├── prompts/                       # External prompt definitions (.prompt, .json)
├── docker/                        # Docker and compose files
└── docs/                          # Additional documentation
```

## Coding Standards

### Go Conventions

1. **Formatting**: Always run `gofmt -w .` before committing
2. **Linting**: Run `go vet ./...` to catch common issues
3. **Testing**: Run `go test ./...` to verify all tests pass
4. **Conventional Commits**: Use conventional commit format for commit messages:
   - `feat:` for new features
   - `fix:` for bug fixes
   - `docs:` for documentation changes
   - `refactor:` for code refactoring
   - `test:` for test additions/changes
   - `chore:` for maintenance tasks

### Code Style

- Use Go idioms and standard library patterns
- Keep functions focused and testable
- Prefer explicit error handling over panic
- Use context.Context for cancellation and timeouts
- Document exported functions and types
- Minimize external dependencies
- Use table-driven tests where appropriate

### Environment Variables

The server supports extensive environment-based configuration. When adding new configuration:

1. Document it in `README.md` under the "Environment Variables" section
2. Use sensible defaults
3. Validate configuration at startup
4. Use typed configuration structs in `internal/apptype`

Common environment variables:
- `MODE`: `single` or `multi` (project mode)
- `LIBSQL_URL`: Database connection URL
- `EMBEDDINGS_PROVIDER`: `openai`, `ollama`, `gemini`, `vertexai`, `localai`, `voyageai`
- `EMBEDDING_DIMS`: Vector dimensions (provider-specific)
- `HYBRID_SEARCH`: Enable hybrid search (true/false)
- `METRICS_PROMETHEUS`: Enable Prometheus metrics (true/false)
- `TRANSPORT`: `stdio` or `sse`

## Build and Test Workflow

### Local Development

```bash
# Build the binary
make build

# Run tests
make test

# Run the server locally
make run

# Install globally
make install
```

### Docker Development

```bash
# Build Docker image
make docker

# Run with SSE transport
make docker-run

# Run with multi-project mode
make docker-run-multi

# Run integration tests
make docker-test
```

### Docker Compose Profiles

```bash
# Production mode with Ollama embeddings
make prod

# With VoyageAI embeddings
make voyage-up

# Coolify deployment
make coolify-prod-build
make coolify-prod-run
```

## Testing Guidelines

1. **Unit Tests**: Write tests for all public functions and methods
2. **Table-Driven Tests**: Use table-driven tests for multiple test cases
3. **Integration Tests**: Use `cmd/integration-tester` for end-to-end testing
4. **Test Coverage**: Aim for meaningful coverage, not just high percentages
5. **Mocking**: Use interfaces to enable testing with mocks
6. **Test Data**: Use fixtures or test databases, never production data

Example test structure:
```go
func TestFunctionName(t *testing.T) {
    tests := []struct {
        name    string
        input   string
        want    string
        wantErr bool
    }{
        {"case 1", "input1", "output1", false},
        {"error case", "bad", "", true},
    }
    
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            got, err := FunctionName(tt.input)
            if (err != nil) != tt.wantErr {
                t.Errorf("error = %v, wantErr %v", err, tt.wantErr)
                return
            }
            if got != tt.want {
                t.Errorf("got %v, want %v", got, tt.want)
            }
        })
    }
}
```

## Database Schema

The database uses libSQL with the following key tables:

- `entities`: Knowledge graph nodes (name, entity_type, observations)
- `relations`: Edges between entities (from, to, relation_type)
- `entities_fts`: Full-text search index (when FTS5 available)
- Vector search columns for embeddings

### Database Migrations

- Schema initialization happens at server startup
- Vector table creation is conditional based on `EMBEDDING_DIMS`
- FTS5 support is detected and used when available
- Always test schema changes with both local and remote libSQL

## MCP Prompts

Prompts are stored in the `prompts/` directory as either:

1. **`.prompt` files**: Dotprompt format with YAML frontmatter
2. **`.json` files**: Direct MCP prompt JSON

When adding new prompts:
- Use `.prompt` format for rich metadata
- Include `name`, `description`, and `input.schema` in frontmatter
- Test prompt loading on server startup
- Document prompts in `README.md`

## Embeddings Providers

When adding a new embeddings provider:

1. Create a new file in `internal/embeddings/`
2. Implement the `Provider` interface:
   ```go
   type Provider interface {
       Name() string
       Dimensions() int
       Embed(ctx context.Context, inputs []string) ([][]float32, error)
   }
   ```
3. Register in `SelectProvider()` function
4. Add environment variable documentation
5. Add provider-specific model dimensions to README table
6. Include example curl verification

## Docker Guidelines

1. **Dockerfile**: Keep `docker/Dockerfile` minimal and multi-stage
2. **Compose Files**: Use profiles for different deployment scenarios
3. **Environment Variables**: Never hardcode credentials
4. **Bind Mounts**: Use `/data` for persistence
5. **Health Checks**: Include health check endpoints
6. **User Permissions**: Handle UID/GID mapping for mounted volumes

## Multi-Project Mode

When working on multi-project features:

- Projects are identified by slug (e.g., `owner/repo`)
- Each project gets its own database in `PROJECTS_DIR`
- Authentication is optional via `MULTI_PROJECT_AUTH_REQUIRED`
- Auto-initialization can create project DBs on first access

## Common Tasks

### Adding a New Tool

1. Define the tool in `internal/server/tools.go`
2. Implement the handler function
3. Register with MCP server
4. Add tests in `internal/server/tools_test.go`
5. Document in `README.md`

### Adding a New Embeddings Provider

1. Create `internal/embeddings/<provider>.go`
2. Implement `Provider` interface
3. Add to `SelectProvider()` switch
4. Document environment variables
5. Add verification example
6. Update dimension mapping table

### Updating Docker Images

1. Modify `docker/Dockerfile`
2. Update `Makefile` if needed
3. Test with `make docker-test`
4. Update `.github/workflows/release.yml` if changing build args
5. Document changes in `docs/deployment.md`

## Security Considerations

1. **Never commit secrets**: Use `.env` files (gitignored) or CI secrets
2. **Validate inputs**: Sanitize all user inputs
3. **SQL injection**: Use parameterized queries (libSQL handles this)
4. **Authentication**: Multi-project mode supports optional API key auth
5. **CORS**: Configure appropriately for SSE transport

## CI/CD

The repository uses GitHub Actions:

- **`ci.yml`**: Run tests on every push
- **`ci-docker-test.yml`**: Integration tests with Docker
- **`release.yml`**: Build and publish releases
- **`backup-publish.yml`**: Backup service publishing

When modifying CI:
- Test locally first
- Use appropriate secrets
- Follow conventional commits for changelog generation
- Update workflow documentation if changing behavior

## Performance Considerations

1. **Database Pooling**: Configure `DB_MAX_OPEN_CONNS`, `DB_MAX_IDLE_CONNS`
2. **Batch Operations**: Use batch inserts/updates where possible
3. **Vector Search**: Consider index creation for large datasets
4. **Hybrid Search**: Tune `HYBRID_TEXT_WEIGHT`, `HYBRID_VECTOR_WEIGHT`, `HYBRID_RRF_K`
5. **Caching**: Provider responses are not cached by default

## Troubleshooting

### Common Issues

1. **FTS5 not available**: Falls back to LIKE queries automatically
2. **Vector search failing**: Check `EMBEDDING_DIMS` matches provider
3. **Permission errors**: Check `PROJECTS_UID`, `PROJECTS_GID`, `SKIP_CHOWN`
4. **Embedding dimension mismatch**: Server auto-adapts via `EMBEDDINGS_ADAPT_MODE`

### Debug Mode

Enable verbose logging by setting log level environment variables if implemented.

## Documentation

Always update documentation when making changes:

- `README.md`: User-facing features and usage
- `docs/CONTRIBUTING.md`: Contribution guidelines
- `docs/deployment.md`: Deployment instructions
- `docs/COOLIFY_DEPLOYMENT.md`: Coolify-specific deployment
- `prompts/README.md`: Prompt loading system
- API documentation: Keep inline comments up to date

## Related Resources

- [MCP Specification](https://modelcontextprotocol.io/)
- [libSQL Documentation](https://docs.turso.tech/)
- [Go Best Practices](https://go.dev/doc/effective_go)
- [Conventional Commits](https://www.conventionalcommits.org/)

## Key Principles

1. **Minimal Dependencies**: Only add dependencies when necessary
2. **Backward Compatibility**: Don't break existing APIs without version bump
3. **Idempotency**: Operations should be safe to retry
4. **Graceful Degradation**: Fall back when optional features unavailable
5. **Clear Error Messages**: Help users understand what went wrong
6. **Performance**: Go was chosen for speed; maintain that advantage
7. **Documentation**: Code is read more than written

## Questions?

Refer to:
- `docs/CONTRIBUTING.md` for contribution workflow
- `README.md` for feature documentation
- GitHub issues for known problems and discussions
- Code comments for implementation details
