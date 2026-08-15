# Wiki Index

The catalog of all pages in this wiki. Each entry: a wikilink to the page and a one-line summary. The LLM reads this first when answering queries to identify candidate pages.

Keep summaries tight — one line each. The index is engineered to be cheap to read; a fat index defeats its purpose.

When this file exceeds ~300 lines or the wiki passes ~150 pages, shard into `wiki/indexes/<type>.md` and replace this file with a directory of shards. See the `scaling-playbook.md` reference in the `llm-wiki` skill for the migration procedure.

---

## Sources

- [[project-goal-adopt-llm-wiki]] — 이 프로젝트 개발에 llm-wiki를 도입하겠다는 프로젝트 소유자의 지시문. Updated: 2026-08-15
- [[llm-wiki-architecture-reference]] — llm-wiki 스킬의 3계층/3연산 아키텍처 설계 근거 레퍼런스. Updated: 2026-08-15

## Entities

(populated as entity pages are created)

## Concepts

- [[dogfooding-llm-wiki]] — llm-wiki를 이 플러그인 자체 개발에 재귀적으로 적용하는 실천. Updated: 2026-08-15
- [[three-layer-three-operation-architecture]] — raw/wiki/schema(+graph) 3계층과 ingest/query/lint 3연산 구조. Updated: 2026-08-15

## Synthesis

(populated as query answers are filed back)
