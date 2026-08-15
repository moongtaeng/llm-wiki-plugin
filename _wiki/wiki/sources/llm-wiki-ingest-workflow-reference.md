---
type: source
title: "llm-wiki 스킬 ingest 워크플로 레퍼런스"
authors: ["llm-wiki plugin maintainers"]
url: null
raw: "_wiki/raw/llm-wiki-ingest-workflow-reference.md"
ingested: 2026-08-15
tags: [plugin-design]
entities: []
concepts: [ingest-workflow, page-sizing-discipline]
created: 2026-08-15
updated: 2026-08-15
---

# llm-wiki 스킬 ingest 워크플로 레퍼런스

`references/ingest-workflow.md`는 새 소스가 도착했을 때의 10단계 절차를 상세히 규정한다.

## 10단계

1. **스키마 확인** — `wiki/SCHEMA.md`를 항상 먼저 읽는다. 스키마가 워크플로 자체를 오버라이드할 수 있다.
2. **raw 소스 배치** — 슬러그화된 파일명(소문자, 하이픈)으로 `raw/`에 배치. 이 슬러그가 이후 `wiki/sources/`의 소스 요약 페이지 슬러그가 된다.
3. **소스 읽기** — 5,000단어/25,000토큰 미만은 한 번에, 그 이상(논문 30페이지 이상, 책 챕터, 장시간 transcript)은 청크 읽기: 목차/섹션 헤더로 먼저 지도를 그리고 섹션별로 순차 읽으며 작업 메모리에 요약한다. 컨텍스트 윈도우의 25% 이상을 한 번에 쓰지 않는다.
4. **사용자와 논의** — 3~4문장으로 핵심, 놀라웠던 점, 기존 위키와의 연결, 플래그할 것을 논의한다. 배치 인제스트 모드에서는 논의를 생략하되 더 보수적으로 편집한다.
5. **영향 조사** — `wiki/index.md`(또는 관련 샤드)를 읽어 이 소스가 건드리는 기존 페이지를 식별하고, 각 후보 페이지를 실제로 읽어(그렙이 아니라) 확인한다. 이 서베이가 중복 페이지 생성을 방지한다.
6. **소스 요약 페이지 작성** — `wiki/sources/<source-slug>.md`. 전체 소스를 paraphrase하지 않고, 향후 질의가 원본을 다시 읽지 않고도 필요로 할 핵심만 담는다. "Where this fits" 절로 마무리해 관련 entity/concept 페이지에 위키링크한다.
7. **기존 페이지 갱신** — `str_replace`로 수술적 편집. 새 소스가 기존 주장을 뒷받침하면 인용 추가, 모순되면 "## Contradictions" 절을 만들어 양쪽 소스를 모두 기록, 새 차원을 더하면 새 하위 절 추가.
8. **신규 페이지 생성** — 새 엔티티/개념이 첫급 주제로 다뤄지면 페이지를 만들고, 최소 하나의 기존 페이지가 인바운드 링크를 갖도록 한다. 아무도 링크하지 않는 신규 페이지는 인제스트의 버그다.
9. **인덱스 갱신** — `wiki/index.md`(또는 샤드)에 신규 페이지 한 줄 추가. 300줄 초과 시 샤딩 신호.
10. **로그 기록** — `wiki/log.md`에 `## [YYYY-MM-DD] ingest | <source-title>` 한 줄. 그래프 레이어를 갱신했다면 `graph: +N nodes, +M typed edges` 서브라인 추가.

## 5개 안티패턴

- 큰 소스를 한 번에 전체 로드
- 수술적 편집 대신 페이지 전체 재작성
- 인바운드 링크 없는 페이지 생성
- 배치 인제스트 중 놀라운 발견을 침묵 처리
- 위키의 기존 paraphrase를 근거처럼 취급하며 원본 재확인 없이 병합

## 이 소스가 연결되는 곳

- [[ingest-workflow]]
- [[page-sizing-discipline]]
