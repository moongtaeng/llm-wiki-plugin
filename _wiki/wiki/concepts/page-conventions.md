---
type: concept
title: "페이지 컨벤션"
tags: [plugin-design]
sources: [llm-wiki-page-conventions-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 페이지 컨벤션

모든 위키 페이지가 따르는 구조적 규칙의 기본값 — frontmatter 필수 필드, 위키링크 문법, 네이밍, 타입별 본문 구조, hedging/voice-neutral 원칙. 개별 위키의 `SCHEMA.md`가 확장·오버라이드할 수 있다. 근거: [[llm-wiki-page-conventions-reference]].

## Frontmatter의 역할

`type`, `title`, `tags`, `sources`, `created`, `updated`가 모든 페이지의 최소 필드다. frontmatter 리스트 값은 맨 슬러그이고 이중 대괄호 위키링크는 본문 전용이다 — 이 구분이 `wiki_search.py` 같은 스크립트가 본문을 읽지 않고도 frontmatter만으로 필터링할 수 있게 해주는 근거다([[three-layer-three-operation-architecture]]가 말하는 "YAML frontmatter on every page" 확장성 원칙과 동일한 근거).

## Hedging과 voice-neutral 원칙

corroborate되지 않은 주장은 hedge하고, 모순되는 소스는 양쪽 다 기록한다. 위키는 소스 저자의 목소리도 사용자의 목소리도 아닌 LLM 고유의 중립적·백과사전식 목소리를 유지한다.

## 관련 페이지

- [[page-sizing-discipline]] — 이 컨벤션의 하위 절이지만 [[scaling-playbook-thresholds]]·[[three-layer-three-operation-architecture]]와도 강하게 연결되어 독립 페이지로 분리.
- [[three-layer-three-operation-architecture]]
