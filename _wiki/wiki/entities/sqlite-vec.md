---
type: entity
title: "sqlite-vec"
kind: library
aliases: ["sqlite-vec"]
tags: [retrieval]
sources: [llm-wiki-retrieval-setup-reference, llm-wiki-wiki-search-script-reference, plugin-manifest-and-versioning]
created: 2026-08-15
updated: 2026-08-15
---

# sqlite-vec

벡터 유사도 검색을 위한 SQLite 확장 라이브러리. `llm-wiki`가 임베딩 벡터를 저장·조회하는 데 쓴다.

## 사용 방식

`wiki_search.py`가 `vec0` 가상 테이블(`semantic_vectors`, cosine distance 메트릭)을 열어 섹션별 벡터를 저장한다. `wiki/.wiki-cache/embeddings.sqlite`([[wiki-cache-layer]])가 이 벡터들이 실제로 저장되는 파일이다. 스키마 버전(`VECTOR_INDEX_SCHEMA = "2"`), 모델, 차원 중 하나라도 바뀌면 테이블을 드롭하고 재생성한다.

## 버전

`sqlite-vec==0.1.9`로 pin되어 PEP 723 인라인 블록에 선언된다.

## 관련 페이지

- [[wiki-cache-layer]]
- [[local-semantic-backend]]
- [[content-hash-incremental-embedding-cache]]
