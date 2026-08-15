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
