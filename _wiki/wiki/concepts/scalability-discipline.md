---
type: concept
title: "확장성 규율"
tags: [plugin-design]
sources: [llm-wiki-skill-md-reference, llm-wiki-scaling-playbook-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 확장성 규율

LLM Wiki 패턴이 수백~수천 페이지 규모에서도 매 질의당 컨텍스트 비용이 일정하게 유지되도록 하는 8가지 원칙을 아우르는 상위 개념: 원자적 페이지([[page-sizing-discipline]]), 인덱스 우선 탐색, 샤딩된 인덱스, 모든 페이지의 YAML frontmatter, 수술적 편집(`str_replace`), grep 기반 백링크 발견, 청크 단위 소스 읽기, 대규모 위키의 검색 스크립트([[hybrid-retrieval-search]]).

## 왜 이 규율이 "협상 불가"인가

이 스킬의 설계는 거의 전적으로 이 실패 모드를 피하는 데 맞춰져 있다 — LLM Wiki 패턴의 가장 큰 실패 모드는 위키 자체가 컨텍스트 병목이 되는 것이다. naive한 구현은 수백 페이지 근처에서 무너진다: LLM이 질의당 너무 많은 페이지를 읽거나, 관련 페이지를 건너뛰어 hallucinate하기 시작한다. 이 원칙들을 무시하는 것이 바로 이 패턴이 규모에서 붕괴하는 원인이다.

## 실행 절차와의 관계

이 규율 자체는 원칙 선언이고, 실제 임계값·마이그레이션 절차는 [[scaling-playbook-thresholds]]가 담당한다. 300단어짜리 요약("The scalability discipline")이 [[three-layer-three-operation-architecture]] 페이지에서 이미 이 개념을 언급하고 있었으나 독립 페이지가 없어 고아 참조 상태였다 — 이 페이지가 그 참조를 해소한다.

## 관련 페이지

- [[page-sizing-discipline]]
- [[scaling-playbook-thresholds]]
- [[hybrid-retrieval-search]]
- [[three-layer-three-operation-architecture]]
- [[wiki-failure-modes]] — "유지보수 래칫" 실패 모드에 대한 1차 방어선.
