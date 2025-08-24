package database

import (
	"encoding/json"
	"testing"

	"github.com/ZanzyTHEbar/mcp-memory-libsql-go/internal/errs"
)

func TestTypedErrorsBackwardsCompatibility(t *testing.T) {
	// Test that NewDBManager returns proper typed errors for invalid embedding dims
	tests := []struct {
		name         string
		embeddingDims int
		wantCode     errs.Code
		wantJSON     bool
	}{
		{
			name:         "too small dims",
			embeddingDims: 0,
			wantCode:     errs.CodeInvalidArgument,
			wantJSON:     true,
		},
		{
			name:         "too large dims", 
			embeddingDims: 70000,
			wantCode:     errs.CodeInvalidArgument,
			wantJSON:     true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			config := &Config{
				EmbeddingDims: tt.embeddingDims,
			}
			
			_, err := NewDBManager(config)
			if err == nil {
				t.Errorf("NewDBManager() expected error but got nil")
				return
			}
			
			// Check if it's a typed error
			var typedErr *errs.Error
			if !errs.AsTypedError(err, &typedErr) {
				t.Errorf("Expected typed error, got: %T", err)
				return
			}
			
			// Check error code
			if typedErr.Code() != tt.wantCode {
				t.Errorf("Error code = %v, want %v", typedErr.Code(), tt.wantCode)
			}
			
			// Check JSON backwards compatibility
			if tt.wantJSON {
				errorStr := err.Error()
				var errorData map[string]interface{}
				if err := json.Unmarshal([]byte(errorStr), &errorData); err != nil {
					t.Errorf("Error.Error() output is not valid JSON: %v", err)
				}
				
				errorInfo, ok := errorData["error"].(map[string]interface{})
				if !ok {
					t.Errorf("Error.Error() missing 'error' field")
				}
				
				if code, ok := errorInfo["code"].(string); !ok || code != string(tt.wantCode) {
					t.Errorf("Error.Error() code = %v, want %v", code, string(tt.wantCode))
				}
				
				// Check for value in context
				if value, ok := errorInfo["value"].(float64); !ok || int(value) != tt.embeddingDims {
					t.Errorf("Error.Error() value = %v, want %v", value, tt.embeddingDims)
				}
			}
		})
	}
}