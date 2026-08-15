---
type: concept
title: "Content-hash 기반 증분 임베딩 캐싱"
tags: [plugin-design, retrieval]
sources: [llm-wiki-wiki-search-script-reference]
created: 2026-08-15
updated: 2026-08-15
---

# Content-hash 기반 증분 임베딩 캐싱

`wiki_search.py`의 `sync_vector_index`가 섹션별 SHA256(모델명 + 검색 가능 텍스트를 해시)으로 변경분만 재임베딩하고, 삭제된 섹션은 벡터 인덱스에서 함께 제거하는 캐싱 전략.

## 왜 모델명을 해시에 포함하는가

같은 텍스트라도 임베딩 모델이 바뀌면 벡터가 달라진다. 콘텐츠 해시에 모델명을 포함시킴으로써, 모델을 교체하면(또는 `VECTOR_INDEX_SCHEMA` 버전이 바뀌면) 캐시가 자동으로 무효화되어 stale한 벡터가 남지 않는다 — 실제로 `wiki_search.py`는 스키마/모델/차원이 바뀌면 `semantic_vectors` 테이블 자체를 드롭 후 재생성한다.

## [[wiki-cache-layer]]와의 관계

이 전략이 실제로 저장되는 곳이 `wiki/.wiki-cache/embeddings.sqlite`([[wiki-cache-layer]])다. 페이지 단위가 아니라 섹션 단위 해시이므로, 큰 페이지의 한 절만 바뀌어도 그 절만 재임베딩되고 나머지 절의 벡터는 재사용된다.

## 관련 페이지

- [[wiki-cache-layer]]
- [[local-semantic-backend]]
- [[hybrid-retrieval-search]]
