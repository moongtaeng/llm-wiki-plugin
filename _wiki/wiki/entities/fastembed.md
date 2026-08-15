---
type: entity
title: "FastEmbed"
kind: library
aliases: ["fastembed"]
tags: [retrieval]
sources: [llm-wiki-retrieval-setup-reference, llm-wiki-wiki-search-script-reference, plugin-manifest-and-versioning]
created: 2026-08-15
updated: 2026-08-15
---

# FastEmbed

로컬 임베딩 추론 파이썬 라이브러리. `llm-wiki`의 [[hybrid-retrieval-search]] 기본 경로에서 [[baai-bge-small-en-v1-5]] 모델을 실행하는 데 쓰인다.

## 버전과 의존성 선언

`fastembed==0.8.0`으로 pin되어 `wiki_search.py`, `setup_wiki.py`의 PEP 723 인라인 블록에 선언된다([[pep-723-inline-dependency-declaration]]). `uv run --script`로만 실행되는 격리 환경에서 이 정확한 버전이 설치된다.

## 로딩 실패 시 처리

[[local-semantic-backend]]가 이 라이브러리 로딩이나 모델 다운로드에 실패하면 예외를 잡아 BM25 lexical 모드로 조용히 폴백한다 — FastEmbed 자체가 필수 하드 의존성이 아니라 "있으면 쓰는" 선택적 강화 계층으로 설계되어 있음을 보여준다.

## 관련 페이지

- [[baai-bge-small-en-v1-5]]
- [[local-semantic-backend]]
- [[pep-723-inline-dependency-declaration]]
