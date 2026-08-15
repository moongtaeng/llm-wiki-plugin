---
type: concept
title: "그래프 extract/lint 로직 공유 설계"
tags: [plugin-design]
sources: [llm-wiki-bundled-scripts-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 그래프 extract/lint 로직 공유 설계

`wiki_graph_lint.py`가 `wiki_graph_extract.py`를 서브프로세스가 아니라 **파이썬 모듈로 직접 import**해서 `build_nodes`/`build_edges` 함수를 그대로 재사용하는 설계.

## 왜 로직을 공유하는가

코드 주석이 이유를 명시한다: "Same module is imported by extract; we re-use its build_nodes/build_edges to guarantee lint sees exactly what extract would emit." 만약 lint와 extract가 노드/엣지를 각자 독립적으로 계산했다면, 두 구현이 미묘하게 갈라질 위험이 항상 존재한다 — 예컨대 lint는 통과시켰는데 extract가 실제로는 다른 노드를 만들어내는 불일치가 생길 수 있다. 모듈을 공유함으로써 이 불일치 가능성을 구조적으로 차단한다.

## [[graph-layer]]에서의 위치

이 설계 덕분에 [[graph-layer]]의 extract/lint/query 루프에서 "lint를 통과했는데 extract 결과가 다르다"는 신뢰 문제가 원천적으로 발생하지 않는다.

## 관련 페이지

- [[graph-layer]]
- [[implicit-graph-predicates]]
