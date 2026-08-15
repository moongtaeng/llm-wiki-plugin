---
type: entity
title: "llm-wiki (Claude Code 플러그인)"
kind: product
aliases: ["llm-wiki-plugin"]
tags: [plugin-design]
sources: [plugin-manifest-and-versioning, wiki-slash-commands-reference, llm-wiki-skill-md-reference]
created: 2026-08-15
updated: 2026-08-15
---

# llm-wiki (Claude Code 플러그인)

Andrej Karpathy의 "LLM Wiki" 패턴을 구현하는 Claude Code 플러그인. 이 저장소(`llm-wiki-plugin`) 자체가 이 플러그인의 소스 트리다. 현재 버전 **3.0.0**(2026-07-20 릴리스), 저자 Praney Behl, MIT 라이선스. `llm-wiki` 스킬과 7개 `/wiki:*` 커맨드를 포함한다.

## 구성 표면

이 플러그인은 네 가지 표면 영역으로 구성된다: `skills/llm-wiki/SKILL.md` + `references/*.md`(스킬 로직, [[three-layer-three-operation-architecture]] 참고), `skills/llm-wiki/scripts/*.py`(번들 Python 도구), `commands/wiki/*.md`(7개 슬래시 커맨드, [[slash-command-thin-wrapper-pattern]] 참고), `docs/`(별도 VitePress 문서 사이트).

## 버전과 릴리스

버전은 `plugin.json`/`marketplace.json`/`CHANGELOG.md` 3곳이 동기화되어야 한다([[version-bookkeeping-three-sync-points]]). v3.0.0의 핵심 결정은 [[local-hybrid-retrieval-default]] — 로컬 FastEmbed+sqlite-vec 하이브리드 검색을 기본값으로 전환한 것.

## 이 저장소와의 관계

이 도그푸드 위키(`_wiki/wiki/`)가 바로 이 플러그인 자신의 개발 과정에서 축적되는 지식 베이스다 — [[dogfooding-llm-wiki]] 참고. 매니페스트가 가리키는 리포지토리(`praneybehl/llm-wiki-plugin`)와 이 저장소의 git origin(`moongtaeng/llm-wiki-plugin`)이 다른 것으로 보아, 이 저장소는 원본의 fork로 추정된다(추가 corroboration 없이 매니페스트 파일 자체에서만 확인됨 — hedge).

## 관련 페이지

- [[three-layer-three-operation-architecture]]
- [[dogfooding-llm-wiki]]
- [[slash-command-thin-wrapper-pattern]]
- [[version-bookkeeping-three-sync-points]]
- [[local-hybrid-retrieval-default]]
