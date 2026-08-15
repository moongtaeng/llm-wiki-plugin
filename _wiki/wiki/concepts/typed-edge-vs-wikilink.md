---
type: concept
title: "타입 엣지 vs 평문 위키링크 판단 기준"
tags: [plugin-design]
sources: [llm-wiki-graph-workflow-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 타입 엣지 vs 평문 위키링크 판단 기준

[[graph-layer]]에서 특정 관계를 frontmatter의 타입 있는 `graph.relationships[]`로 기록할지, 아니면 본문의 평문 이중 대괄호 위키링크(낮은 신뢰도의 `mentions` 엣지가 됨)로만 남길지 판단하는 기준이다.

## 타입 엣지를 쓰는 경우

특정 소스가 관계를 명시적으로 서술하고, 근거 문구를 인용할 수 있고, 그 predicate가 후속 질의("누가 무엇을 창립했나" 같은)에 의미가 있을 때.

## 평문 위키링크를 쓰는 경우

관계가 암묵적이거나 분위기 수준이거나, 단일 소스 인용 하나에 고정할 수 없거나, 어차피 predicate가 `mentions`에 불과할 때.

## 원칙: 불확실하면 위키링크

"불확실하면 위키링크를 쓰고 타입 엣지는 건너뛴다"가 핵심 규칙이다. 린트는 근거 누락을 잡아내지만, under-claiming(위키링크만 쓰고 타입 엣지를 안 쓴 것)을 벌하지 않는다 — 즉 판단이 애매할 때의 기본값은 항상 "덜 주장하기" 쪽이다.

## 이 규칙이 이 도그푸드 위키에서 실제로 적용된 사례

첫 두 인제스트(프로젝트 목표 선언, architecture.md 레퍼런스)에서 `dogfooding-llm-wiki`와 `three-layer-three-operation-architecture` 사이의 관계를 기록할 때, 명시적 근거 인용이 뒷받침하는 강한 관계가 아니라고 판단해 타입 엣지 대신 평문 위키링크만 사용했다 — 이 개념 페이지 자체가 그 판단의 근거를 문서화한다.

## 관련 페이지

- [[graph-layer]]
- [[wiki-graph-ontology]]
- [[implicit-graph-predicates]]
