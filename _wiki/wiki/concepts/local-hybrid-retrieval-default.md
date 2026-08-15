---
type: concept
title: "v3.0.0: 로컬 하이브리드 검색이 기본값"
tags: [plugin-design, retrieval]
sources: [plugin-manifest-and-versioning, wiki-slash-commands-reference]
created: 2026-08-15
updated: 2026-08-15
---

# v3.0.0: 로컬 하이브리드 검색이 기본값

v3.0.0부터 검색 기본값이 로컬 [[fastembed]]([[baai-bge-small-en-v1-5]]) + [[sqlite-vec]] + BM25([[reciprocal-rank-fusion-search]] 융합)이며, API 키·아웃바운드 호출이 전혀 없다는 릴리스 결정.

## 이전 버전과의 차이

v3.0.0 이전에는 OpenAI 호환 HTTP 임베딩을 썼고 제공자 동의·자격증명·엔드포인트 설정이 필요했다. v3.0.0이 이를 완전히 로컬 모델 다운로드·인덱스 구축 안내로 교체했다 — CHANGELOG의 "Replace provider consent, credential, endpoint, and cache-marker setup with local model-download and index-build guidance" 항목이 이 전환을 명시한다.

## 이 결정이 요구하는 것

`setup_wiki.py`가 필수 init/upgrade 런타임 게이트가 되어, pinned FastEmbed 0.8.0/sqlite-vec 0.1.9/PyYAML 6.0.3 설치와 로컬 모델 캐싱, 파싱 캐시 구축, 전체 섹션 임베딩을 강제한다. `--no-embed`는 여전히 의존성 없는 BM25 탈출구로 유지된다.

## 관련 페이지

- [[hybrid-retrieval-search]]
- [[retrieval-setup-interview]]
- [[wiki-cache-layer]]
