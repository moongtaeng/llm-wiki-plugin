# Wiki Log

Append-only chronological record of operations on the wiki. Each entry begins with `## [YYYY-MM-DD] <op> | <description>` so it's parseable with `grep "^## \[" log.md | tail -N`.

Operations:
- `ingest` — a source was processed into the wiki.
- `query` — a question was answered against the wiki (typically only logged when the answer was filed back as synthesis).
- `lint` — a health check was run.
- `schema` — the schema was modified.
- `shard` — an index was sharded.

---

## [2026-08-15] ingest | 프로젝트 목표: 이 프로젝트 자체 개발에 llm-wiki 도입
- Disposition: New
- Raw: _wiki/raw/2026-08-15-project-goal-adopt-llm-wiki.md
- Created: wiki/sources/project-goal-adopt-llm-wiki.md, wiki/concepts/dogfooding-llm-wiki.md

## [2026-08-15] ingest | llm-wiki 스킬 아키텍처 레퍼런스
- Disposition: New
- Raw: _wiki/raw/llm-wiki-architecture-reference.md
- Created: wiki/sources/llm-wiki-architecture-reference.md, wiki/concepts/three-layer-three-operation-architecture.md
- Updated: wiki/concepts/dogfooding-llm-wiki.md

## [2026-08-15] ingest | llm-wiki 스킬 프로즈 전체 (SKILL.md + references 8개)
- Disposition: New
- Raw: _wiki/raw/llm-wiki-skill-md-reference.md; _wiki/raw/llm-wiki-ingest-workflow-reference.md; _wiki/raw/llm-wiki-query-workflow-reference.md; _wiki/raw/llm-wiki-lint-workflow-reference.md; _wiki/raw/llm-wiki-graph-workflow-reference.md; _wiki/raw/llm-wiki-page-conventions-reference.md; _wiki/raw/llm-wiki-retrieval-setup-reference.md; _wiki/raw/llm-wiki-scaling-playbook-reference.md; _wiki/raw/llm-wiki-agent-memory-integration-reference.md
- Created: 8 source pages (wiki/sources/llm-wiki-*-reference.md), 14 concept pages (ingest-workflow, query-workflow, lint-workflow, graph-layer, wiki-graph-ontology, typed-edge-vs-wikilink, implicit-graph-predicates, page-conventions, page-sizing-discipline, scalability-discipline, scaling-playbook-thresholds, custom-page-types, hybrid-retrieval-search, wiki-cache-layer, retrieval-setup-interview, agent-memory-integration-concept, wiki-failure-modes, staleness-heuristic-lint)
- Updated: wiki/concepts/three-layer-three-operation-architecture.md (연산/그래프/확장성/실패모드 상호 링크 보강)

## [2026-08-15] ingest | llm-wiki 번들 스크립트 8개 (wiki_search.py + 7종)
- Disposition: New
- Raw: _wiki/raw/scripts/wiki_search.py; _wiki/raw/scripts/init_wiki.py; _wiki/raw/scripts/setup_wiki.py; _wiki/raw/scripts/wiki_stats.py; _wiki/raw/scripts/wiki_lint.py; _wiki/raw/scripts/wiki_graph_query.py; _wiki/raw/scripts/wiki_graph_lint.py; _wiki/raw/scripts/wiki_graph_extract.py
- Created: 2 source pages (llm-wiki-wiki-search-script-reference, llm-wiki-bundled-scripts-reference), 9 concept pages (reciprocal-rank-fusion-search, section-level-vs-page-level-search-granularity, content-hash-incremental-embedding-cache, local-semantic-backend, bm25-scoring, pep-723-inline-dependency-declaration, pure-stdlib-fallback-scripts, schema-upgrade-marker-detection, graph-extract-lint-shared-logic)

## [2026-08-15] ingest | 7개 /wiki:* 슬래시 커맨드 + 플러그인 매니페스트/버전 북키핑
- Disposition: New
- Raw: _wiki/raw/commands/init.md; _wiki/raw/commands/ingest.md; _wiki/raw/commands/query.md; _wiki/raw/commands/lint.md; _wiki/raw/commands/stats.md; _wiki/raw/commands/upgrade.md; _wiki/raw/commands/graph.md; _wiki/raw/plugin-manifest-and-versioning.md
- Created: 2 source pages (wiki-slash-commands-reference, plugin-manifest-and-versioning), 5 concept pages (slash-command-thin-wrapper-pattern, version-bookkeeping-three-sync-points, wiki-upgrade-idempotent-strategy, graph-layer-opt-in-triple-script, local-hybrid-retrieval-default), 1 entity page (llm-wiki-plugin)

## [2026-08-15] ingest | 코드/문서 전반에 등장하는 모델·라이브러리·도구·인물 엔티티 6종
- Disposition: New
- Raw: (기존에 인제스트된 소스들에서 파생 — retrieval-setup-reference, wiki_search.py, plugin-manifest-and-versioning 등)
- Created: 6 entity pages (baai-bge-small-en-v1-5, fastembed, sqlite-vec, pyyaml, uv, andrej-karpathy)

## [2026-08-15] lint | 22 issues found, 22 fixed
- 10 broken wikilinks: 여러 source 페이지 본문이 위키링크 문법(`[[...]]`)을 예시로 설명하며 실제 이중 대괄호를 그대로 써서 wiki_lint.py가 링크로 오인 → 문법 설명을 "이중 대괄호 위키링크"로 재서술해 해결.
- 12 orphan pages: 신규 source 페이지 12개가 frontmatter `sources:`에는 등록됐지만 어떤 concept 페이지 본문에서도 위키링크로 인용되지 않음 → 대응 concept 페이지 본문에 `[[source-slug]]` 인바운드 링크 추가.
- 재검증: wiki_lint.py 이슈 0건, wiki_stats.py 기준 56페이지/링크밀도 5.9/샤딩 임계값 미만.
