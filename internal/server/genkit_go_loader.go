//go:build genkit_go
// +build genkit_go

package server

import (
	"fmt"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

// LoadDotPromptsGenkit is a build-tagged prototype to integrate Genkit's Go
// ecosystem with dotprompt files. This file is compiled only when building with
// the `genkit_go` tag to avoid pulling the Genkit dependency into normal
// development builds.

// To enable and use this prototype:
// 1. Add Genkit and any model plugin you want (example Google plugin):
//    go get github.com/firebase/genkit/go
//    go get github.com/firebase/genkit/go/plugins/googlegenai
// 2. Build/run with the tag: `go run -tags genkit_go ./cmd/...` or `go test -tags genkit_go`.

// The implementation is intentionally left as a guide. To implement full
// parsing + rendering with Genkit, import the Genkit packages and use
// genkit.Init(...) and the plugin APIs to parse and render .prompt templates
// with proper model configuration and credentialing.
func LoadDotPromptsGenkit(dir string) ([]*mcp.Prompt, error) {
	return nil, fmt.Errorf("genkit_go prototype not implemented; enable with -tags genkit_go and implement integration using github.com/firebase/genkit/go")
}
