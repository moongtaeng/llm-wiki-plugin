---
type: concept
title: "Ingest 워크플로"
tags: [plugin-design]
sources: [llm-wiki-ingest-workflow-reference, llm-wiki-skill-md-reference]
created: 2026-08-15
updated: 2026-08-15
---

# Ingest 워크플로

새 소스를 `raw/`에 배치하고 읽어 `wiki/` 페이지로 컴파일하는 10단계 절차. [[three-layer-three-operation-architecture]]가 정의하는 세 연산(ingest/query/lint) 중 하나이며, 상세 절차는 [[llm-wiki-ingest-workflow-reference]]에 근거한다.

## 절차의 뼈대

스키마 확인 → raw 배치(슬러그화된 파일명) → 소스 읽기(길면 청크 단위) → 사용자와 논의 → 위키 영향 조사(인덱스 읽고 후보 페이지 실제로 확인) → source 요약 페이지 작성 → 기존 페이지 수술적 갱신(`str_replace`) → 신규 entity/concept 페이지 생성(인바운드 링크 필수) → 인덱스 갱신 → 로그 기록. [[graph-layer]]가 있으면 그래프 갱신 단계가 7단계 뒤에 추가로 들어간다.

## 핵심 규율: 논의를 건너뛰지 않는다

논의 단계를 생략하고 싶은 유혹이 강하지만, 사용자의 반응이 위키에서 무엇을 강조하고 무엇을 뺄지 알려준다. Ingest는 일괄 임포트가 아니라 협업적 읽기다. 배치 인제스트("이 20개 논문을 그냥 처리해줘") 모드에서는 논의를 생략하되 더 보수적인 편집으로 전환한다.

## 왜 서베이(조사) 단계가 있는가

영향 조사 없이 페이지를 쓰면 이미 있는 주제를 살짝 다른 이름으로 중복 생성하게 된다. 인덱스 요약만 보고 판단하지 않고 후보 페이지를 실제로 읽어 확인하는 것이 이 서베이의 핵심이다.

## 관련 페이지

- [[three-layer-three-operation-architecture]] — 이 워크플로가 속한 상위 아키텍처.
- [[page-sizing-discipline]] — 인제스트 중 페이지가 상한을 넘으면 그 자리에서 분할해야 한다는 규율.
- [[query-workflow]], [[lint-workflow]] — 나머지 두 연산.
- [[graph-layer]] — 그래프가 있을 때 인제스트에 추가되는 단계.
