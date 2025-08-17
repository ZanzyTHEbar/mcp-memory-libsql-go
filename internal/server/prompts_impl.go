package server

import (
	"context"
	"reflect"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

// setupPromptsImpl delegates prompt registration to external files under ./prompts.
// It prefers .prompt (dotprompt-style) files parsed by LoadDotPrompts, and
// falls back to JSON prompt files parsed by LoadExternalPrompts.
func setupPromptsImpl(s *MCPServer) {
	// Try dotprompt files first
	if dot, err := LoadDotPrompts("./prompts"); err == nil && len(dot) > 0 {
		for _, p := range dot {
			// ensure slice fields are non-nil
			v := reflect.ValueOf(p).Elem()
			for i := 0; i < v.NumField(); i++ {
				f := v.Field(i)
				if f.Kind() == reflect.Slice && f.IsNil() && f.CanSet() {
					f.Set(reflect.MakeSlice(f.Type(), 0, 0))
				}
			}
			pcopy := p
			s.server.AddPrompt(pcopy, func(ctx context.Context, session *mcp.ServerSession, params *mcp.GetPromptParams) (*mcp.GetPromptResult, error) {
				return &mcp.GetPromptResult{Description: pcopy.Description}, nil
			})
			s.RegisteredPrompts = append(s.RegisteredPrompts, pcopy)
		}
		return
	}

	// Fallback: JSON prompt files
	if ext, err := LoadExternalPrompts("./prompts"); err == nil && len(ext) > 0 {
		for _, p := range ext {
			v := reflect.ValueOf(p).Elem()
			for i := 0; i < v.NumField(); i++ {
				f := v.Field(i)
				if f.Kind() == reflect.Slice && f.IsNil() && f.CanSet() {
					f.Set(reflect.MakeSlice(f.Type(), 0, 0))
				}
			}
			pcopy := p
			s.server.AddPrompt(pcopy, func(ctx context.Context, session *mcp.ServerSession, params *mcp.GetPromptParams) (*mcp.GetPromptResult, error) {
				return &mcp.GetPromptResult{Description: pcopy.Description}, nil
			})
			s.RegisteredPrompts = append(s.RegisteredPrompts, pcopy)
		}
		return
	}

	// Nothing to register if no external prompt files found.
}
