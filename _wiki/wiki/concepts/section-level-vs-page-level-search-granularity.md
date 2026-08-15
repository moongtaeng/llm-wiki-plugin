---
type: concept
title: "섹션 레벨 vs 페이지 레벨 검색 granularity"
tags: [plugin-design, retrieval]
sources: [llm-wiki-wiki-search-script-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 섹션 레벨 vs 페이지 레벨 검색 granularity

`wiki_search.py`의 기본 검색 단위는 페이지 전체가 아니라 ATX 헤딩(`#`~`######`) 기준으로 쪼갠 섹션이다. `--granularity page`로 전체 페이지 랭킹으로 되돌릴 수 있다.

## 섹션 분할 구현

`split_sections` 함수가 코드펜스(```/~~~) 내부의 `#`은 헤딩으로 취급하지 않도록 `in_fence` 플래그를 추적하고, `heading_stack`으로 계층적 `heading_path`(예: "관련 페이지 > 스크립트 간 흐름")를 유지한다.

## 왜 섹션 레벨이 기본인가

[[page-sizing-discipline]]에 따라 위키 페이지는 400~800줄로 유계지만, 하나의 페이지 안에도 여러 서로 다른 하위 주제가 절로 나뉘어 있을 수 있다. 질의가 페이지의 특정 절에만 관련될 때 페이지 전체를 후보로 반환하는 것보다 정확한 절만 반환하는 것이 [[hybrid-retrieval-search]]의 정밀도를 높인다.

## 관련 페이지

- [[hybrid-retrieval-search]]
- [[page-sizing-discipline]]
