---
type: concept
title: "BM25 스코어링 (자체 구현)"
tags: [plugin-design, retrieval]
sources: [llm-wiki-wiki-search-script-reference]
created: 2026-08-15
updated: 2026-08-15
---

# BM25 스코어링

`wiki_search.py`가 외부 라이브러리 없이 직접 구현한 lexical 랭킹 함수(`build_bm25`/`bm25_score`). 표준 파라미터 k1=1.5, b=0.75를 쓴다.

## 왜 직접 구현했는가

`wiki_lint.py`/`wiki_stats.py`와 마찬가지로 [[pure-stdlib-fallback-scripts]] 규율을 지키기 위해서다 — `--no-embed` 모드가 어떤 서드파티 의존성도 없이 동작해야 하므로, 검색의 lexical 절반은 반드시 stdlib만으로 구현되어야 한다.

## 하이브리드에서의 역할

[[reciprocal-rank-fusion-search]]에서 semantic 랭크와 융합되는 두 입력 중 하나이며, semantic 백엔드가 실패했을 때는 유일한 랭킹 신호가 되어 [[hybrid-retrieval-search]] 전체의 안전망 역할을 한다.

## 관련 페이지

- [[reciprocal-rank-fusion-search]]
- [[pure-stdlib-fallback-scripts]]
- [[hybrid-retrieval-search]]
