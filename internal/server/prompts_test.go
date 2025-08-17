package server

import (
	"bytes"
	"encoding/json"
	"reflect"
	"testing"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

// recursively scan a value for *mcp.Prompt pointers
func collectPrompts(v reflect.Value, seen map[uintptr]bool) []*mcp.Prompt {
	var out []*mcp.Prompt
	if !v.IsValid() {
		return out
	}
	// unwrap pointers and interfaces
	for v.Kind() == reflect.Ptr || v.Kind() == reflect.Interface {
		if v.IsNil() {
			return out
		}
		ptr := v.Pointer()
		if seen[ptr] {
			return out
		}
		seen[ptr] = true
		v = v.Elem()
	}

	switch v.Kind() {
	case reflect.Struct:
		// If this is an mcp.Prompt value
		if v.Type() == reflect.TypeOf(mcp.Prompt{}) {
			if v.CanAddr() {
				p := v.Addr().Interface().(*mcp.Prompt)
				out = append(out, p)
			}
			return out
		}
		// scan exported fields only to avoid panics on unexported field Interface()
		for i := 0; i < v.NumField(); i++ {
			f := v.Field(i)
			if !f.IsValid() {
				continue
			}
			// skip unexported fields we cannot Interface
			if !f.CanInterface() {
				continue
			}
			out = append(out, collectPrompts(f, seen)...)
		}
	case reflect.Slice, reflect.Array:
		for i := 0; i < v.Len(); i++ {
			out = append(out, collectPrompts(v.Index(i), seen)...)
		}
	case reflect.Map:
		for _, k := range v.MapKeys() {
			out = append(out, collectPrompts(v.MapIndex(k), seen)...)
		}
	}
	return out
}

func TestPromptsHaveNoNullSlices(t *testing.T) {
	// Create a server instance and register prompts
	srv := mcp.NewServer(&mcp.Implementation{Name: "test", Version: "v0"}, nil)
	s := &MCPServer{server: srv, db: nil}
	s.setupPrompts()

	// use RegisteredPrompts cache populated by safeAddPrompt
	prompts := s.RegisteredPrompts
	if len(prompts) == 0 {
		t.Fatalf("no prompts registered via safeAddPrompt")
	}

	for _, p := range prompts {
		b, err := json.Marshal(p)
		if err != nil {
			t.Fatalf("failed to marshal prompt %v: %v", p, err)
		}
		if bytes.Contains(b, []byte(": null")) {
			t.Errorf("prompt %q JSON contains null slice: %s", p.Name, string(b))
		}
	}
}
