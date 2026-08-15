---
type: concept
title: "그래프 레이어의 opt-in 3스크립트 구조"
tags: [plugin-design]
sources: [wiki-slash-commands-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 그래프 레이어의 opt-in 3스크립트 구조

[[graph-layer]]는 `wiki_graph_extract.py`(컴파일), `wiki_graph_lint.py`(검증), `wiki_graph_query.py`(조회) 3개 스크립트로 구성되며, [[ingest-workflow]]/[[lint-workflow]]는 그래프가 존재할 때만 관여하고 `/wiki:graph` 커맨드가 이 세 스크립트를 직접 조작하는 전용 진입점 역할을 한다.

## `/wiki:graph`의 서브커맨드 디스패치

`extract`/`lint`/`neighbors --node <id>`/`edges --subject <id>`/`path --from <id> --to <id>`/`facts --about <id>`로 첫 인자에 따라 세 스크립트 중 하나를 호출한다. `wiki/graph/ontology.yaml`이 없으면 위키는 pre-graph 상태이며, 온톨로지를 지어내지 않고 시딩을 제안하는 데 그친다.

## 다른 커맨드와의 관계

`/wiki:ingest`와 `/wiki:lint`도 각자 그래프 관련 단계(타입 엣지 추가/검증)를 갖지만, 이들은 조건부 스텝일 뿐이고 그래프를 직접 조작하는 전용 인터페이스는 `/wiki:graph` 하나뿐이다.

## 관련 페이지

- [[graph-layer]]
- [[graph-extract-lint-shared-logic]]
- [[implicit-graph-predicates]]
