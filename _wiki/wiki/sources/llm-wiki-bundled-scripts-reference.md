---
type: source
title: "llm-wiki 번들 스크립트 계층 (init/setup/stats/lint/graph 3종)"
authors: ["llm-wiki plugin maintainers"]
url: null
raw: "_wiki/raw/scripts/init_wiki.py; _wiki/raw/scripts/setup_wiki.py; _wiki/raw/scripts/wiki_stats.py; _wiki/raw/scripts/wiki_lint.py; _wiki/raw/scripts/wiki_graph_query.py; _wiki/raw/scripts/wiki_graph_lint.py; _wiki/raw/scripts/wiki_graph_extract.py"
ingested: 2026-08-15
tags: [plugin-design]
entities: [uv, pyyaml]
concepts: [pure-stdlib-fallback-scripts, pep-723-inline-dependency-declaration, schema-upgrade-marker-detection, graph-extract-lint-shared-logic, implicit-graph-predicates, staleness-heuristic-lint]
created: 2026-08-15
updated: 2026-08-15
---

# llm-wiki 번들 스크립트 계층

`wiki_search.py`([[llm-wiki-wiki-search-script-reference]]로 별도 인제스트됨)를 제외한 7개 스크립트를 하나의 소스로 묶었다 — 각 스크립트가 개별 소스로 쪼개면 원자성 원칙에 비해 지나치게 얇은 요약이 되기 때문이다.

## init_wiki.py (253줄, pure stdlib)

프로젝트에 wiki/raw 디렉터리 구조를 부트스트랩/업그레이드한다. `SUBDIRS = ["sources","entities","concepts","synthesis","graph"]` 생성 후 `assets/*.template`을 idempotent하게 복사한다(`copy_template` — 이미 존재하면 건드리지 않음). `--upgrade` 모드는 `SCHEMA_SECTION_MARKERS`로 SCHEMA.md에 없는 버전별 섹션을 감지해 병합 안내만 출력하고 **절대 SCHEMA.md를 덮어쓰지 않는다**([[schema-upgrade-marker-detection]]). 모듈 docstring: "It never overwrites SCHEMA.md — the schema is co-evolved with the user." 마지막에 `install_runtime()`이 `uv` 존재를 확인 후 `setup_wiki.py`를 서브프로세스로 호출한다.

## setup_wiki.py (78줄, PEP 723: fastembed==0.8.0, pyyaml==6.0.3, sqlite-vec==0.1.9)

최소 러너. `wiki_search.py`를 모듈로 import해서 `collect_pages` → `collect_sections` → `load_local_embedding_backend` → `open_vector_index` → `sync_vector_index`를 호출해 임베딩 벡터 인덱스를 미리 구축·검증한다. 벡터 개수와 섹션 locator 개수가 안 맞으면 `RuntimeError`로 즉시 실패한다 — 침묵 실패를 허용하지 않는 설계.

## wiki_stats.py (155줄, pure stdlib)

페이지 수/줄수/단어수/링크수 집계, 타입별·디렉터리별 분포, 최대 크기 페이지 top10, 최다 인바운드 링크(hub) top10, 스케일링 임계값 권고(150+페이지 or index 300줄+ → 샤딩, 300+ → 검색 스크립트 상용화, 500+ → 주간 린트)를 출력한다. `indexes`/`graph`/`raw`는 페이지 집계에서 제외.

## wiki_lint.py (315줄, pure stdlib)

구조적 린트. 자체 정규식 기반 frontmatter 파서(PyYAML 미사용 — [[pure-stdlib-fallback-scripts]] 규율 유지)로 고아, 깨진 위키링크, 크기 초과, frontmatter 누락, 중복 슬러그, [[staleness-heuristic-lint]](90일+인바운드 3개 이상), `--suggest-pages`(대문자 구 패턴이 여러 페이지에 반복 등장하는데 전용 페이지가 없는 경우)를 리포트한다. 자동 수정은 없다.

## wiki_graph_query.py (263줄, pure stdlib, sqlite3만 사용)

컴파일된 `graph.sqlite`에 대한 조회 CLI. `neighbors`/`edges --subject`/`path --from --to`(BFS 최단경로, max-depth 6)/`facts --about` 서브커맨드. 순수 조회 전용이며 그래프를 생성하지 않는다 — `graph.sqlite`가 없으면 "Run wiki_graph_extract.py first" 안내 후 종료한다.

## wiki_graph_lint.py (420줄, PEP 723: pyyaml==6.0.3)

타입 있는 그래프 메타데이터를 검증한다. `wiki_graph_extract.py`를 모듈로 직접 import해서([[graph-extract-lint-shared-logic]]) extract와 정확히 동일한 노드/엣지 계산 로직을 재사용한다 — 코드 주석: "Same module is imported by extract; we re-use its build_nodes/build_edges to guarantee lint sees exactly what extract would emit." 검사 항목: 중복 node_id, 온톨로지에 없는 predicate, 끊어진 object 참조, subject/object 타입 불일치, 근거/소스 누락, 잘못된 confidence/status 값, alias 충돌, 끊어진 contradicts/supersedes 참조, orphan typed node.

## wiki_graph_extract.py (541줄, PEP 723: pyyaml==6.0.3)

그래프 레이어의 실제 컴파일러. 노드는 온톨로지의 `maps_from` 또는 명시적 `graph.node_type`으로 도출하고, node_id는 `graph.node_id` 명시값 또는 `{node_type}:{slug}` 기본값이다. 엣지는 [[implicit-graph-predicates]]의 4종류(타입 엣지, mentions, sourced_from, summarizes_raw)로 파생된다. 엣지 id는 `subject|predicate|object|source|evidence`를 SHA256 후 24자로 절단한다 — 코드 주석: "collision risk is negligible at any plausible wiki scale and shorter ids keep the JSONL/sqlite/graphml outputs readable." 출력 포맷 3종(jsonl/sqlite/graphml)을 `--formats`로 선택 가능하다.

## 스크립트 간 데이터 흐름

```
init_wiki.py → (subprocess, via uv) → setup_wiki.py
                                          └─ imports wiki_search.py 함수들
wiki_graph_lint.py → (import, not subprocess) → wiki_graph_extract.py
wiki_graph_query.py ← 입력: wiki_graph_extract.py가 생성한 graph.sqlite
```

## 이 소스가 연결되는 곳

- [[pure-stdlib-fallback-scripts]]
- [[pep-723-inline-dependency-declaration]]
- [[schema-upgrade-marker-detection]]
- [[graph-extract-lint-shared-logic]]
- [[implicit-graph-predicates]]
- [[staleness-heuristic-lint]]
- [[uv]], [[pyyaml]]
