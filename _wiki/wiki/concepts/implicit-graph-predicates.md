---
type: concept
title: "암묵적 그래프 predicate (mentions/sourced_from/summarizes_raw)"
tags: [plugin-design, retrieval]
sources: [llm-wiki-graph-workflow-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 암묵적 그래프 predicate

사용자가 `graph.relationships[]`에 명시하지 않아도 `wiki_graph_extract.py`가 마크다운 구조에서 자동으로 파생시키는 3종 엣지. [[graph-layer]]가 캡처하는 세 엣지 클래스 중 타입 엣지를 제외한 나머지 전부다.

## 세 종류

- **`mentions`** — 본문의 이중 대괄호 위키링크 하나당 하나(페이지당 중복 제거), confidence는 항상 low. 탐색 가속용이며 타입 있는 관계의 증거로 취급하지 않는다.
- **`sourced_from`** — 페이지 frontmatter `sources:` 목록의 각 슬러그마다 하나, 해당 source 페이지를 가리킨다.
- **`summarizes_raw`** — source 페이지의 `raw:` 필드에서 파생. 객체는 위키 노드가 아니라 raw 파일 경로 문자열 리터럴이다(이 점이 다른 엣지와 근본적으로 다르다 — 그래프의 노드 집합에 속하지 않는 대상을 가리킨다).

## 왜 자동 파생인가

이 세 엣지는 사용자가 명시적으로 선언할 필요가 없다 — 이미 존재하는 컨벤션(본문 위키링크, frontmatter `sources:`/`raw:`)에서 기계적으로 유도된다. 즉 그래프가 없는 위키에서도 이미 존재하는 정보를 그래프가 켜지는 순간 그대로 재사용하는 설계다.

## typed edge와의 관계

[[typed-edge-vs-wikilink]]가 규정하듯, 근거가 불확실한 관계는 타입 엣지 대신 평문 위키링크로 남기면 되는데, 그렇게 남긴 위키링크가 바로 `mentions` 엣지로 그래프에 흡수된다 — 즉 "확신이 없을 때의 기본값"이 그래프에서 완전히 버려지는 게 아니라 낮은 신뢰도 엣지로 보존된다.

## 관련 페이지

- [[graph-layer]]
- [[typed-edge-vs-wikilink]]
- [[wiki-graph-ontology]]
