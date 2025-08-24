package errs

import (
	"encoding/json"
	"errors"
	"testing"
)

func TestErrorCodes(t *testing.T) {
	tests := []struct {
		name string
		code Code
		want string
	}{
		{"invalid argument", CodeInvalidArgument, "INVALID_ARGUMENT"},
		{"not found", CodeNotFound, "NOT_FOUND"},
		{"already exists", CodeAlreadyExists, "ALREADY_EXISTS"},
		{"permission denied", CodePermissionDenied, "PERMISSION_DENIED"},
		{"unauthenticated", CodeUnauthenticated, "UNAUTHENTICATED"},
		{"failed precondition", CodeFailedPrecondition, "FAILED_PRECONDITION"},
		{"internal", CodeInternal, "INTERNAL"},
		{"unavailable", CodeUnavailable, "UNAVAILABLE"},
		{"unsupported", CodeUnsupported, "UNSUPPORTED"},
		{"conflict", CodeConflict, "CONFLICT"},
	}
	
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := tt.code.String(); got != tt.want {
				t.Errorf("Code.String() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestErrorHelpers(t *testing.T) {
	tests := []struct {
		name         string
		err          *Error
		wantCode     Code
		wantMessage  string
		wantJSONCode string
	}{
		{
			name:         "invalid argument",
			err:          InvalidArg("invalid dims", "value", 42),
			wantCode:     CodeInvalidArgument,
			wantMessage:  "invalid dims",
			wantJSONCode: "INVALID_ARGUMENT",
		},
		{
			name:         "not found",
			err:          NotFound("entity", "name", "test"),
			wantCode:     CodeNotFound,
			wantMessage:  "entity not found",
			wantJSONCode: "NOT_FOUND",
		},
		{
			name:         "already exists",
			err:          AlreadyExists("entity", "name", "test"),
			wantCode:     CodeAlreadyExists,
			wantMessage:  "entity already exists",
			wantJSONCode: "ALREADY_EXISTS",
		},
		{
			name:         "internal error",
			err:          Internal(errors.New("database error")),
			wantCode:     CodeInternal,
			wantMessage:  "database error",
			wantJSONCode: "INTERNAL",
		},
	}
	
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if tt.err.Code() != tt.wantCode {
				t.Errorf("Error.Code() = %v, want %v", tt.err.Code(), tt.wantCode)
			}
			
			if tt.err.Message() != tt.wantMessage {
				t.Errorf("Error.Message() = %v, want %v", tt.err.Message(), tt.wantMessage)
			}
			
			// Test JSON output for backwards compatibility
			errorStr := tt.err.Error()
			var errorData map[string]interface{}
			if err := json.Unmarshal([]byte(errorStr), &errorData); err != nil {
				t.Errorf("Error.Error() output is not valid JSON: %v", err)
			}
			
			errorInfo, ok := errorData["error"].(map[string]interface{})
			if !ok {
				t.Errorf("Error.Error() missing 'error' field")
			}
			
			if code, ok := errorInfo["code"].(string); !ok || code != tt.wantJSONCode {
				t.Errorf("Error.Error() code = %v, want %v", code, tt.wantJSONCode)
			}
		})
	}
}

func TestMCPErrorTranslation(t *testing.T) {
	tests := []struct {
		name      string
		err       *Error
		wantCode  MCPErrorCode
		wantMsg   string
	}{
		{
			name:     "invalid argument to invalid params",
			err:      InvalidArg("bad argument"),
			wantCode: MCPErrorInvalidParams,
			wantMsg:  "bad argument",
		},
		{
			name:     "not found to not found",
			err:      NotFound("entity"),
			wantCode: MCPErrorNotFound,
			wantMsg:  "entity not found",
		},
		{
			name:     "internal to internal",
			err:      Internal(errors.New("system error")),
			wantCode: MCPErrorInternalError,
			wantMsg:  "system error",
		},
	}
	
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			code, msg := ToMCPError(tt.err)
			if code != tt.wantCode {
				t.Errorf("ToMCPError() code = %v, want %v", code, tt.wantCode)
			}
			if msg != tt.wantMsg {
				t.Errorf("ToMCPError() message = %v, want %v", msg, tt.wantMsg)
			}
		})
	}
}

func TestErrorUnwrapping(t *testing.T) {
	cause := errors.New("underlying error")
	err := Internal(cause, "context", "test")
	
	// Test Unwrap
	if unwrapped := errors.Unwrap(err); unwrapped != cause {
		t.Errorf("errors.Unwrap() = %v, want %v", unwrapped, cause)
	}
	
	// Test Is
	if !errors.Is(err, cause) {
		t.Errorf("errors.Is() = false, want true")
	}
	
	// Test As
	var typed *Error
	if !errors.As(err, &typed) {
		t.Errorf("errors.As() = false, want true")
	}
	if typed.Code() != CodeInternal {
		t.Errorf("errors.As() code = %v, want %v", typed.Code(), CodeInternal)
	}
}