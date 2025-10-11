// Package memory provides a stable, library-first API for using the
// libSQL-backed knowledge graph and vector search engine without running the
// MCP server transport.
//
// Quickstart:
//
//	cfg := &memory.Config{ URL: "file:./libsql.db", EmbeddingDims: 1536 }
//	svc, err := memory.NewService(cfg)
//	if err != nil { log.Fatal(err) }
//	defer svc.Close()
//
//	ctx := context.Background()
//	_ = svc.CreateEntities(ctx, "default", []memory.Entity{{
//	    Name: "Task:1", EntityType: "Task", Observations: []string{"Hello"},
//	}})
//
//	ents, rels, err := svc.SearchText(ctx, "default", "Hello", 10, 0)
//	_ = ents; _ = rels; _ = err
package memory
