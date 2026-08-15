---
type: concept
title: "Query 워크플로"
tags: [plugin-design, retrieval]
sources: [llm-wiki-query-workflow-reference, llm-wiki-skill-md-reference]
created: 2026-08-15
updated: 2026-08-15
---

# Query 워크플로

인덱스 우선 탐색으로 질문에 답하고, 새로운 종합이면 `wiki/synthesis/`로 파일백하는 6단계 절차. [[three-layer-three-operation-architecture]]의 세 연산 중 하나이며, 상세 절차는 [[llm-wiki-query-workflow-reference]]에 근거한다.

## 절차의 뼈대

인덱스 읽기 → 후보 페이지 식별(부족하면 [[hybrid-retrieval-search]]로 폴백, 관계형 질문이면 [[graph-layer]] 조회) → 후보 페이지 읽기 → 필요시 백링크 탐색(`grep`) → 답변 종합(위키링크 인용) → synthesis 파일백 제안.

## 왜 인덱스 우선인가

30개 페이지를 읽어 답하는 것은 브루트포스 검색으로 퇴행했다는 신호다. 인덱스가 후보를 못 찾으면 인덱스 자체를 고쳐야지 인덱스를 건너뛰면 안 된다는 것이 이 워크플로의 핵심 원칙 — 이는 [[scalability-discipline]]의 "인덱스 우선 탐색" 원칙과 동일한 규율을 질의 쪽에서 반복한다.

## Confabulation 금지

위키가 어떤 주제를 다루지 않으면 그렇다고 말한다. 답을 지어내는 것은 위키를 부패시키는 가장 확실한 방법이다 — 지어낸 답이 파일백되면 그것이 다음 질의의 "근거"가 되어버리기 때문이다. 이는 [[wiki-failure-modes]]의 "침묵의 부패" 실패 모드와 직결된다.

## 파일백 기준

사소한 답변(한 줄 룩업, 기존 페이지 재진술)은 synthesis에 남기지 않는다. 기준은 "3개월 뒤 비슷한 질문을 할 때 이걸 다시 찾고 싶을까"다.

## 관련 페이지

- [[three-layer-three-operation-architecture]]
- [[hybrid-retrieval-search]] — 인덱스가 후보를 못 찾을 때의 폴백.
- [[graph-layer]] — 관계형 질문에 대한 보조 조회.
- [[ingest-workflow]], [[lint-workflow]]
- [[wiki-failure-modes]]
