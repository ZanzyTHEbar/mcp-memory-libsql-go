package memory

import "github.com/ZanzyTHEbar/mcp-memory-libsql-go/internal/apptype"

// Re-export internal types as public aliases so external consumers don't need to
// import internal packages. This preserves single-source-of-truth definitions
// while providing a stable library surface.

type Entity = apptype.Entity
type Relation = apptype.Relation
type UpdateEntitySpec = apptype.UpdateEntitySpec
type UpdateRelationChange = apptype.UpdateRelationChange
type GraphResult = apptype.GraphResult
type SearchResult = apptype.SearchResult
