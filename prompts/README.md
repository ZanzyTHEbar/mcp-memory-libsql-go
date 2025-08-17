Prompt files directory
======================

This directory contains external prompt definitions used by the MCP server.

Supported formats (in order of precedence):

- `.prompt` — dotprompt-style files with YAML frontmatter (between `---` markers) and a Handlebars-style body. We support a minimal subset: frontmatter `name`, `description`, and `input.schema` keys are mapped to `mcp.Prompt` fields and `PromptArgument`s. Use `.prompt` when you want rich metadata.

- `.json` — simple JSON files that directly map to the `mcp.Prompt` struct. Useful when you want to avoid template parsing.

How prompts are loaded
----------------------

1. On server startup `setupPrompts` calls `setupPromptsImpl` which:
   - Attempts to load all `.prompt` files via `LoadDotPrompts("./prompts")`.
   - If none are found, falls back to `LoadExternalPrompts("./prompts")` which reads `.json` files.
   - Each prompt is registered with the server via `safeAddPrompt`, which normalizes nil slices to empty arrays to avoid `null` in JSON.

Adding or editing prompts
-------------------------

- Add a new `.prompt` or `.json` file to this directory. Filenames are used as default prompt `Name` when frontmatter `name` is not provided.
- After modifying prompts, restart the server to reload prompt definitions.

Dotprompt notes
---------------

We added a minimal dotprompt loader that extracts YAML frontmatter and body without depending on Genkit. A Genkit-based loader is available as a build-tagged prototype (`internal/server/genkit_dotprompt_loader.go`) — to enable it, build with `-tags genkit` and add the `github.com/firebase/genkit` dependency.

Why external prompts?
----------------------

- Easier to maintain: prompts live as files, versioned alongside code.
- Allows non-developers to edit prompts safely.
- Enables future migration to full dotprompt/Genkit integration.


