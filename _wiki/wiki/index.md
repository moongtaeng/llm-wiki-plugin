# Wiki Index

The catalog of all pages in this wiki. Each entry: a wikilink to the page and a one-line summary. The LLM reads this first when answering queries to identify candidate pages.

Keep summaries tight — one line each. The index is engineered to be cheap to read; a fat index defeats its purpose.

When this file exceeds ~300 lines or the wiki passes ~150 pages, shard into `wiki/indexes/<type>.md` and replace this file with a directory of shards. See the `scaling-playbook.md` reference in the `llm-wiki` skill for the migration procedure.

---

## Sources

- [[project-goal-adopt-llm-wiki]] — 이 프로젝트 개발에 llm-wiki를 도입하겠다는 프로젝트 소유자의 지시문. Updated: 2026-08-15
- [[llm-wiki-architecture-reference]] — llm-wiki 스킬의 3계층/3연산 아키텍처 설계 근거 레퍼런스. Updated: 2026-08-15
- [[llm-wiki-skill-md-reference]] — SKILL.md 허브 문서(트리거, 아키텍처 요약, 4대 실패 모드). Updated: 2026-08-15
- [[llm-wiki-ingest-workflow-reference]] — ingest 10단계 절차 레퍼런스. Updated: 2026-08-15
- [[llm-wiki-query-workflow-reference]] — query 6단계 절차 레퍼런스. Updated: 2026-08-15
- [[llm-wiki-lint-workflow-reference]] — lint 6단계 절차 레퍼런스. Updated: 2026-08-15
- [[llm-wiki-graph-workflow-reference]] — 그래프 레이어(온톨로지, 타입 엣지, extract/lint/query) 레퍼런스. Updated: 2026-08-15
- [[llm-wiki-page-conventions-reference]] — frontmatter/네이밍/크기/hedging 페이지 컨벤션 레퍼런스. Updated: 2026-08-15
- [[llm-wiki-retrieval-setup-reference]] — 검색 셋업 인터뷰 및 필수 런타임 검증 레퍼런스. Updated: 2026-08-15
- [[llm-wiki-scaling-playbook-reference]] — 5단계 스케일링 임계값과 마이그레이션 레퍼런스. Updated: 2026-08-15
- [[llm-wiki-agent-memory-integration-reference]] — 에이전트 메모리 파일 통합 절차 레퍼런스. Updated: 2026-08-15
- [[llm-wiki-wiki-search-script-reference]] — wiki_search.py 하이브리드 검색 엔진 소스코드 레퍼런스. Updated: 2026-08-15
- [[llm-wiki-bundled-scripts-reference]] — init/setup/stats/lint/graph 3종 등 번들 스크립트 7개 소스코드 레퍼런스. Updated: 2026-08-15
- [[wiki-slash-commands-reference]] — 7개 /wiki:* 슬래시 커맨드 레퍼런스. Updated: 2026-08-15
- [[plugin-manifest-and-versioning]] — plugin.json/marketplace.json/CHANGELOG.md 매니페스트 및 버전 북키핑. Updated: 2026-08-15

## Entities

- [[llm-wiki-plugin]] — 이 저장소가 소스인 Claude Code 플러그인(v3.0.0, product). Updated: 2026-08-15
- [[andrej-karpathy]] — LLM Wiki 패턴의 원 제안자(person). Updated: 2026-08-15
- [[baai-bge-small-en-v1-5]] — 로컬 임베딩 모델, 384차원(model). Updated: 2026-08-15
- [[fastembed]] — 로컬 임베딩 추론 라이브러리(library). Updated: 2026-08-15
- [[sqlite-vec]] — 벡터 유사도 검색 SQLite 확장(library). Updated: 2026-08-15
- [[pyyaml]] — YAML 파싱 라이브러리(library). Updated: 2026-08-15
- [[uv]] — Python 패키지/스크립트 러너, PEP 723 실행 전제조건(tool). Updated: 2026-08-15

## Concepts

- [[dogfooding-llm-wiki]] — llm-wiki를 이 플러그인 자체 개발에 재귀적으로 적용하는 실천. Updated: 2026-08-15
- [[three-layer-three-operation-architecture]] — raw/wiki/schema(+graph) 3계층과 ingest/query/lint 3연산 구조. Updated: 2026-08-15
- [[ingest-workflow]] — 새 소스를 위키 페이지로 컴파일하는 10단계 절차. Updated: 2026-08-15
- [[query-workflow]] — 인덱스 우선 탐색으로 질문에 답하는 6단계 절차. Updated: 2026-08-15
- [[lint-workflow]] — 구조 패스+의미 패스로 나뉜 위키 건강 점검 절차. Updated: 2026-08-15
- [[graph-layer]] — 마크다운 위에 얹는 선택적 컴파일 그래프 인덱스. Updated: 2026-08-15
- [[wiki-graph-ontology]] — ontology.yaml이 선언하는 노드 타입/predicate 계약. Updated: 2026-08-15
- [[typed-edge-vs-wikilink]] — 타입 엣지 vs 평문 위키링크 판단 기준("불확실하면 위키링크"). Updated: 2026-08-15
- [[implicit-graph-predicates]] — 자동 파생되는 mentions/sourced_from/summarizes_raw 엣지. Updated: 2026-08-15
- [[page-conventions]] — 모든 위키 페이지의 frontmatter/링크/hedging 기본 규칙. Updated: 2026-08-15
- [[page-sizing-discipline]] — 400/800줄 캡과 원자성 휴리스틱. Updated: 2026-08-15
- [[scalability-discipline]] — 확장성을 위한 8원칙 상위 개념. Updated: 2026-08-15
- [[scaling-playbook-thresholds]] — 페이지 수 기준 5단계 스케일링 임계값과 마이그레이션. Updated: 2026-08-15
- [[custom-page-types]] — 기본 4타입 외 커스텀 페이지 타입 도입 기준. Updated: 2026-08-15
- [[hybrid-retrieval-search]] — 섹션 레벨 BM25+semantic RRF 융합 검색. Updated: 2026-08-15
- [[wiki-cache-layer]] — .wiki-cache/의 파싱 캐시와 벡터 캐시. Updated: 2026-08-15
- [[retrieval-setup-interview]] — /wiki:init·/wiki:upgrade 전 그룹 인터뷰와 fail-closed 검증. Updated: 2026-08-15
- [[agent-memory-integration-concept]] — CLAUDE.md/AGENTS.md/GEMINI.md에 위키를 알리는 스탠자 관행. Updated: 2026-08-15
- [[wiki-failure-modes]] — LLM Wiki의 4대 실패 모드(침묵의 부패 등). Updated: 2026-08-15
- [[staleness-heuristic-lint]] — 90일+인바운드 3개 이상 stale 페이지 탐지 휴리스틱. Updated: 2026-08-15
- [[reciprocal-rank-fusion-search]] — BM25와 semantic 랭크를 순위 기반으로 융합하는 RRF. Updated: 2026-08-15
- [[section-level-vs-page-level-search-granularity]] — ATX 헤딩 기준 섹션 단위 검색 기본값. Updated: 2026-08-15
- [[content-hash-incremental-embedding-cache]] — 섹션별 content-hash 기반 증분 재임베딩 전략. Updated: 2026-08-15
- [[local-semantic-backend]] — API 없이 기기 내에서 동작하는 FastEmbed+sqlite-vec 백엔드. Updated: 2026-08-15
- [[bm25-scoring]] — 외부 라이브러리 없이 직접 구현한 BM25 랭킹. Updated: 2026-08-15
- [[pep-723-inline-dependency-declaration]] — `# /// script` 블록으로 pinned 의존성을 선언하는 컨벤션. Updated: 2026-08-15
- [[pure-stdlib-fallback-scripts]] — 의존성 없이 stdlib만으로 동작하는 스크립트 그룹. Updated: 2026-08-15
- [[schema-upgrade-marker-detection]] — SCHEMA.md 누락 섹션을 감지하되 자동 병합하지 않는 업그레이드 전략. Updated: 2026-08-15
- [[graph-extract-lint-shared-logic]] — wiki_graph_lint.py가 extract 로직을 재사용해 불일치를 차단하는 설계. Updated: 2026-08-15
- [[slash-command-thin-wrapper-pattern]] — 7개 /wiki:* 커맨드가 스킬 워크플로를 가리키기만 하는 얇은 래퍼 패턴. Updated: 2026-08-15
- [[version-bookkeeping-three-sync-points]] — plugin.json/marketplace.json/CHANGELOG.md 3곳 버전 동기화. Updated: 2026-08-15
- [[wiki-upgrade-idempotent-strategy]] — /wiki:upgrade의 idempotent 업그레이드와 섹션별 승인 병합. Updated: 2026-08-15
- [[graph-layer-opt-in-triple-script]] — extract/lint/query 3스크립트로 구성된 opt-in 그래프 레이어 구조. Updated: 2026-08-15
- [[local-hybrid-retrieval-default]] — v3.0.0에서 로컬 하이브리드 검색이 기본값이 된 릴리스 결정. Updated: 2026-08-15

## Synthesis

(populated as query answers are filed back)
