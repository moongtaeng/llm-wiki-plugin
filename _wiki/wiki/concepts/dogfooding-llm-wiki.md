---
type: concept
title: "llm-wiki를 자기 자신의 개발에 도그푸딩하기"
tags: [plugin-design]
sources: [project-goal-adopt-llm-wiki, llm-wiki-architecture-reference]
created: 2026-08-15
updated: 2026-08-15
---

# llm-wiki를 자기 자신의 개발에 도그푸딩하기

`llm-wiki` 플러그인의 ingest/query/lint 워크플로를 이용해, 플러그인을 다른 프로젝트에 배포하는 것뿐 아니라 플러그인 자체를 개발하는 과정에서 나오는 지식도 위키로 축적하는 관행이다.

## 동기

[[project-goal-adopt-llm-wiki]]가 이 의도를 직접 밝히고 있다: 위키를 이 프로젝트 자체의 개발 과정 안에서 구축하겠다는 것. 도그푸딩은 플러그인 사용자에게 문제가 도달하기 전에 워크플로의 마찰(모호한 지시, 빠진 컨벤션, 어색한 페이지 분할)을 먼저 드러내주고, 플러그인 유지관리자에게는 스킬 프로즈를 작성·수정할 때 참조할 실제 위키 사례를 제공한다.

[[llm-wiki-architecture-reference]]가 설명하는 3계층(raw/wiki/schema) + 3연산(ingest/query/lint) 구조, 그리고 그 아래 "왜 명시적 스키마 파일이 필요한가"(컨벤션 드리프트 방지)라는 근거는 이 도그푸딩이 성립하는 이유이기도 하다 — `_wiki/wiki/SCHEMA.md`를 사용자와 co-evolve하는 것 자체가 이 저장소의 개발 컨벤션을 지속시키는 장치다.

## 비표준 경로

도그푸드 위키는 플러그인의 기본 경로 `wiki/`/`raw/`가 아니라 `_wiki/wiki/`(raw 소스는 `_wiki/raw/`)에 위치한다. `_wiki/memory.md`에 기록된 이유: 이 저장소 루트는 이미 플러그인이 배포하는 템플릿·문서·예시 구조에서 `wiki/`류 이름을 사용하고 있어서, 같은 이름으로 실제 운영 위키를 두면 충돌이 생긴다. `_wiki/`는 도그푸드 지식 베이스를 플러그인의 제품 표면과 명확히 분리해준다.

## 관련 페이지

- [[project-goal-adopt-llm-wiki]] — 이 목표를 명시적으로 세운 소스 지시문.
- [[llm-wiki-architecture-reference]] — 도그푸딩이 재사용하는 3계층/3연산 아키텍처 근거.
