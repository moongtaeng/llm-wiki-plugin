---
type: concept
title: "Reciprocal Rank Fusion (RRF)"
tags: [plugin-design, retrieval]
sources: [llm-wiki-wiki-search-script-reference]
created: 2026-08-15
updated: 2026-08-15
---

# Reciprocal Rank Fusion (RRF)

`wiki_search.py`([[llm-wiki-wiki-search-script-reference]])가 [[bm25-scoring]] 랭크와 [[local-semantic-backend]]의 semantic 랭크를 하나의 순위로 융합하는 기법. 공식은 `score += 1.0 / (60 + rank)`(k=60)를 두 랭크 각각에 적용해 합산하는 전형적인 RRF다.

## 왜 점수가 아니라 순위를 융합하는가

BM25 점수와 코사인 유사도 점수는 스케일이 다르다 — 직접 가중합하면 한쪽이 다른 쪽을 압도하기 쉽다. RRF는 원점수 대신 각 랭킹에서의 순위(rank)만 사용하므로 스케일 문제 없이 서로 다른 두 랭킹 방법을 공정하게 섞을 수 있다.

## 후보 풀의 범위

BM25 후보는 top 50까지만 후보 풀에 편입된다 — 전체 코퍼스가 아니라 유망한 후보군 안에서만 RRF가 계산된다.

## 위치

[[hybrid-retrieval-search]]의 핵심 융합 단계이며, `wiki_search.py`가 로컬 semantic 백엔드 로딩에 실패하면 이 융합 자체가 건너뛰어지고 BM25 단독 랭킹(lexical 모드)으로 폴백한다.

## 관련 페이지

- [[hybrid-retrieval-search]]
- [[bm25-scoring]]
- [[local-semantic-backend]]
