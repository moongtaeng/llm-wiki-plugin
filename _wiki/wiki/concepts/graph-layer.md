---
type: concept
title: "그래프 레이어"
tags: [plugin-design]
sources: [llm-wiki-graph-workflow-reference, llm-wiki-skill-md-reference, llm-wiki-architecture-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 그래프 레이어

마크다운 위키 위에 얹는 선택적 컴파일 인덱스. `wiki/graph/`에 위치하며 마크다운을 대체하지 않고 그 옆에서 언제든 마크다운으로부터 재생성 가능하다. [[three-layer-three-operation-architecture]]가 정의하는 3계층에 추가되는 선택적 4번째 계층이며, 상세 스펙은 [[llm-wiki-graph-workflow-reference]]에 근거한다.

## 존재 이유

타입 있고 출처가 뒷받침된 관계("누가 무엇을 창립했나", "무엇이 무엇에 의존하나")를 마크다운의 편집 용이성과 사람 가독성을 포기하지 않고 기계 조회 가능하게 만드는 것이 목적이다. `wiki/graph/ontology.yaml`이 없으면 위키는 pre-graph 상태이며, 이 경우 extract/lint/query를 실행하지도 온톨로지 파일을 지어내지도 않는다.

## 세 종류의 엣지

타입 있는 의미 엣지(frontmatter `graph.relationships[]`, 근거 인용 필수)와 [[implicit-graph-predicates]](mentions/sourced_from/summarizes_raw, 추출기가 자동 파생)로 나뉜다. [[typed-edge-vs-wikilink]]가 이 둘 사이의 판단 기준을 규정한다.

## 계약: 온톨로지

[[wiki-graph-ontology]]가 노드 타입/predicate의 허용 목록을 선언하고, `wiki_graph_lint.py`가 이 계약에 대해 모든 타입 엣지를 검증한다.

## extract/lint/query 삼각 구조

`wiki_graph_lint.py`(검증, 수정 안 함) → `wiki_graph_extract.py`(nodes.jsonl/edges.jsonl/graph.sqlite/graph.graphml 컴파일) → `wiki_graph_query.py`(neighbors/edges/path/facts 조회)의 순환. 인제스트가 타입 엣지를 추가하면 이 루프를 다시 돈다.

## 관련 페이지

- [[three-layer-three-operation-architecture]]
- [[wiki-graph-ontology]]
- [[typed-edge-vs-wikilink]]
- [[implicit-graph-predicates]]
- [[graph-extract-lint-shared-logic]]
- [[graph-layer-opt-in-triple-script]]
