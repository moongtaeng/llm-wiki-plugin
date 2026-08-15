---
type: source
title: "llm-wiki 스킬 그래프 워크플로 레퍼런스"
authors: ["llm-wiki plugin maintainers"]
url: null
raw: "_wiki/raw/llm-wiki-graph-workflow-reference.md"
ingested: 2026-08-15
tags: [plugin-design]
entities: []
concepts: [graph-layer, wiki-graph-ontology, typed-edge-vs-wikilink, implicit-graph-predicates]
created: 2026-08-15
updated: 2026-08-15
---

# llm-wiki 스킬 그래프 워크플로 레퍼런스

`references/graph-workflow.md`는 마크다운 위키 위에 선택적으로 얹는 컴파일된 인덱스인 그래프 레이어의 상세 스펙이다. `wiki/graph/ontology.yaml`이 없으면 위키는 pre-graph 상태이며 extract/lint/query를 실행하지도 온톨로지 파일을 지어내지도 않는다.

## 그래프가 담는 세 종류의 엣지

1. **타입 있는 의미 엣지** — 페이지 frontmatter `graph.relationships[]`에 선언. `predicate`, `object`, `source`(소스 페이지 슬러그), `evidence`(근거 인용), `confidence`(high/medium/low), `status`(current/historical/proposed/disputed/superseded)가 필수. 추출기가 절대 이를 지어내지 않는다.
2. **`mentions` 엣지** — 본문 이중 대괄호 위키링크 하나당 하나(페이지당 중복 제거), confidence는 항상 low. 탐색은 가속하지만 타입 있는 관계의 근거로 인용해선 안 된다.
3. **`sourced_from`/`summarizes_raw` 엣지** — 각각 frontmatter `sources:` 목록 슬러그, source 페이지의 `raw:` 필드에서 파생. `summarizes_raw`의 객체는 위키 노드가 아니라 raw 경로 문자열 리터럴이다.

## 타입 엣지 vs 평문 위키링크

특정 소스가 명시적으로 관계를 서술하고, 근거 인용을 뽑을 수 있고, predicate가 후속 질의에 의미 있을 때 타입 엣지를 추가한다. 관계가 암묵적이거나 단일 소스 인용에 고정할 수 없으면 평문 이중 대괄호 위키링크를 쓴다 — **불확실하면 위키링크를 쓰고 타입 엣지는 건너뛴다.** 린트는 근거 누락을 잡아내지만 under-claiming을 벌하지 않는다.

## 온톨로지

`wiki/graph/ontology.yaml`이 계약이다. `node_types[*].maps_from`(페이지 `type`/`kind`가 노드 타입으로 투영되는 규칙)과 `predicates[*]`(허용된 predicate, 각각의 `subject_types`/`object_types`/`requires_evidence`)를 선언한다. `decision`/`claim`/`raw`는 explicit-only 타입 — 위키 페이지가 없고 엣지 객체로만 등장한다.

## extract/lint/query 루프

```bash
uv run --script scripts/wiki_graph_lint.py wiki/      # 검증(수정 안 함)
uv run --script scripts/wiki_graph_extract.py wiki/   # nodes.jsonl/edges.jsonl/graph.sqlite/graph.graphml 컴파일
python scripts/wiki_graph_query.py wiki/ neighbors --node <id>
```

## 인제스트/질의 워크플로 통합

인제스트 표준 절차의 6단계 이후: 새 타입 엣지가 추가됐으면 `wiki_graph_lint.py`로 사용자와 트리아지 후 `wiki_graph_extract.py`로 컴파일 아티팩트를 갱신하고, 로그에 `graph: +N nodes, +M typed edges` 서브라인을 추가한다. 페이지에 `graph.relationships[]`가 없고 신규 페이지도 없으면 이 단계는 건너뛴다. 질의 워크플로에서는 관계형 냄새가 나는 질문에 인덱스 다음·페이지 읽기 전 `neighbors`/`edges`/`facts`로 그래프를 조회하되, 항상 이중 대괄호 위키링크로 위키 페이지를 인용하고 그래프 행 자체를 답변 근거로 삼지 않는다.

## 생성 아티팩트 정책

`ontology.yaml`은 canonical이며 추적됨. `nodes.jsonl`/`edges.jsonl`은 생성되지만 선택적으로 추적 가능. `graph.sqlite`/`graph.graphml`은 생성되며 기본적으로 gitignore됨.

## 안티패턴

근거 없는 타입 엣지, `nodes.jsonl`/`edges.jsonl`/`graph.sqlite`를 손으로 직접 편집(마크다운을 편집하고 재생성해야 함), 억지로 타입 엣지를 맞추기 위해 온톨로지 항목을 지어내기, 그래프 행을 답변의 근거로 취급, 인제스트 후 재생성을 잊음.

## 이 소스가 연결되는 곳

- [[graph-layer]]
- [[wiki-graph-ontology]]
- [[typed-edge-vs-wikilink]]
- [[implicit-graph-predicates]]
