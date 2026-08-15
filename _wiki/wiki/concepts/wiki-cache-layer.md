---
type: concept
title: "위키 캐시 레이어 (.wiki-cache/)"
tags: [plugin-design, retrieval]
sources: [llm-wiki-retrieval-setup-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 위키 캐시 레이어

`wiki/.wiki-cache/`에 위치하는 두 재생성 가능 아티팩트: `search-index.json`(파싱 캐시)과 `embeddings.sqlite`(섹션 메타데이터 + sqlite-vec 벡터). [[hybrid-retrieval-search]]가 매 실행마다 처음부터 다시 파싱·임베딩하지 않도록 지원한다.

## 증분 동기화

파일별 SHA256으로 변경을 감지하는 파싱 캐시와, 섹션별 content-hash(모델명+검색가능 텍스트를 해시)로 변경을 감지하는 벡터 캐시가 각각 독립적으로 동작한다. 변경/신규 섹션만 재임베딩되고, 삭제된 섹션은 벡터·메타데이터 양쪽에서 제거된다.

## 안전하게 삭제 가능

이 디렉터리 전체는 파생 데이터이며 언제든 삭제해도 안전하다 — 다음 실행이 처음부터 재구축한다. `_wiki/wiki/SCHEMA.md`의 "Retrieval" 섹션도 이 점을 명시하고 있다("Safe to delete; never edit by hand; gitignored").

## v2에서의 유물

`embeddings.jsonl`(v2 제공자 캐시)은 v3부터 obsolete하며 완전히 파생 가능하므로, 업그레이드 시 삭제를 제안하되 사용자 승인을 받는다 — 콘텐츠 마이그레이션은 필요 없다.

## 관련 페이지

- [[hybrid-retrieval-search]]
- [[content-hash-incremental-embedding-cache]]
- [[retrieval-setup-interview]]
