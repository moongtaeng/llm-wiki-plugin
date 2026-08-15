---
type: concept
title: "로컬 semantic 백엔드"
tags: [plugin-design, retrieval]
sources: [llm-wiki-wiki-search-script-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 로컬 semantic 백엔드

`wiki_search.py`가 외부 API 호출 없이 [[fastembed]]([[baai-bge-small-en-v1-5]] 모델)와 [[sqlite-vec]]로 기기 내에서 임베딩·벡터검색을 수행하는 백엔드. 로딩이나 동기화가 실패하면 예외를 잡아 BM25 lexical 모드로 조용히 폴백한다.

## 구성

`load_local_embedding_backend`가 `fastembed.TextEmbedding("BAAI/bge-small-en-v1.5")`를 로드하고, 모델 캐시 경로는 `FASTEMBED_CACHE_PATH` 환경변수 또는 `~/.cache/llm-wiki/fastembed/` 기본값을 쓴다. 벡터는 sqlite-vec의 `vec0` 가상 테이블(cosine distance)에 저장된다.

## 안전 폴백이 기본값과 동급으로 설계됨

로컬 백엔드가 기본 경로지만, 실패 시 폴백이 "예외적 상황"이 아니라 정상적인 설계의 일부로 취급된다 — `except Exception`으로 광범위하게 잡아 lexical 모드로 전환하고 stderr 경고만 남긴다. 이는 [[hybrid-retrieval-search]]가 항상 어떤 형태로든 결과를 반환해야 한다는 요구사항을 반영한다.

## 관련 페이지

- [[hybrid-retrieval-search]]
- [[content-hash-incremental-embedding-cache]]
- [[bm25-scoring]]
- [[fastembed]], [[sqlite-vec]], [[baai-bge-small-en-v1-5]]
