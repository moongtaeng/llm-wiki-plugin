---
type: concept
title: "스케일링 임계값과 마이그레이션 절차"
tags: [plugin-design]
sources: [llm-wiki-scaling-playbook-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 스케일링 임계값과 마이그레이션 절차

[[scalability-discipline]]의 원칙들을 실행 가능한 절차로 구체화한, 페이지 수 기준 5단계 임계값과 각 단계의 마이그레이션 작업. 근거: [[llm-wiki-scaling-playbook-reference]].

## 5단계

- **~50페이지 이하**: 플랫 구조로 충분. 카테고리 서브디렉터리는 처음부터 써도 공짜.
- **~150페이지 또는 index.md 300줄 초과**: 인덱스를 `wiki/indexes/<type>.md`로 샤딩.
- **~300페이지**: [[hybrid-retrieval-search]](`wiki_search.py`)를 상용 폴백으로 채택.
- **~500페이지**: 구조 린트 cadence를 주간/N회 인제스트마다로 전환, 검색 스크립트에 영속 파싱 캐시(`--cache`) 도입 고려.
- **~1,000+페이지**: LLM Wiki 패턴 자체가 여전히 맞는 도구인지 재검토 — 질의가 압도적으로 관계형이면 그래프 DB가 낫다.

## 샤딩을 미리 하지 않는 이유

샤딩은 되돌리기 번거로우므로 실제 임계값 전에 미리 하지 않는다. 80페이지짜리 위키에 샤딩된 인덱스를 두면, 볼륨이 정당화하지 못하는 탐색 단계만 추가되어 플랫 인덱스보다 사용성이 떨어진다.

## 이 도그푸드 위키의 현재 위치

이 위키(`_wiki/wiki/`)는 현재 페이지 수가 임계값 1(~50페이지)에 한참 못 미치는 규모이며, `_wiki/wiki/SCHEMA.md`의 "Index structure" 섹션이 이미 "150페이지 또는 300줄 초과 시 샤딩"이라는 Threshold 2 규칙을 그대로 인용해 명문화해 두었다.

## 관련 페이지

- [[scalability-discipline]]
- [[hybrid-retrieval-search]]
- [[custom-page-types]]
