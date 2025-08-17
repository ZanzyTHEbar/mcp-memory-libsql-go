# 📦 Changelog 
[![conventional commits](https://img.shields.io/badge/conventional%20commits-1.0.0-yellow.svg)](https://conventionalcommits.org)
[![semantic versioning](https://img.shields.io/badge/semantic%20versioning-2.0.0-green.svg)](https://semver.org)
> All notable changes to this project will be documented in this file

## [0.4.2](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.4.1...v0.4.2) (2025-08-17)

### 🤖 Build System

* **feat-backup:** add EXCLUDE_PATTERNS and RUN_ONCE environment variables ([86291f8](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/86291f86c3f66ecf120045beb20158cd71f8a50f))

## [0.4.1](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.4.0...v0.4.1) (2025-08-17)

### 🐛 Bug Fixes

* **prompts:** normalize nil slice fields when registering prompts to avoid JSON nulls ([f230f81](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/f230f8100e2c009b39cc283d38537a0c7e8abe1a))

### 🧑‍💻 Code Refactoring

* **Makefile:** add ensure-env-ci target for .env.ci management ([6b21616](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/6b216160940a9708c266fb2c43ad78dfcf28ce15))
* **Makefile:** enhance .env.ci creation for multi mode ([ef977a9](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/ef977a9dff8e0feabfae80e9d375a8c7d4258236))
* **prompts_test:** remove unused variable in collectPrompts function ([59d0fdb](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/59d0fdbf038f022dcecee4cca2dcd3ce323f5fbd))
* **loader:** replace ioutil with os package for reading directories and files ([0b845ce](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/0b845ce0f8b7dba87a6bf6442731cceda0990099))
* **Makefile:** simplify .env.ci file creation using printf ([e10dec8](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/e10dec890082a8b8da30db1494760b9127f0fe53))
* **Makefile:** streamline docker-test target and enhance health check procedures ([221e99b](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/221e99bcb71408a5e731af737ebc190a4246c86b))

### 🔁 Continuous Integration

* use dedicated script for docker-test; upload integration report on failure ([c78db74](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/c78db74bada739f2153bf9160c4e10e1279bcffc))

## [0.4.0](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.3.8...v0.4.0) (2025-08-17)

### 📝 Documentation

* add deployment notes for mcp-memory-libsql-go on Docker and Coolify ([d3171fd](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/d3171fde7f310881692b0a0a7f5a0d56e714f2aa))

## [0.3.8](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.3.7...v0.3.8) (2025-08-16)

### 🤖 Build System

* **fix-docker-compose:** remove default values for environment variables and update healthcheck command ([1404028](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/1404028bb5c2d4189353bffe2d683a442b6ff461))

## [0.3.7](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.3.6...v0.3.7) (2025-08-15)

### 🐛 Bug Fixes

* **docker-compose, entrypoint, server:** streamline PORT configuration and enhance health endpoint for improved service monitoring ([1b84410](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/1b84410f5d7eb6a8a4a7498a37011e626c249ba6))

## [0.3.6](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.3.5...v0.3.6) (2025-08-15)

### 🤖 Build System

* **docker-compose:** remove ollama service configuration from docker-compose files and update Makefile for simplified service management ([bd34686](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/bd34686d0c164baf8ff5a2501f5561257b255f0c))

## [0.3.5](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.3.4...v0.3.5) (2025-08-15)

### 🐛 Bug Fixes

* **docker-compose:** update volume configuration for ollama service and ensure model directory is created in Makefile ([3b46b8f](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/3b46b8fabcd47ad156abb15e85621ba51c5e9d32))

## [0.3.4](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.3.3...v0.3.4) (2025-08-15)

### 🤖 Build System

* **docker-compose:** enhance healthcheck command and remove memory profile references ([8a92112](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/8a92112159e7f015e8b041576ee15040c624852d))

## [0.3.3](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.3.2...v0.3.3) (2025-08-15)

### 🤖 Build System

* **docker-compose:** simplify metrics port configuration and enhance healthcheck command ([97f1880](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/97f18804d8fe35a59c88a5341d821e67ae94031d))

## [0.3.2](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.3.1...v0.3.2) (2025-08-15)

### 🧑‍💻 Code Refactoring

* **makefile:** remove duplicate Coolify-specific targets for memory service ([f2f3736](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/f2f3736b1316048d8e74c6c2703ee7d4add3af2d))

### 🤖 Build System

* **docker:** introduce new docker-compose.raw.yaml to build from raw docker file. ([2362761](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/236276157c7c4dc9e8a6bb98d6ef00200641361a))

## [0.3.1](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.3.0...v0.3.1) (2025-08-15)

### 🤖 Build System

* **docker:** add docker-compose configuration for memory, ollama, and localai services ([efc76bb](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/efc76bbd7aed46a9ac6c2c6ebb1fe909a5485c51))
* **docker:** add docker-compose example file ([d20c465](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/d20c465e4ec0264def4c1fd8cd1284a301b8d70a)), closes [#39](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/issues/39)

## [0.3.0](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.2.0...v0.3.0) (2025-08-15)

### 📝 Documentation

* Add quick-start guide for pre-built GHCR images and update README sections ([6a1d9eb](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/6a1d9eb239d97b9eec07b5ffeb290d5c9cef8357))

## [0.2.0](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.1.1...v0.2.0) (2025-08-15)

### 🐛 Bug Fixes

* **database:** restore internal searchNodesInternal; docs comments; keep behavior parity ([0dc629f](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/0dc629fd4cb6cb35c77e7301381c51266d359d43))

### 📝 Documentation

* **database:** add doc comments to search.go and graph.go ([977ebb3](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/977ebb32b48735f76647f2d575698f548bff464f))
* Improve formatting of comments in internal/database/search.go ([19d9adf](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/19d9adf66a405009e7548fab751143f553a19b3a))
* Update internal/database/entities_crud.go ([27bff97](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/27bff9768714d261f31a4db0a8e32e8c8194f172))
* Update internal/database/graph.go ([cdec1a5](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/cdec1a59e3eaa898af36acdeca87450078b36e2d))
* Update internal/database/search.go ([5b9fe6a](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/5b9fe6ad5b5fce0978adcfa4fe836498f3e6a88c))
* Update internal/database/search.go ([dc586e4](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/dc586e436e1d3e1d8139b2861e6c88bfb6dd9442))
* Update internal/database/vectors.go ([39a4c58](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/39a4c5871e8e2a9b95340bc29f452a8d76e6213f))

### 🧑‍💻 Code Refactoring

* **database:** add exported SearchNodes delegating to internal; green external references ([71c1dd0](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/71c1dd00c1b749ddd195f615329a9ba3e3f31425))
* **database:** add searchNodesInternal to search.go and tidy imports ([dec1005](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/dec10056392b807558139df3e56ae4360d1406a1))
* **database:** clean imports and remove duplicate getPreparedStmt in database.go ([aae481e](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/aae481ed26c4d2e962bc4694d9db9023180c44cb))
* **database:** extract capability detection to capabilities.go and stub original reference (no behavior change) ([ecd7e12](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/ecd7e12f1f634c7dda757f862bea6e1160f9a469))
* **database:** extract conn.go (NewDBManager/getDB/initialize/detectDBEmbeddingDims) without behavior changes ([995c4a3](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/995c4a3f653569df6735d8bb86d8f9dbe35492f8))
* **database:** extract entities_crud.go and relations.go (no behavior changes) ([68e44a2](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/68e44a2021c1dc1bf97e68d1161e7cd4df12f8c7))
* **database:** extract search.go and graph.go scaffolding (no behavior change); keep database.go stubs ([4d9e7f9](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/4d9e7f9e40d03987d4a9d1081d519b0dda71fee9))
* **database:** extract stmt cache (stmt_cache.go) and vector utilities (vectors.go); stub originals (no behavior change) ([61a4caa](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/61a4caa0c57dd5017deab02061a9abd0c9664124))
* **database:** finalize extraction of CRUD and relations from database.go; removed duplicates ([33b4c8d](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/33b4c8ddd2cf110b378feb430359ff67ff074d25))
* **database:** modularize internal/database into focused files (1:1 parity) ([ef158f5](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/ef158f5ff79a0b3364719e2093edbf4ce04d012f)), closes [#37](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/issues/37)
* **database:** move buildFTSMatchExpr to search.go; consolidate search helpers ([ce52042](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/ce52042ed0928dbd47fd552bb7e45e6132fec940))
* **database:** move capFlags and detectCapabilitiesForProject to capabilities.go (no behavior change) ([1481196](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/1481196aa39f7a9b549f33e729d1b07b00b429f8))
* **database:** move GetNeighbors/Walk/ShortestPath/ReadGraph to graph.go; leave stubs in database.go ([4b916e0](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/4b916e04e36503ddd1f4d73dd97b359455da3eae))
* **database:** move GetRelationsForEntities to graph.go and remove duplicates ([6b55f92](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/6b55f921bc4f0eaab1b6ba88d4080e55d42fa425))
* **database:** move search strategy/types and GetRecentEntities out of database.go; fix imports ([b897e02](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/b897e022cc6f9b795aeaa77c06fba6aec8c9269e))
* **database:** move SearchEntities into search.go; remove duplicate from database.go ([af1eb85](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/af1eb85eeae608fee34f36e61d82616596756d5d))
* **database:** move SearchNodes/searchNodesInternal to search.go; leave stubs in database.go ([c812296](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/c81229626e69c0dc55ad06add4dc789fec026da4))
* **database:** move SearchSimilar and GetRecentEntities out of database.go; tidy imports ([fc7532c](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/fc7532c70c74519f09d89d3927aeb992e0215c3c))
* **database:** remove duplicate detectCapabilitiesForProject from database.go; source in capabilities.go ([0ced0b6](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/0ced0b63c3dab3ff2e24cf8ce90237eb208d0e17))
* **database:** remove redundant type declaration in search.go ([bbb1b08](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/bbb1b08a163bb905869338fee708cfdb0c537590))

## [0.1.1](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.1.0...v0.1.1) (2025-08-15)

### 🧑‍💻 Code Refactoring

* **releaserc:** remove GitHub plugin configuration for release comments ([7331b7a](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/7331b7afad890b4e8c364637cea018e61d4b88c9))

### 🔁 Continuous Integration

* **release:** configure semantic-release to skip PR comments/labels and add commit-analyzer ([7f21268](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/7f2126865dfae94ecddc62b63e3331cfab047109))
* **release:** disable GitHub plugin release notes injection; no PR/issue interactions ([8cca84f](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/8cca84fd94a345adeddb19ce79febd3c67fbd3a6))
* **release:** use .releaserc as canonical; disable GitHub PR interactions; remove duplicate .releaserc.json ([ef3426a](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/ef3426ae495171a15978ab918b087d9d8334432d))

## [0.1.0](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/compare/v0.0.14...v0.1.0) (2025-08-15)

### 🍕 Features

* **search:** add BM25 ranking for FTS results with env-tunable k1/b and safe fallbacks ([134339e](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/134339e352fe86c44fa857d32d03df10ae4976ce))
* add Docker support and metrics instrumentation ([db54259](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/db542598211b869c0f1752947195713d3cb29970))
* **docker:** add docker-compose support for multi-profile setups; enhance README with detailed Docker usage instructions; introduce integration testing capabilities with a dedicated tester tool ([4b46586](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/4b4658621403e878f00826cd57221a524bcdc9f1))
* **search:** add FTS5-backed text search with automatic LIKE fallback; detect FTS5 at startup and sync via triggers; fix README dims typo to 768 ([17c5b27](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/17c5b27314aa1829b3b50eb1d3c0ec925f8ecf29))
* **database:** add GetRelations convenience wrapper; all tests green ([1d14e45](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/1d14e458d56ecf0081c1f970bae46f07af7aeada))
* **search:** add Hybrid Search strategy (RRF fusion of text + vector); env toggle HYBRID_SEARCH with tunable weights ([0af0748](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/0af07482223cb854b52bb8536f800a8308347d32))
* add jsonschema annotations to argument types for improved documentation ([9ed4378](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/9ed4378e7644b9cf173cfced253d15a9e28e4e8a))
* **docker:** add multi-stage Dockerfiles for SSE and STDIO transports; update Makefile to include docker build target; enhance README with tool summary adjustments ([ea9cf3f](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/ea9cf3f1bc6c2504bf5c02028d79eaf3079e72f1))
* add OpenAI and Ollama embeddings providers ([cd64197](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/cd641972ff893ea43f4af553b3fb7ba7ec956414))
* add pagination support to search functions in database and server ([a1d93b4](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/a1d93b477c02786acb7f9f1ce1f6382d8126f377))
* **metrics:** add tool result size histogram with sampling; keep low label cardinality\n\n- New Recorder.ObserveToolResultSize(tool, size) with sampling via METRICS_RESULT_SAMPLE_N\n- Prometheus histogram tool_result_size with generic buckets\n- Keeps cardinality low (labels: tool only)\n\nRefs: [#3](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/issues/3) ([6e0987a](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/6e0987a6dbc95e19c2b18ad3210a4bc70c78c070))
* add update and health check tools to MCP server ([863e6cc](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/863e6cc2c402a4cdc17b2dc6d7f4985db9bcb69f))
* **embeddings:** add VoyageAI provider and dimension adapter; wire provider and deps ([417aa3c](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/417aa3cab27bbc065e311a3d43b42d1c717672f2))
* **graph:** add Walk and ShortestPath functions for graph traversal; implement corresponding argument types and server handlers ([cad80a7](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/cad80a7a3db0e45f2ae67d1d27f33daa718603a0))
* **entrypoint:** allow MODE to override CMD; fallback to CMD when MODE unset ([ffc012c](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/ffc012cf671700e0a64dc41f061a7eba4092c751))
* **docker:** consolidate Dockerfile for multi-transport builds; remove separate Dockerfiles for SSE and STDIO ([6c6d194](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/6c6d194ab16029cff07c633dabcbc3523e557ce1))
* **tests:** enhance integration tester with additional delete operations and increase step capacity ([5d233f1](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/5d233f1019dceac12924fb7e6b7187df38433468))
* enhance MCP server functionality with new tools and improved project context handling ([2ffa1ba](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/2ffa1ba7e8bcfb116cff55f0fd2dc5cc4230a813))
* enhance MCP tool handlers with input/output schemas and annotations ([cf027de](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/cf027dedc4055f8451e0edfa3c3f029eb6b0319e))
* enhance vector extraction and add test for entity creation ([e07ba40](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/e07ba40bf1a3ae598304edf43a2f4e3d32024c8c))
* implement DatabaseManager for entity and relation management ([69fc23c](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/69fc23cb2c72d4905c05f449ef55e9d179d79e7c))
* **database:** implement GetNeighbors function to fetch 1-hop neighbors; add NeighborsArgs type for input parameters; enhance metrics with pool stats and statement cache tracking ([a232560](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/a232560b8377a774c8991c568cddfa7be7fe1345))
* implement main application logic for MCP Memory LibSQL server ([d441beb](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/d441beb6659f0faa03d2fe29c87de1b2c140b252))
* implement multiple embeddings providers and enhance DBManager ([475ffeb](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/475ffebc930fc6b284962b0d36dc937c7ab89b32))
* **embeddings:** implement providers for OpenAI, Ollama, Gemini, Vertex AI, and LocalAI; wire env-based selection and docs; batch-generate embeddings when missing; enforce EMBEDDING_DIMS match ([555ab06](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/555ab06b33fed487f9b70e1e51e8cf45c11d7894))
* implement statement caching in DBManager for improved query performance ([73181e2](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/73181e2df5523015661b8be66f7526be09c63509))
* **entrypoint:** improve model loading and timeout handling ([91d3a94](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/91d3a9477f4b21f520df5955bcfb43b9f4f320ad))
* **db:** introduce soft cascade via trigger on entities delete; simplify DeleteEntity\n\n- Add trg_entities_delete_cascade to remove observations/relations on entity delete\n- Replace manual multi-table delete with single DELETE relying on trigger\n\nRefs: [#7](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/issues/7) ([fd79d3b](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/fd79d3b7424e893e5d396d966cc740c8b86890fd))
* **metrics:** record result sizes across tool handlers with sampled histogram\n\n- Observe counts of entities/relations/updates per tool\n- Uses ObserveToolResultSize (sampling via METRICS_RESULT_SAMPLE_N)\n\nRefs: [#3](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/issues/3) ([bc119bb](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/bc119bb499d6785033fba50efae2528c9d4b099b))
* **db:** refine capability probing to be per-project DB handle (vector_top_k, fts5)\n\n- Track caps per project with capsByProject map\n- Adjust search codepaths to consult/update per-project flags\n- Avoid global probe; initialize on getDB(project)\n\nRefs: [#5](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/issues/5) ([f3b528d](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/f3b528d51a3d45dea8212f6527f0434f7a1bacbd))
* **multi-project:** require projectName; add per-project token auth with optional env toggles and auto-init; enforce across tools ([9206f65](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/9206f6569ff48e21a4be438af5d7a95677a8a5fa))
* **search:** robust FTS queries + prefix handling; fallback improvements\n\n- FTS tokenizer (unicode61) with tokenchars=:-_@./ and prefix index\n- buildFTSMatchExpr to support Task:* (entity_name/content) and quoted phrases\n- downgrade to LIKE on parse/table errors without disabling FTS globally\n- normalize nil slices in read_graph/search_nodes/open_nodes for schema compliance\n- prompts: document query syntax/tips; README: add query rules & examples ([85467eb](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/85467ebca949b9ea44106f4defa148cb25a29db4))
* **graph): add neighbors/walk/shortest_path tools with DB implementations and tests; feat(metrics:** stmt-cache/pool gauges + periodic emission; docs: update tools table and metrics section; bench: add search benches ([e83617e](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/e83617e2c54347bd343c5af30746ab807cd0f760))
* **observability:** structured error logs per tool with low-cardinality key=value format\n\n- Add logToolError helper and log on failures across handlers\n- Keeps logs machine-parseable without new deps\n\nRefs: [#3](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/issues/3) ([21982fd](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/21982fd9489feb6bb8ad72e02a20d30a7f9183c9))
* **db:** transactional bulk deletes with chunking; rely on cascade trigger\n\n- DeleteEntities now wraps deletes in a single tx, uses IN-chunking (<=500)\n- DeleteObservations uses tx + chunking for ids/contents\n- Leverages trg_entities_delete_cascade for cleanup\n\nRefs: [#8](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/issues/8) ([8a52e82](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/8a52e82a926bb427ee611404546c2b539b40470a))

### 🐛 Bug Fixes

* **install:** check for existing binary before installation and remove it if found ([7d5d088](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/7d5d0882a62bd8a0d610ed4101b7b6b296816e57))
* **db:** close cached prepared statements on shutdown to prevent descriptor leaks\n\n- Close all cached *sql.Stmt per project before closing DBs\n- Clear stmtCache buckets\n- Leave behavior unchanged otherwise\n\nRefs: [#2](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/issues/2) ([633710f](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/633710fe4def733ecb1e5b356e14daddeaab913d))
* **makefile:** correct conditional check in docker-test target for proper string comparison ([cd52b5f](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/cd52b5f2219d6a8e54b762b43d5c1e1303e132bd))
* **entrypoint:** correct indentation for conditional checks and improve readability ([b4d5672](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/b4d5672d659a12c355995a01ee271fef3c96bf96))
* correct indentation in README.md and update switch case formatting in provider.go for better readability ([bcbd138](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/bcbd138c8df43924caabfb65305c404d4ce0382c))
* enhance transaction handling and error reporting in DBManager methods ([479d1cf](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/479d1cf329de7c864f2afc7cb54b2bff6eae5c0e))
* ensure proper locking and embedding dimensions in DBManager ([fd3d1f0](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/fd3d1f022312d34b313c8c9b78d41bb2fb350bf1))
* **metrics:** make InitFromEnv idempotent via sync.Once to guard metrics listener start\n\n- Add process-wide sync.Once in metrics package\n- Prevent double-start from main/server\n- No behavior change when METRICS_PROMETHEUS is unset\n\nRefs: [#1](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/issues/1) ([9aeefb8](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/9aeefb8249ffe3fc6a874d6ebda61b42076ebc66))
* **docker-compose:** pass proper -addr :<PORT> in command array ([755f2b9](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/755f2b912441ce47711d9b6d3ca03b4c238e4900))
* **db:** pre-check relation endpoints and trim inputs to prevent FK failures in UpdateRelations ([3803e4a](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/3803e4a22cf110888b0a5bca5ea59071e7ae46ea))
* **sse:** reduce idle disconnects with keep-alive headers, no server timeouts, and 15s SSE heartbeat\n\n- Add Cache-Control/keep-alive and disable proxy buffering\n- Set server timeouts to 0 for long-lived connections\n- Emit periodic SSE comment heartbeats to keep intermediaries from closing connections\n\nRefs: [#11](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/issues/11) ([f4107b7](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/f4107b7a9d92399a304043fd13163faad945a324))
* **search:** remove tautological err check in FTS5 branch ([40ab843](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/40ab843f64ab1e7587ede98b57062f3bed826b23))
* **deps:** update dependency @libsql/client to v0.15.9 ([d94d318](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/d94d318e5f28a3f036f7db8af0271ad50aa029a6))
* **deps:** update dependency @modelcontextprotocol/sdk to v1.15.0 ([6e7f943](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/6e7f94340cea39ead28c5483add239b55bd92aef))
* **deps:** update dependency @modelcontextprotocol/sdk to v1.3.1 ([a4a79c8](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/a4a79c8973fd06217780ada608d7cf5372032f30))
* **deps:** update dependency @modelcontextprotocol/sdk to v1.3.2 ([feb5604](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/feb560464357f8f66b74282e62e9cd80c96979d9))
* **deps:** update dependency @types/node to v22.10.7 ([fdf2fd3](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/fdf2fd3d215d242581f826776dc266ed2ce49591))
* **deps:** update dependency @types/node to v22.16.2 ([26389d9](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/26389d91a89381a977920f30bbe5a2449ed1fe95))
* **deps:** update dependency dotenv to v16.5.0 ([9bed22b](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/9bed22bff1b3a15df593c3f87cea1acf34b59a06))
* **deps:** update dependency dotenv to v16.6.1 ([a00fe7e](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/a00fe7ea7201a81bc27f516e3eee4eae8a7d7b76))
* **deps:** update dependency dotenv to v17 ([bfb7a96](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/bfb7a9692a8105fa2f2a8a01574890c30af0287d))
* update Makefile to use correct binary location for build and run targets ([fc55316](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/fc5531663a7a8c1592e1f00b8841d7d41ed36640))
* update project name retrieval in MCP server handlers to use ProjectArgs ([700f207](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/700f2074094591cf23ea6a24856f0ded365de317))
* update SQL queries to use vector32 for embedding operations ([9e55d0f](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/9e55d0fc4634cc2ccb6344919c0f0be823575b5e))

### 📝 Documentation

* **metrics:** add guidance; docs: fix neighbors row; pkg: complete package-mode APIs; tests: SSE graph tools E2E; db: hybrid toggles ([19e3280](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/19e32807465e78efd11d63704dc10bbc287ad2e6))
* **readme:** add provider curl verification examples and dims mapping table; clarify aliases and configuration ([4e08d59](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/4e08d5929ee3a8b7205d35d9e36c69f10d0d22a3))
* Add README.md with project overview, features, installation, usage, and development guidelines ([26e6b45](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/26e6b450996d44507a76a1c4ef2848d08e0670f5))
* **search:** document BM25 ranking, env tuning, and prompt guidance ([7fda72c](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/7fda72cb24cd017ae272a0a76eacb68b4b823e67))
* **readme:** document Hybrid Search (RRF fusion), env toggle and weights; add run example ([a05c106](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/a05c1063c4f13b7dbdae15bf5f4b585cf357535c))
* document MODE behavior and Coolify build/run guidance ([b279e7d](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/b279e7d531b4f89ba7d509074de77ca396d8b584))
* **README:** enhance emphasis on EMBEDDING_DIMS requirements ([783c350](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/783c35024a658985d8cf6252ebdcc3cb1225fae1))
* fix the name of the README file ([3d9876e](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/3d9876e196690e2a579bf3e475d283293beed17e))
* **README:** update client integration section with detailed transport options and example configurations for stdio and SSE; enhance usage patterns for Docker and raw binary execution ([a7d379a](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/a7d379afbfa61d65b4170ce0007411c3a92959e9))
* **readme:** update EMBEDDING_DIMS value and enhance notes on dimensionality requirements ([e1917e9](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/e1917e9a212196a347791524250947648dca6438))
* update README and prompts guidance for dims adaptation, VoyageAI, and multi-project auth requirements ([606953e](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/606953e1a5f36888cecd1a58a257422080c3a676))
* Update README.md ([00eddeb](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/00eddeb6f79e5b0fdab5179df9de3e942394535a))
* Update README.md ([5720dab](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/5720dab5ca018f5c6b305f447b61f3a8276e4f81))
* Update README.md ([6644984](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/66449842d81bc82ec2e5cb4ff709ed53399fc9a0))
* Update README.md ([b5a2f49](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/b5a2f49396ce1e4395bf60d0d0d55e12932419a7))
* Update README.md ([a0381dd](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/a0381dd8c17121df258fdadeadc4ee0179e3ab46))
* Update README.md to include new quick start examples, tool summaries, and detailed usage for bulk delete operations. Enhanced documentation for embedding dimensions and transport options. ([62d546e](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/62d546ec708d9994acb9644e61274130316d099a))
* update README.md with new transport options and embedding dimensions ([843b60e](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/843b60ecf4854a61483e16d74ae7b4c5f201d877))

### 🎨 Styles

* remove unnecessary whitespace in mcp_types.go and config.go ([051a448](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/051a448271097ce6cc091a65fb7b9dbea0a536aa))

### 🧑‍💻 Code Refactoring

* add buildinfo package for versioning and update server versioning in MCPServer ([1d81b93](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/1d81b9303cf551bb3f0548b337bdc1e4645ff3f3))
* **server:** add TODOs for annotations and prompts; clean up output schema handling in tool registration ([82132f3](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/82132f3751f668cad199857dec17e884f5868512))
* **search:** clean up error handling in SearchEntities function ([55b912b](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/55b912b143987fe437bcf132c70ee11a380cacf3))
* **database): standardize formatting in GetRelations function; test(server:** enhance concurrent client test for SSE server ([6706c35](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/6706c35cac511d76e318a48ac85597e717d3b84a))
* Enhance multi-project support in database and server ([183b6af](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/183b6afdada7cb43f1b50d8e07b7dfe4b770f11a))
* **database): simplify pagination logic in Search function; style(server:** format code for consistency ([2b04053](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/2b04053e0c286ee36a70b71761e8fb1978ee13df))
* **tests): simplify loop constructs in SSE server tests; style(server:** improve code formatting for clarity ([0872f88](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/0872f880d9faa96148475af6045c3597a2a4ca14))
* improve recent entities query to include name sorting and update test database configuration ([2abf13d](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/2abf13d8ec14cd18aa0be241ff685005ee14fc04))
* **search:** introduce SearchStrategy interface and delegate; keep internal path for fallback ([22dfe51](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/22dfe519b7b39d42c30fc30bfd78cfad4b3b5037))
* Remove obsolete database management files and types ([84b1db1](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/84b1db1d680b2938efeb3dd1f4d2fcf63a988587))
* **integration-tester:** replace inline duration calculations with elapsedMsSince function to ensure minimum duration of 1ms ([000ca6f](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/000ca6ffcdad37218598e5991aaa9ed5e5a91ccd))
* replace log.Fatalf with panic for schema creation errors in MCPServer ([07928e0](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/07928e05c1b62ad6885c1fba67a60fa3d12dccf1))
* simplify build process in Makefile and install script ([27d7ee7](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/27d7ee714f6e2130c1403d4c7a54dc9e721802b3))
* **database:** simplify entity deletion logic by removing transaction handling; directly delete observations, relations, and entities ([b08d1cb](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/b08d1cb1a50b7b992bf466875c549414697e4ed4))
* **db:** standardize formatting and indentation in DeleteEntity and DeleteEntities functions ([c564ead](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/c564ead469c82f53ba1017fd62c91f5903e8f246))
* standardize ProjectArgs field annotations across argument types ([06501a8](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/06501a8b7dff28ee00bf9d4ffb3b7d926105000e))
* **docker:** unify memory service, env-driven ports, add entrypoint for MODE; decouple build/run in Makefile ([af34efa](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/af34efa7238d8475f601e7fa8014931da8b04804))
* update build and installation process in Makefile and install script ([3b131d4](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/3b131d41f4743a37b0505422f12b8ce90bcc1e0b))
* update database URL in README and config to use libsql.db ([2040907](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/20409078b3092333a54915df456fbfae1cb9ca7b))
* update install script to ensure binary is built with CGO_ENABLED and set executable permissions ([fd900cb](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/fd900cb357b7bb85ff2eeafd8f41467b7872bd49))
* update install script to use binary location parameter and improve server error handling ([60b7c3d](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/60b7c3d6bc15f8117fd1b9e2c4c97c565671a411))
* update Makefile to use BINARY_NAME variable for consistency ([c480d7c](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/c480d7c9fa29d2275878d9923cf78b7d4c757032))

### ✅ Tests

* **database:** add benchmark tests for entity search and hybrid search functionality ([1d021f9](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/1d021f9cc384410846d4b2793ae5e9d90c81c7c1))
* **server:** add concurrent SSE client test to stress connections ([b41d719](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/b41d719c33b3d8fb65683507c32467ca624f9d0a))
* **search:** add hybrid fallback test and ensure hybrid disabled by default in tests ([74c474e](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/74c474e56802a3eaefb3309c764b77b8b087cebd))
* **server:** add SSE E2E test; fix duplicate schema resolution for open_nodes ([9a0629d](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/9a0629d424caef4cdcf3dbe426fe9ded77f0c28b))
* **server:** add SSE E2E tool-call test (create_entities → search_nodes → read_graph) with structured content decoding ([a76b9f2](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/a76b9f27493a11704834f5dbb568f410f1e5a44b))
* **search): add RRF fusion test with static provider; feat(database:** allow overriding provider for tests ([fe48615](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/fe48615751a6f6bee38806faef8bd40f592691b2))

### 🤖 Build System

* enable CGO for building the Go application; add unit tests for graph operations including shortest path and neighbor retrieval ([ff6346d](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/ff6346ddc6d41b860c201e4d6ba3edf8382f9346))

### 🔁 Continuous Integration

* add CI (lint/test/build/integration) and Release (semantic-release + GHCR) workflows ([c8cbcf1](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/c8cbcf1d6b00202260c41c95b4483c136d81eca0))
* add GitHub Actions workflow to run make docker-test on PRs ([36f608b](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/36f608bd72da4915ddeb591b58816dc5e4289390))
* add semantic-release configuration and remove outdated workflows ([7f2c580](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/7f2c580790516f77d592ca05a3f3c9749991d091))
* enhance Docker testing workflow with integration tests ([59db0f9](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/59db0f9ab43ce6648d5986ac2c4f60ddefe7ba54))
* ensure build deps installed and restrict integration job; bump setup-go to v5 in docker-test workflow ([b736fe2](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/b736fe2a0dfbdee3dedcbb00f5e20b0b029f1eec))
* **init:** introduce ci files ([f7b0eff](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/f7b0effd28a8a7a5ccdc62c62a324768b419070a))
* pin docker/compose action to v2.39.2 (stable release) ([70d1cdc](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/70d1cdcf1bb3f1a47153525c5085a5af6177bc1d))
* pin docker/compose action to v2.7.0 to ensure resolution ([4947df4](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/4947df4a1ea7a09fe152cff317fbc6f178c9130b))
* pin docker/compose-action@v2 to avoid resolution issues ([0eb45fa](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/0eb45fa201364fa19c3d74a71f290be68fe5e37e))
* refactor GitHub Actions workflow for Docker testing ([5edf316](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/5edf3164b8faf0495419b2e055f9bd3f3d776d14))
* update Docker Compose action to use main branch ([070b434](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/070b4348b8a08e607006dd525155a11bde076054))
* **fix:** Update entrypoint.sh ([d5e768d](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/d5e768dc3b5daa88bc1374ba64bf3b81461d4521))
* **fix-install:** update message for existing binary removal during installation ([705d301](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/705d3014dc591272150619465646bd017478aaee))
* use docker/compose@v2 action (fix missing repo) ([2846468](https://github.com/ZanzyTHEbar/mcp-memory-libsql-go/commit/284646881985886689afb4fb8f77a0e0eb772bb6))
