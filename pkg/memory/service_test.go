package memory

import (
	"context"
	"fmt"
	"testing"

	"github.com/stretchr/testify/require"
)

// helper to build a service backed by a temporary file DB
func newTestService(t *testing.T) (*Service, func()) {
	t.Helper()
	dir := t.TempDir()
	cfg := &Config{
		URL:           "file:" + dir + "/libsql.db",
		EmbeddingDims: 8, // small test dimension
	}
	svc, err := NewService(cfg)
	require.NoError(t, err)
	cleanup := func() {
		_ = svc.Close()
	}
	return svc, cleanup
}

func TestCreateAndSearchEntities(t *testing.T) {
	svc, done := newTestService(t)
	defer done()
	ctx := context.Background()

	err := svc.CreateEntities(ctx, "default", []Entity{
		{Name: "Task:1", EntityType: "Task", Observations: []string{"initial setup"}},
		{Name: "Note:A", EntityType: "Note", Observations: []string{"hello world"}},
	})
	require.NoError(t, err)

	ents, rels, err := svc.SearchText(ctx, "default", "initial", 10, 0)
	require.NoError(t, err)
	require.NotEmpty(t, ents)
	// relations may be empty since we didn't add any yet
	require.NotNil(t, rels)
}

func TestCreateRelationsAndNeighbors(t *testing.T) {
	svc, done := newTestService(t)
	defer done()
	ctx := context.Background()

	require.NoError(t, svc.CreateEntities(ctx, "default", []Entity{
		{Name: "Repo:acme/widgets", EntityType: "Repo", Observations: []string{"GitHub: https://github.com/acme/widgets"}},
		{Name: "Task:1", EntityType: "Task", Observations: []string{"init"}},
	}))
	require.NoError(t, svc.CreateRelations(ctx, "default", []Relation{{
		From: "Repo:acme/widgets", To: "Task:1", RelationType: "tracks",
	}}))

	ents, rels, err := svc.Neighbors(ctx, "default", []string{"Repo:acme/widgets"}, "both", 10)
	require.NoError(t, err)
	require.NotEmpty(t, ents)
	require.NotEmpty(t, rels)
}

func TestOpenNodesIncludeRelations(t *testing.T) {
	svc, done := newTestService(t)
	defer done()
	ctx := context.Background()

	require.NoError(t, svc.CreateEntities(ctx, "default", []Entity{
		{Name: "A", EntityType: "X", Observations: []string{"oa"}},
		{Name: "B", EntityType: "Y", Observations: []string{"ob"}},
	}))
	require.NoError(t, svc.CreateRelations(ctx, "default", []Relation{{From: "A", To: "B", RelationType: "link"}}))

	ents, rels, err := svc.OpenNodes(ctx, "default", []string{"A", "B"}, true)
	require.NoError(t, err)
	require.Len(t, ents, 2)
	require.NotEmpty(t, rels)

	ents2, rels2, err := svc.OpenNodes(ctx, "default", []string{"A", "B"}, false)
	require.NoError(t, err)
	require.Len(t, ents2, 2)
	require.Empty(t, rels2)
}

func TestUpdatesAndDeletes(t *testing.T) {
	svc, done := newTestService(t)
	defer done()
	ctx := context.Background()

	require.NoError(t, svc.CreateEntities(ctx, "default", []Entity{{
		Name: "X", EntityType: "Type1", Observations: []string{"o1", "o2"},
	}}))

	// Update entity: replace observations
	require.NoError(t, svc.UpdateEntities(ctx, "default", []UpdateEntitySpec{{
		Name:                "X",
		ReplaceObservations: []string{"o3"},
	}}))

	ents, _, err := svc.OpenNodes(ctx, "default", []string{"X"}, false)
	require.NoError(t, err)
	require.Len(t, ents, 1)
	require.Equal(t, []string{"o3"}, ents[0].Observations)

	// Add relation then delete it
	require.NoError(t, svc.CreateEntities(ctx, "default", []Entity{{Name: "Y", EntityType: "T", Observations: []string{"oy"}}}))
	require.NoError(t, svc.CreateRelations(ctx, "default", []Relation{{From: "X", To: "Y", RelationType: "edge"}}))
	require.NoError(t, svc.DeleteRelations(ctx, "default", []Relation{{From: "X", To: "Y", RelationType: "edge"}}))

	// Delete entity
	require.NoError(t, svc.DeleteEntity(ctx, "default", "X"))
	ents, _, err = svc.OpenNodes(ctx, "default", []string{"X"}, false)
	require.NoError(t, err)
	require.Len(t, ents, 0)
}

func TestGraphOps(t *testing.T) {
	svc, done := newTestService(t)
	defer done()
	ctx := context.Background()

	require.NoError(t, svc.CreateEntities(ctx, "default", []Entity{{Name: "A", EntityType: "T", Observations: []string{"oa"}}, {Name: "B", EntityType: "T", Observations: []string{"ob"}}, {Name: "C", EntityType: "T", Observations: []string{"oc"}}}))
	require.NoError(t, svc.CreateRelations(ctx, "default", []Relation{{From: "A", To: "B", RelationType: "edge"}, {From: "B", To: "C", RelationType: "edge"}}))

	// Walk
	ents, rels, err := svc.Walk(ctx, "default", []string{"A"}, 2, "out", 10)
	require.NoError(t, err)
	require.True(t, len(ents) >= 2)
	require.True(t, len(rels) >= 1)

	// Shortest Path A -> C
	spEnts, spRels, err := svc.ShortestPath(ctx, "default", "A", "C", "out")
	require.NoError(t, err)
	require.True(t, len(spEnts) >= 2)
	require.True(t, len(spRels) >= 1)
}

func TestObservationsLifecycle(t *testing.T) {
	svc, done := newTestService(t)
	defer done()
	ctx := context.Background()

	require.NoError(t, svc.CreateEntities(ctx, "default", []Entity{{Name: "E", EntityType: "T", Observations: []string{"start"}}}))
	require.NoError(t, svc.AddObservations(ctx, "default", "E", []string{"keep", "drop"}))

	// Delete by content
	affected, err := svc.DeleteObservations(ctx, "default", "E", nil, []string{"drop"})
	require.NoError(t, err)
	require.EqualValues(t, 1, affected)

	ents, _, err := svc.OpenNodes(ctx, "default", []string{"E"}, false)
	require.NoError(t, err)
	require.Len(t, ents, 1)
	require.Equal(t, []string{"start", "keep"}, ents[0].Observations)
}

func TestHybridSearchToggleNoCrash(t *testing.T) {
	svc, done := newTestService(t)
	defer done()
	ctx := context.Background()

	require.NoError(t, svc.CreateEntities(ctx, "default", []Entity{{Name: "Z", EntityType: "T", Observations: []string{"hello"}}}))
	svc.EnableHybridSearch(0.4, 0.6, 60)
	ents, rels, err := svc.SearchText(ctx, "default", "hello", 5, 0)
	require.NoError(t, err)
	require.NotEmpty(t, ents)
	require.NotNil(t, rels)
	svc.DisableHybridSearch()
}

func TestVectorSearchAndSimilar(t *testing.T) {
	svc, done := newTestService(t)
	defer done()
	ctx := context.Background()

	// EMBEDDING_DIMS = 8 in newTestService; insert explicit vectors
	vA := []float32{1, 0, 0, 0, 0, 0, 0, 0}
	vB := []float32{0.9, 0, 0, 0, 0, 0, 0, 0}
	vC := []float32{0, 1, 0, 0, 0, 0, 0, 0}

	require.NoError(t, svc.CreateEntities(ctx, "default", []Entity{
		{Name: "A", EntityType: "T", Observations: []string{"va"}, Embedding: vA},
		{Name: "B", EntityType: "T", Observations: []string{"vb"}, Embedding: vB},
		{Name: "C", EntityType: "T", Observations: []string{"vc"}, Embedding: vC},
	}))

	// SearchVector through SearchNodes API should include A/B at top for a query near A.
	ents, _, err := svc.SearchVector(ctx, "default", vA, 3, 0)
	require.NoError(t, err)
	require.GreaterOrEqual(t, len(ents), 2)
	names := []string{ents[0].Name, ents[1].Name}
	require.Contains(t, names, "A")
	require.Contains(t, names, "B")

	// SearchSimilar with an embedding close to A should return A before C.
	sim, err := svc.SearchSimilar(ctx, "default", vA, 3, 0)
	require.NoError(t, err)
	require.GreaterOrEqual(t, len(sim), 2)
	// First two should be A and B in some order with lower distances than C
	// Basic checks: distances are non-decreasing
	for i := 1; i < len(sim); i++ {
		require.LessOrEqual(t, sim[i-1].Distance, sim[i].Distance)
	}
}

func BenchmarkCreateEntitiesBatch(b *testing.B) {
	// Use a fresh service for the benchmark
	svc, cleanup := newTestService(&testing.T{})
	defer cleanup()
	ctx := context.Background()

	// Prepare a batch of N entities
	const N = 500
	batch := make([]Entity, 0, N)
	for i := 0; i < N; i++ {
		batch = append(batch, Entity{
			Name:         "Ent:" + fmt.Sprint(i),
			EntityType:   "Bench",
			Observations: []string{"obs", "bench"},
			// leave embedding empty → the DB manager will write zero vectors
		})
	}

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		if err := svc.CreateEntities(ctx, "bench", batch); err != nil {
			b.Fatalf("CreateEntities failed: %v", err)
		}
	}
}
