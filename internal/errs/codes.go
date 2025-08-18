package errs

// Code represents canonical error codes for MCP operations
type Code string

const (
	// INVALID_ARGUMENT indicates client-provided argument is invalid
	CodeInvalidArgument Code = "INVALID_ARGUMENT"
	
	// NOT_FOUND indicates requested resource was not found
	CodeNotFound Code = "NOT_FOUND"
	
	// ALREADY_EXISTS indicates resource already exists
	CodeAlreadyExists Code = "ALREADY_EXISTS"
	
	// PERMISSION_DENIED indicates client lacks permission
	CodePermissionDenied Code = "PERMISSION_DENIED"
	
	// UNAUTHENTICATED indicates client authentication failed
	CodeUnauthenticated Code = "UNAUTHENTICATED"
	
	// FAILED_PRECONDITION indicates operation precondition not met
	CodeFailedPrecondition Code = "FAILED_PRECONDITION"
	
	// INTERNAL indicates server internal error
	CodeInternal Code = "INTERNAL"
	
	// UNAVAILABLE indicates service temporarily unavailable
	CodeUnavailable Code = "UNAVAILABLE"
	
	// UNSUPPORTED indicates operation not supported
	CodeUnsupported Code = "UNSUPPORTED"
	
	// CONFLICT indicates resource conflict
	CodeConflict Code = "CONFLICT"
)

// String returns the string representation of the code
func (c Code) String() string {
	return string(c)
}