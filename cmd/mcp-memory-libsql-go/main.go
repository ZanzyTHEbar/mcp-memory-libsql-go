package main

import (
	"context"
	"flag"
	"os"
	"os/signal"
	"syscall"

	"github.com/ZanzyTHEbar/mcp-memory-libsql-go/internal/buildinfo"
	"github.com/ZanzyTHEbar/mcp-memory-libsql-go/internal/database"
	"github.com/ZanzyTHEbar/mcp-memory-libsql-go/internal/logging"
	"github.com/ZanzyTHEbar/mcp-memory-libsql-go/internal/metrics"
	"github.com/ZanzyTHEbar/mcp-memory-libsql-go/internal/server"
)

var (
	libsqlURL   = flag.String("libsql-url", "", "libSQL database URL (default: file:./libsql.db)")
	authToken   = flag.String("auth-token", "", "Authentication token for remote databases")
	projectsDir = flag.String("projects-dir", "", "Base directory for projects. Enables multi-project mode.")
	transport   = flag.String("transport", "stdio", "Transport to use: stdio or sse")
	addr        = flag.String("addr", ":8080", "Address to listen on when using SSE transport")
	sseEndpoint = flag.String("sse-endpoint", "/sse", "SSE endpoint path when using SSE transport")
)

func main() {
	flag.Parse()

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// Handle graceful shutdown
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)
	go func() {
		<-sigChan
		logging.Infof("Received shutdown signal, closing server...")
		cancel()
	}()

	// Initialize database configuration
	config := database.NewConfig()

	// Initialize metrics (noop if disabled)
	metrics.InitFromEnv()

	// Initialize logging from env
	logging.InitFromEnv()

	// Override with command line flags if provided
	if *libsqlURL != "" {
		config.URL = *libsqlURL
	}
	if *authToken != "" {
		config.AuthToken = *authToken
	}
	if *projectsDir != "" {
		config.ProjectsDir = *projectsDir
		config.MultiProjectMode = true
	}

	// Create database manager
	db, err := database.NewDBManager(config)
	if err != nil {
		logging.Fatalf("Failed to create database manager: %v", err)
	}
	defer func() {
		if err := db.Close(); err != nil {
			logging.Warnf("Error closing database: %v", err)
		}
	}()

	// Create MCP server
	mcpServer := server.NewMCPServer(db)

	// Log startup details
	logging.Infof("Starting MCP Memory LibSQL server... version=%s transport=%s", buildinfo.Version, *transport)
	logging.Debugf("DB URL=%s embedding_dims=%d provider=%s", config.URL, config.EmbeddingDims, config.EmbeddingsProvider)

	// Run the server with selected transport
	switch *transport {
	case "stdio":
		go func() {
			if err := mcpServer.Run(ctx); err != nil {
				logging.Errorf("Server error: %v", err)
			}
		}()
	case "sse":
		go func() {
			if err := mcpServer.RunSSE(ctx, *addr, *sseEndpoint); err != nil {
				logging.Errorf("SSE server error: %v", err)
			}
		}()
	default:
		logging.Fatalf("unknown transport: %s (expected: stdio or sse)", *transport)
	}

	<-ctx.Done()

	logging.Infof("Server stopped")
}
