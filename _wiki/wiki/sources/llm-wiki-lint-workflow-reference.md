---
type: source
title: "llm-wiki 스킬 lint 워크플로 레퍼런스"
authors: ["llm-wiki plugin maintainers"]
url: null
raw: "_wiki/raw/llm-wiki-lint-workflow-reference.md"
ingested: 2026-08-15
tags: [plugin-design]
entities: []
concepts: [lint-workflow, staleness-heuristic-lint]
created: 2026-08-15
updated: 2026-08-15
---

# llm-wiki 스킬 lint 워크플로 레퍼런스

`references/lint-workflow.md`는 위키 건강 점검을 구조 패스(`wiki_lint.py`가 처리)와 의미 패스(LLM이 직접 처리)로 나눈 6단계 절차를 규정한다. N회 인제스트마다 또는 주간으로, 매 연산마다가 아니라 주기적으로 실행하는 것을 권장한다.

## 6단계

1. **스키마 확인** — 위키별 추가 린트 규칙이 있을 수 있다.
2. **구조 린트 스크립트 실행** — `wiki_lint.py wiki/`. 그래프 레이어가 있으면 `wiki_graph_lint.py wiki/`도 실행해 타입 엣지 문제(알 수 없는 predicate, 근거 누락, 깨진 객체 참조, alias 충돌, 잘못된 confidence/status 값)를 별도로 잡는다. 승인된 수정 후 `wiki_graph_extract.py`로 컴파일 아티팩트를 갱신한다. 리포트 항목: 고아 페이지, 깨진 위키링크, 크기 초과(400줄 소프트/800줄 하드), frontmatter 누락, stale 페이지(가장 최근 관련 인제스트보다 훨씬 오래된 `updated:`), 중복 슬러그.
3. **구조 발견 트리아지** — 각 발견에 대해 수정안을 제안하고 사용자 승인을 받는다(고아는 연결 또는 삭제, 깨진 링크는 재명명/생성/제거, 크기 초과는 분할, frontmatter는 필드 추가, stale은 재확인 후 수술적 갱신, 중복 슬러그는 하나를 canonical로 병합).
4. **의미 패스** — 스크립트가 못 하는 부분. 최근 갱신된 ~10개 페이지에서 오래된 페이지와의 모순, 페이지 내부 모순, 페이지가 없는데 자주 언급되는 엔티티/개념(승격 후보)을 찾는다. 허브 페이지(`--top-linked`)를 읽고 산문이 여전히 일관되는지 확인한다. hedge된 주장(불확실성이 명시된 것)이 이후 인제스트로 corroborate/contradict됐는지 재확인한다.
5. **갭 서베이** — `wiki_lint.py --suggest-pages`로 여러 페이지에서 반복 등장하지만 전용 페이지가 없는 엔티티/개념 후보를 찾는다.
6. **인덱스 갱신 및 로그 기록** — 수정 후 인덱스를 갱신하고, `## [YYYY-MM-DD] lint | <N> structural fixes, <M> semantic fixes, <K> proposed gaps` 한 줄을 로그에 남긴다.

## Cadence 기본값

구조 린트: 5회 인제스트마다. 의미 린트: 주간 또는 20회 인제스트마다. 갭 파인딩: 월간. 이 값들은 SCHEMA.md의 "Lint cadence" 섹션이 그대로 상속한 값이다.

## 안티패턴

침묵의 재작성(사용자 승인 없는 수정), 린트를 클린업 전용으로만 취급(의미 패스는 새로운 연결도 만들어냄), 린트 리포트가 감당 못 할 만큼 커지도록 방치, "다 괜찮아 보인다"는 이유로 린트 생략(침묵의 부패가 가장 감지하기 어려운 실패 모드).

## 이 소스가 연결되는 곳

- [[lint-workflow]]
- [[staleness-heuristic-lint]]
