package errs

import (
	"encoding/json"
	"fmt"
)

// Error represents a typed error with code, message, and optional key-value context
type Error struct {
	code    Code
	message string
	cause   error
	kv      map[string]interface{}
}

// Code returns the error code
func (e *Error) Code() Code {
	return e.code
}

// Message returns the error message
func (e *Error) Message() string {
	return e.message
}

// Cause returns the underlying cause error, if any
func (e *Error) Cause() error {
	return e.cause
}

// KV returns the key-value context
func (e *Error) KV() map[string]interface{} {
	if e.kv == nil {
		return nil
	}
	// Return a copy to prevent mutation
	result := make(map[string]interface{})
	for k, v := range e.kv {
		result[k] = v
	}
	return result
}

// Error implements the error interface with JSON-safe output for backwards compatibility
func (e *Error) Error() string {
	errorData := map[string]interface{}{
		"error": map[string]interface{}{
			"code":    string(e.code),
			"message": e.message,
		},
	}
	
	// Add key-value context to the error data
	if len(e.kv) > 0 {
		for k, v := range e.kv {
			errorData["error"].(map[string]interface{})[k] = v
		}
	}
	
	// JSON encode for backwards compatibility
	if b, err := json.Marshal(errorData); err == nil {
		return string(b)
	}
	
	// Fallback if JSON encoding fails
	return fmt.Sprintf(`{"error":{"code":"%s","message":"%s"}}`, e.code, e.message)
}

// Unwrap implements error unwrapping for Go 1.13+ error handling
func (e *Error) Unwrap() error {
	return e.cause
}

// Is implements error comparison for Go 1.13+ error handling
func (e *Error) Is(target error) bool {
	if t, ok := target.(*Error); ok {
		return e.code == t.code
	}
	return false
}

// As implements error casting for Go 1.13+ error handling
func (e *Error) As(target interface{}) bool {
	if t, ok := target.(**Error); ok {
		*t = e
		return true
	}
	return false
}