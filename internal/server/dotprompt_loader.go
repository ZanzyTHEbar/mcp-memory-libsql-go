package server

import (
	"os"
	"path/filepath"
	"strings"

	"github.com/modelcontextprotocol/go-sdk/mcp"
	"gopkg.in/yaml.v3"
)

// LoadDotPrompts loads simple dotprompt-format files (.prompt) from dir (non-recursive).
// This is a lightweight parser: it extracts YAML frontmatter and the body. It maps
// frontmatter.input.schema keys to PromptArgument entries.
func LoadDotPrompts(dir string) ([]*mcp.Prompt, error) {
	var out []*mcp.Prompt
	entries, err := ioutil.ReadDir(dir)
	if err != nil {
		return nil, err
	}
	for _, e := range entries {
		if e.IsDir() {
			continue
		}
		if filepath.Ext(e.Name()) != ".prompt" {
			continue
		}
		b, err := ioutil.ReadFile(filepath.Join(dir, e.Name()))
		if err != nil {
			return nil, err
		}
		s := string(b)
		name := strings.TrimSuffix(e.Name(), ".prompt")
		var front map[string]interface{}
		body := s
		if strings.HasPrefix(s, "---") {
			parts := strings.SplitN(s, "---", 3)
			if len(parts) >= 3 {
				// parts[1] is frontmatter
				if err := yaml.Unmarshal([]byte(parts[1]), &front); err != nil {
					// ignore parse error, treat whole file as body
					front = nil
				} else {
					body = strings.TrimSpace(parts[2])
				}
			}
		}
		p := &mcp.Prompt{Name: name, Description: body}
		// if front has name/description override
		if front != nil {
			if v, ok := front["name"].(string); ok && v != "" {
				p.Name = v
			}
			if v, ok := front["description"].(string); ok && v != "" {
				p.Description = v + "\n\n" + p.Description
			}
			if inp, ok := front["input"].(map[string]interface{}); ok {
				if schema, sok := inp["schema"].(map[string]interface{}); sok {
					for k := range schema {
						p.Arguments = append(p.Arguments, &mcp.PromptArgument{Name: k, Description: "", Required: false})
					}
				}
			}
		}
		// ensure non-nil slices
		if p.Arguments == nil {
			p.Arguments = []*mcp.PromptArgument{}
		}
		out = append(out, p)
	}
	return out, nil
}
