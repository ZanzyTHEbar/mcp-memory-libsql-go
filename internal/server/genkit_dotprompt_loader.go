//go:build genkit
// +build genkit

package server

// This file provides an optional prototype integration with the Genkit dotprompt
// plugin. It's guarded by the `genkit` build tag so regular builds remain
// lightweight and do not pull the genkit dependency unless explicitly enabled.

import (
	"fmt"

	"github.com/modelcontextprotocol/go-sdk/mcp"
	// genkit dotprompt plugin would be imported when enabling this build tag
	// "github.com/firebase/genkit/go/plugins/dotprompt"
)

// LoadDotPromptsGenkit is a prototype entrypoint that would use the genkit
// dotprompt plugin to parse and render .prompt files with full feature parity
// (templating, picoschema parsing, etc.). This file is intentionally a stub
// to avoid introducing the dependency into normal builds. To enable the real
// implementation, build with `-tags genkit` and uncomment the genkit import
// and implementation below.
func LoadDotPromptsGenkit(dir string) ([]*mcp.Prompt, error) {
	// Example high-level flow (pseudocode):
	// 1. Walk dir for .prompt files
	// 2. For each file, use dotprompt.ParseFile or equivalent to get template + metadata
	// 3. Map metadata.name, metadata.description, metadata.input.schema to mcp.Prompt
	// 4. Return []*mcp.Prompt

	return nil, fmt.Errorf("genkit dotprompt loader not enabled; build with -tags genkit to enable prototype")
}
