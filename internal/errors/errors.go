package errors

import (
	"fmt"
)

// Error is a simple structured error that can hold an optional code and wrapped error.
type Error struct {
	Code string
	msg  string
	err  error
}

func (e *Error) Error() string {
	if e == nil {
		return "<nil>"
	}
	if e.Code != "" {
		if e.err != nil {
			return fmt.Sprintf("%s: %s: %v", e.Code, e.msg, e.err)
		}
		return fmt.Sprintf("%s: %s", e.Code, e.msg)
	}
	if e.err != nil {
		return fmt.Sprintf("%s: %v", e.msg, e.err)
	}
	return e.msg
}

func (e *Error) Unwrap() error { return e.err }

// New creates a new error with message
func New(msg string) error { return &Error{msg: msg} }

// Errorf formats and returns a new error
func Errorf(format string, args ...interface{}) error {
	return &Error{msg: fmt.Sprintf(format, args...)}
}

// Wrap wraps an existing error with a message
func Wrap(err error, msg string) error {
	if err == nil {
		return New(msg)
	}
	return &Error{msg: msg, err: err}
}

// Wrapf wraps an existing error with formatted message
func Wrapf(err error, format string, args ...interface{}) error {
	if err == nil {
		return Errorf(format, args...)
	}
	return &Error{msg: fmt.Sprintf(format, args...), err: err}
}

// WithCode attaches a code to an error message (returns new Error)
func WithCode(code string, err error) error {
	if e, ok := err.(*Error); ok {
		e.Code = code
		return e
	}
	return &Error{Code: code, msg: err.Error(), err: err}
}
