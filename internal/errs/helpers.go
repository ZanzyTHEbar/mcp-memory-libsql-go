package errs

import "fmt"

// Helper functions for creating typed errors with key-value context

// InvalidArg creates an INVALID_ARGUMENT error with optional key-value context
func InvalidArg(msg string, kv ...interface{}) *Error {
	return New(CodeInvalidArgument, msg, nil, kv...)
}

// NotFound creates a NOT_FOUND error for a specific resource with optional key-value context
func NotFound(resource string, kv ...interface{}) *Error {
	msg := fmt.Sprintf("%s not found", resource)
	return New(CodeNotFound, msg, nil, kv...)
}

// AlreadyExists creates an ALREADY_EXISTS error with optional key-value context
func AlreadyExists(resource string, kv ...interface{}) *Error {
	msg := fmt.Sprintf("%s already exists", resource)
	return New(CodeAlreadyExists, msg, nil, kv...)
}

// FailedPrecondition creates a FAILED_PRECONDITION error with optional key-value context
func FailedPrecondition(msg string, kv ...interface{}) *Error {
	return New(CodeFailedPrecondition, msg, nil, kv...)
}

// Unsupported creates an UNSUPPORTED error with optional key-value context
func Unsupported(msg string, kv ...interface{}) *Error {
	return New(CodeUnsupported, msg, nil, kv...)
}

// Internal creates an INTERNAL error, optionally wrapping another error, with key-value context
func Internal(err error, kv ...interface{}) *Error {
	msg := "internal server error"
	if err != nil {
		msg = err.Error()
	}
	return New(CodeInternal, msg, err, kv...)
}

// Wrap creates an error with the specified code, wrapping another error, with key-value context
func Wrap(code Code, err error, kv ...interface{}) *Error {
	msg := "error"
	if err != nil {
		msg = err.Error()
	}
	return New(code, msg, err, kv...)
}

// AsTypedError checks if an error is a typed error and extracts it
func AsTypedError(err error, target **Error) bool {
	if e, ok := err.(*Error); ok {
		*target = e
		return true
	}
	return false
}

// New creates a new typed error with the given code, message, cause, and key-value context
func New(code Code, message string, cause error, kv ...interface{}) *Error {
	err := &Error{
		code:    code,
		message: message,
		cause:   cause,
	}
	
	// Parse key-value pairs
	if len(kv) > 0 {
		err.kv = make(map[string]interface{})
		for i := 0; i < len(kv); i += 2 {
			if i+1 < len(kv) {
				if key, ok := kv[i].(string); ok {
					err.kv[key] = kv[i+1]
				}
			}
		}
	}
	
	return err
}