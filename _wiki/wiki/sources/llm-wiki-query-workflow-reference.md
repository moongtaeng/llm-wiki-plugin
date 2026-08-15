---
type: source
title: "llm-wiki 스킬 query 워크플로 레퍼런스"
authors: ["llm-wiki plugin maintainers"]
url: null
raw: "_wiki/raw/llm-wiki-query-workflow-reference.md"
ingested: 2026-08-15
tags: [plugin-design, retrieval]
entities: []
concepts: [query-workflow, hybrid-retrieval-search]
created: 2026-08-15
updated: 2026-08-15
---

# llm-wiki 스킬 query 워크플로 레퍼런스

`references/query-workflow.md`는 위키에 질문할 때의 6단계 절차를 규정한다.

## 6단계

1. **스키마 확인** — 질의별 컨벤션이 있을 수 있다(예: "비교 질문엔 항상 표로 답하라").
2. **인덱스 읽기** — `wiki/index.md`(샤드됐으면 최상위 먼저)를 항상 먼저 읽는다.
3. **후보 페이지 식별** — 인덱스에서 후보를 추리되, 30개 페이지를 읽어 답하는 건 브루트포스 검색으로 퇴행한 신호다. 인덱스가 후보를 잘 못 찾으면 `wiki_search.py`로 폴백한다(섹션 레벨 하이브리드, RRF로 로컬 semantic+BM25 융합, `--no-embed`는 의존성 없는 BM25). **2b단계**: 관계형 질문("X와 연결된 게 뭐야", "누가 Y를 제안했나")이면 그래프가 있을 경우 `wiki_graph_query.py neighbors`/`facts`를 인덱스 다음·페이지 읽기 전에 실행한다 — 단, 고위험 주장의 근거로 그래프 행을 그대로 쓰지 않는다.
4. **후보 페이지 읽기** — 페이지 안의 위키링크 중 유망한 것만 선택적으로 따라간다.
5. **백링크 찾기** — "X가 어디서 언급되나"류 질문엔 `grep -rl "\[\[<slug>\]\]" wiki/`(또는 `wiki_search.py --backlinks`)가 페이지 본문 자체보다 유용할 때가 많다.
6. **답변 종합 및 파일백 제안** — 이중 대괄호 위키링크 인용과 함께 답하고, 위키가 몰랐던 연결이나 여러 페이지를 종합한 분석이면 `wiki/synthesis/`에 파일링을 제안한다. 위키에 해당 내용이 없으면 confabulate하지 않고 그렇다고 말한다.

## 특수 질의 유형

"무엇이 빠졌나" 유형은 사실상 주제별 마이크로 린트다. "비교" 유형은 표/대조 프로즈를 만들고 강한 파일백 후보다. "타임라인" 유형은 `log.md`로 연대기를 재구성한다.

## 4개 안티패턴

- 안전을 위해 위키 전체를 읽기(확장 안 됨)
- 어려운 주장에 대해 원본 소스 인용 없이 위키만 인용
- 사소한 답변까지 synthesis에 파일링
- 위키가 침묵할 때 답을 지어내기(confabulation) — "위키가 이걸 다루지 않는다"고 말하는 편이 낫다

## 이 소스가 연결되는 곳

- [[query-workflow]]
- [[hybrid-retrieval-search]]
