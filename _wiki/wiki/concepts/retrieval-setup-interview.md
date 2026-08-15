---
type: concept
title: "검색 셋업 인터뷰"
tags: [plugin-design, retrieval]
sources: [llm-wiki-retrieval-setup-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 검색 셋업 인터뷰

`/wiki:init`과 `/wiki:upgrade` 전에 실행하는 그룹 인터뷰. 경로, 모델 캐시 위치, 그래프 레이어 사용 여부, 에이전트 통합 대상 파일 4가지를 한 번에 묻는다. 근거: [[llm-wiki-retrieval-setup-reference]].

## 사전 점검이 먼저

질문 전에 `uv` 사용 가능 여부, `FASTEMBED_CACHE_PATH` 설정, 캐시 파일 존재 여부를 확인한다. 캐시 파일이 존재한다는 사실만으로는 코퍼스가 실제로 동기화됐다는 증명이 되지 않는다는 점이 강조된다 — 초기화/업그레이드는 항상 `setup_wiki.py`를 실행해 증분 동기화를 수행한 뒤에야 "준비 완료"를 보고한다.

## Fail-closed 검증

`"status": "ready"`, pinned 의존성 목록, 모델·차원 일치, 캐시 파일 존재, 섹션 수와 벡터 행 수 일치, 두 번째 실행이 동일 카운트를 재현하는 것 — 이 6개 조건을 모두 만족해야만 셋업 완료로 보고한다. 하나라도 실패하면 실패한 정확한 명령과 예외를 보고하며 완료로 서술하지 않는다.

## 관련 페이지

- [[hybrid-retrieval-search]]
- [[wiki-cache-layer]]
