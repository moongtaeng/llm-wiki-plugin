---
type: source
title: "llm-wiki 스킬 검색 셋업 인터뷰 레퍼런스"
authors: ["llm-wiki plugin maintainers"]
url: null
raw: "_wiki/raw/llm-wiki-retrieval-setup-reference.md"
ingested: 2026-08-15
tags: [plugin-design, retrieval]
entities: [fastembed, sqlite-vec, pyyaml, uv, baai-bge-small-en-v1-5]
concepts: [retrieval-setup-interview, hybrid-retrieval-search, wiki-cache-layer]
created: 2026-08-15
updated: 2026-08-15
---

# llm-wiki 스킬 검색 셋업 인터뷰 레퍼런스

`references/retrieval-setup.md`는 `/wiki:init`과 `/wiki:upgrade` 전에 실행하는 그룹 인터뷰 절차다. 두 커맨드 모두 완전한 로컬 런타임을 설치·검증하며, lazy하거나 부분적인 셋업 경로는 없다.

## 질문 전 점검

`uv` 사용 가능 여부(필수 전제조건), `FASTEMBED_CACHE_PATH` 설정 여부, `wiki/.wiki-cache/search-index.json`과 `embeddings.sqlite`(및 `semantic_sections` 행) 존재 여부를 먼저 확인한다. 데이터베이스 파일이 있다는 것만으로는 코퍼스가 동기화됐다는 증명이 아니다 — 초기화/업그레이드는 항상 셋업 스크립트를 실행해 증분 동기화를 수행한 뒤에야 준비 완료를 보고한다.

## 그룹으로 한 번에 묻는 질문

1. 경로(위키 디렉터리 기본 `wiki/`, raw 소스 디렉터리 기본 `raw/`)
2. 모델 캐시 위치(`~/.cache/llm-wiki/fastembed/` 기본값 또는 `FASTEMBED_CACHE_PATH` 오버라이드)
3. 그래프 레이어(지금 타입 메타데이터를 구성할지, 생성된 그래프는 유지하되 미사용할지, 보류할지)
4. 에이전트 통합(어느 에이전트 메모리 파일이 위키를 가리킬지, 혹은 건너뛸지)

질문 전에 사실을 설명한다: 초기화·업그레이드마다 pinned FastEmbed/sqlite-vec/PyYAML을 `uv`로 설치한다는 것, 셋업이 모델을 한 번 다운로드하고 파싱 캐시를 구축하고 현재 모든 섹션을 임베딩하며 이후 실행에서는 변경분만 재임베딩하고 삭제된 섹션을 제거한다는 것, 위키 섹션과 질의는 기기를 벗어나지 않으며 API 키·원격 엔드포인트·요청 요금·제공자 보존 정책이 전혀 없다는 것.

## 필수 셋업 검증

`uv run --script skills/llm-wiki/scripts/setup_wiki.py --wiki wiki --cache` 실행 후 다음을 모두 요구한다: JSON이 `"status": "ready"`를 보고, pinned FastEmbed/sqlite-vec/PyYAML이 의존성 목록에 있고, 모델이 `BAAI/bge-small-en-v1.5`(384차원)이고, `search-index.json`/`embeddings.sqlite`가 존재하고, `sections` 수가 `semantic_sections`/`semantic_vectors` 행 수와 일치하고, 두 번째 셋업 실행이 동일한 카운트를 보고하며 임베딩 배치를 새로 출력하지 않는다. 실패하면 정확한 실패 명령과 안전한 예외를 보고하며, 초기화/업그레이드를 완료로 서술하지 않는다.

## v2 제공자 캐시로부터의 업그레이드

`wiki/.wiki-cache/embeddings.jsonl`은 v2의 유물로 obsolete하며, 완전히 파생 가능한 데이터이므로 삭제를 제안하되(기존 파일 삭제는 사용자 승인 필요) 콘텐츠 마이그레이션이나 재전송은 필요 없다. 필수 v3 셋업이 로컬에서 `embeddings.sqlite`를 구축한다.

## 이 소스가 연결되는 곳

- [[retrieval-setup-interview]]
- [[hybrid-retrieval-search]]
- [[wiki-cache-layer]]
- [[fastembed]]
- [[sqlite-vec]]
- [[pyyaml]]
- [[uv]]
- [[baai-bge-small-en-v1-5]]
