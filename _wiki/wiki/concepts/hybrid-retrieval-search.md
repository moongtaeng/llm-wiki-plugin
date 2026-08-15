---
type: concept
title: "하이브리드 검색 (섹션 레벨 BM25 + semantic, RRF 융합)"
tags: [plugin-design, retrieval]
sources: [llm-wiki-retrieval-setup-reference, llm-wiki-scaling-playbook-reference, llm-wiki-query-workflow-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 하이브리드 검색

`wiki_search.py`가 제공하는 기본 검색 경로. 로컬 [[fastembed]]가 [[baai-bge-small-en-v1-5]]를 실행해 만든 semantic 랭크와 BM25 랭크를 [[reciprocal-rank-fusion-search]](RRF)로 융합한다. API 키도, 아웃바운드 네트워크 호출도 없다.

## 로컬-우선(local-first) 설계

기본 경로가 완전히 기기 안에서 동작한다는 점이 핵심 설계 결정이다 — 위키나 질의 텍스트가 기기를 벗어나지 않는다. [[retrieval-setup-interview]]가 셋업 시점에 이 사실을 사용자에게 명시적으로 설명하도록 규정하며, API 키나 제공자 동의를 절대 묻지 않는다.

## 섹션 레벨이 기본

페이지 전체가 아니라 ATX 헤딩 기준 섹션 단위로 랭킹한다([[section-level-vs-page-level-search-granularity]]). `--granularity page`로 전체 페이지 랭킹으로 되돌릴 수 있다.

## 의존성 없는 폴백

`--no-embed`는 PEP 723 의존성 해석을 건너뛰고 순수 stdlib BM25만 쓰는 경로다. 로컬 semantic 백엔드 로딩이나 동기화가 실패해도 자동으로 이 lexical 모드로 조용히(stderr 경고만 남기고) 폴백한다.

## 언제 필요해지는가

[[scaling-playbook-thresholds]]에 따르면 ~300페이지부터 인덱스 직접 탐색만으로는 fuzzy 질의를 놓치기 시작해 이 검색 스크립트가 상용 폴백이 된다.

## 관련 페이지

- [[reciprocal-rank-fusion-search]]
- [[section-level-vs-page-level-search-granularity]]
- [[wiki-cache-layer]]
- [[retrieval-setup-interview]]
- [[scaling-playbook-thresholds]]
- [[fastembed]], [[sqlite-vec]], [[baai-bge-small-en-v1-5]]
