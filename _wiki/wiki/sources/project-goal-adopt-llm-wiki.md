---
type: source
title: "프로젝트 목표: 이 프로젝트 자체 개발에 llm-wiki 도입"
authors: ["windlesszone"]
url: null
raw: "_wiki/raw/2026-08-15-project-goal-adopt-llm-wiki.md"
ingested: 2026-08-15
tags: [plugin-design]
entities: []
concepts: [dogfooding-llm-wiki]
created: 2026-08-15
updated: 2026-08-15
---

# 프로젝트 목표: 이 프로젝트 자체 개발에 llm-wiki 도입

프로젝트 소유자가 남긴 짧은 지시문이다. "이 프로젝트(`llm-wiki-plugin` 저장소 자체) 개발을 위해 llm-wiki 를 사용하여 위키를 구성하고자한다"는 요지로, `llm-wiki` 패턴을 이용해 이 프로젝트를 개발하는 과정에서 나오는 지식을 위키로 축적·관리하겠다는 방침이다.

## 맥락

이 저장소는 `llm-wiki` Claude Code 플러그인의 소스 트리 자체다. 플러그인은 다른 프로젝트에서 Andrej Karpathy의 "LLM Wiki" 패턴을 구현할 수 있도록 스킬, 스크립트, 커맨드를 제공한다. 이번 지시는 그 패턴을 재귀적으로 이 플러그인 자체에도 적용하겠다는 것이다 — 즉 플러그인 자신의 개발 지식(설계 결정, 아키텍처 근거, 미해결 질문)을 플러그인 자체 도구로 유지되는 위키 안에 쌓아간다.

이 작업은 이미 부분적으로 준비되어 있다. `_wiki/wiki/`에는 `SCHEMA.md`, `index.md`, `log.md`, 그리고 선택적 `graph/` 레이어가 이미 존재한다. `_wiki/memory.md`에는 위키가 플러그인의 기본 경로인 `wiki/`/`raw/`가 아니라 비표준 경로인 `_wiki/`에 위치하는 이유가 기록되어 있다 — 플러그인이 예시용으로 배포하는 템플릿·문서가 같은 디렉터리 이름(`wiki/`, `raw/`)을 쓰기 때문에 충돌을 피하기 위해서다.

## 이 소스가 연결되는 곳

- [[dogfooding-llm-wiki]]
