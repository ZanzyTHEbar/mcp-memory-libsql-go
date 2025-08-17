package server

import (
	"encoding/json"
	"io/ioutil"
	"path/filepath"

	"github.com/modelcontextprotocol/go-sdk/mcp"
)

// LoadExternalPrompts loads prompt definitions from JSON files in dir (non-recursive).
// Each file should contain a JSON representation of mcp.Prompt.
func LoadExternalPrompts(dir string) ([]*mcp.Prompt, error) {
	var out []*mcp.Prompt
	entries, err := ioutil.ReadDir(dir)
	if err != nil {
		return nil, err
	}
	for _, e := range entries {
		if e.IsDir() {
			continue
		}
		name := e.Name()
		if filepath.Ext(name) != ".json" {
			continue
		}
		b, err := ioutil.ReadFile(filepath.Join(dir, name))
		if err != nil {
			return nil, err
		}
		var p mcp.Prompt
		if err := json.Unmarshal(b, &p); err != nil {
			return nil, err
		}
		// ensure nil slices are empty
		if p.Arguments == nil {
			p.Arguments = []*mcp.PromptArgument{}
		}
		out = append(out, &p)
	}
	return out, nil
}
