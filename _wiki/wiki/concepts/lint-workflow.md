---
type: concept
title: "Lint 워크플로"
tags: [plugin-design]
sources: [llm-wiki-lint-workflow-reference, llm-wiki-skill-md-reference]
created: 2026-08-15
updated: 2026-08-15
---

# Lint 워크플로

구조 패스(스크립트가 처리)와 의미 패스(LLM이 처리)로 나뉜 위키 건강 점검 절차. 매 연산이 아니라 주기적으로(N회 인제스트마다 또는 주간) 실행한다. [[three-layer-three-operation-architecture]]의 세 연산 중 하나이며, 상세 절차는 [[llm-wiki-lint-workflow-reference]]에 근거한다.

## 구조 패스 vs 의미 패스

구조 패스는 `wiki_lint.py`가 기계적으로 잡아낸다: 고아 페이지, 깨진 위키링크, 크기 초과, frontmatter 누락, [[staleness-heuristic-lint]] 위반, 중복 슬러그. 그래프 레이어가 있으면 별도로 `wiki_graph_lint.py`가 타입 엣지 문제를 검증한다. 의미 패스는 스크립트가 할 수 없는 부분 — 최근 갱신 페이지의 모순 탐지, 페이지 없이 자주 언급되는 개념의 승격 후보 발굴, hedge된 주장의 재확인 — 을 LLM이 직접 읽고 판단한다.

## 승인 원칙

린트가 찾아낸 문제는 항상 제안된 수정안으로 제시되고 사용자가 승인한다. 침묵의 재작성은 위키에 대한 신뢰를 깨뜨린다 — 이는 [[dogfooding-llm-wiki]]가 참조하는 "LLM이 위키 계층을 소유하되 사용자 승인 없이 마음대로 바꾸지 않는다"는 원칙과 같은 선상에 있다.

## Cadence

구조 린트는 5회 인제스트마다, 의미 린트는 주간 또는 20회 인제스트마다, 갭 파인딩은 월간이 기본값이다. 이 도그푸드 위키의 `SCHEMA.md` "Lint cadence" 섹션이 정확히 이 기본값을 그대로 채택하고 있다.

## 유지보수 래칫과의 관계

[[wiki-failure-modes]]가 말하는 "유지보수 래칫"(위키가 커질수록 사람의 감독이 늘어나는 경향)에 대한 1차 방어선이 바로 이 lint cadence다. 린트 리포트가 사용자가 감당 못 할 만큼 길어지면, 그건 cadence 문제가 아니라 위키가 자신의 컨벤션을 넘어섰다는 신호이며 스키마 개정이 필요하다.

## 관련 페이지

- [[three-layer-three-operation-architecture]]
- [[staleness-heuristic-lint]]
- [[wiki-failure-modes]]
- [[ingest-workflow]], [[query-workflow]]
- [[graph-layer]] — 그래프가 있을 때의 별도 린트 경로.
