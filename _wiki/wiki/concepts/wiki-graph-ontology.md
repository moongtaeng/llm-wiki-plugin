---
type: concept
title: "위키 그래프 온톨로지"
tags: [plugin-design]
sources: [llm-wiki-graph-workflow-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 위키 그래프 온톨로지

`wiki/graph/ontology.yaml`이 선언하는 노드 타입/predicate 계약. [[graph-layer]]의 근거이며, 모든 타입 엣지는 이 계약에 대해 검증된다.

## 무엇을 선언하는가

`node_types[*].maps_from`은 페이지의 `type`/`kind`가 어떤 노드 타입으로 투영되는지를 정의한다(예: `type: entity, kind: person` → `person`). `predicates[*]`는 허용된 predicate마다 `subject_types`, `object_types`, `requires_evidence`를 선언한다. `"*"`는 양쪽 어디든 붙는 와일드카드다.

## explicit-only 타입

`decision`, `claim`, `raw`는 위키 페이지를 갖지 않는 explicit-only 노드 타입이다 — 오직 타입 엣지의 객체로만 등장한다. 타입 엣지가 이런 노드를 가리키면, 그 노드에 대응하는 위키 페이지를 만들거나 온톨로지에 `explicit_only: true`로 명시하지 않는 한 `wiki_graph_lint.py`가 "깨진 객체 참조"로 계속 플래그한다.

## 이 도그푸드 위키의 실제 온톨로지

`_wiki/wiki/graph/ontology.yaml`은 `person`/`company`/`product`/`paper`/`place`/`organization`/`concept`/`source`/`synthesis`/`decision`/`claim`/`raw` 노드 타입과, `mentions`/`sourced_from`/`summarizes_raw`([[implicit-graph-predicates]])에 더해 `founded`/`owns`/`contains_product`/`works_on`/`chose`/`proposed`/`competes_with`/`depends_on`/`authored`/`cites`/`contradicts`/`supersedes` 타입 predicate를 선언하고 있다.

## 확장 시점

새 도메인 predicate가 필요할 때 온톨로지를 편집하고 `wiki_graph_lint.py`를 재실행해 검증한다. 기존 타입 엣지가 더 이상 맞지 않으면 lint가 잡아낸다.

## 관련 페이지

- [[graph-layer]]
- [[typed-edge-vs-wikilink]]
