---
type: entity
title: "BAAI/bge-small-en-v1.5"
kind: model
aliases: ["bge-small-en-v1.5"]
tags: [retrieval]
sources: [llm-wiki-retrieval-setup-reference, llm-wiki-wiki-search-script-reference]
created: 2026-08-15
updated: 2026-08-15
---

# BAAI/bge-small-en-v1.5

[[fastembed]]가 로드하는 로컬 임베딩 모델. 384차원 벡터를 생성한다. `llm-wiki` v3.0.0부터 [[hybrid-retrieval-search]]의 기본 semantic 백엔드로 쓰인다.

## 사용 방식

`wiki_search.py`의 `load_local_embedding_backend`가 `fastembed.TextEmbedding("BAAI/bge-small-en-v1.5")`로 로드한다. 모델 아티팩트는 `FASTEMBED_CACHE_PATH` 환경변수 또는 기본값 `~/.cache/llm-wiki/fastembed/`에 캐싱된다. `setup_wiki.py`가 init/upgrade 시점에 이 모델이 없으면 다운로드하고, 벡터 인덱스에 스키마/모델/차원 불일치가 생기면(예: 다른 모델로 교체) 테이블을 드롭 후 재생성한다.

## 관련 페이지

- [[fastembed]]
- [[local-semantic-backend]]
- [[hybrid-retrieval-search]]
