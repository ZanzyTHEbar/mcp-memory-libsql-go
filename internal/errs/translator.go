package errs

// MCPErrorCode represents MCP protocol error codes
type MCPErrorCode int

const (
	// MCP protocol error codes based on JSON-RPC 2.0 spec
	MCPErrorInvalidRequest    MCPErrorCode = -32600
	MCPErrorMethodNotFound    MCPErrorCode = -32601
	MCPErrorInvalidParams     MCPErrorCode = -32602
	MCPErrorInternalError     MCPErrorCode = -32603
	MCPErrorParseError        MCPErrorCode = -32700
	
	// MCP-specific error codes
	MCPErrorNotFound          MCPErrorCode = -32001
	MCPErrorConflict          MCPErrorCode = -32002
	MCPErrorUnavailable       MCPErrorCode = -32003
	MCPErrorUnsupported       MCPErrorCode = -32004
	MCPErrorPermissionDenied  MCPErrorCode = -32005
	MCPErrorUnauthenticated   MCPErrorCode = -32006
)

// ToMCPError translates a typed error to MCP error code and message
func ToMCPError(err error) (MCPErrorCode, string) {
	if e, ok := err.(*Error); ok {
		return codeToMCPError(e.code), e.message
	}
	
	// Default to internal error for non-typed errors
	return MCPErrorInternalError, err.Error()
}

// codeToMCPError maps canonical error codes to MCP error codes
func codeToMCPError(code Code) MCPErrorCode {
	switch code {
	case CodeInvalidArgument:
		return MCPErrorInvalidParams
	case CodeNotFound:
		return MCPErrorNotFound
	case CodeAlreadyExists, CodeConflict:
		return MCPErrorConflict
	case CodePermissionDenied:
		return MCPErrorPermissionDenied
	case CodeUnauthenticated:
		return MCPErrorUnauthenticated
	case CodeFailedPrecondition:
		return MCPErrorInvalidParams
	case CodeUnavailable:
		return MCPErrorUnavailable
	case CodeUnsupported:
		return MCPErrorUnsupported
	case CodeInternal:
		return MCPErrorInternalError
	default:
		return MCPErrorInternalError
	}
}