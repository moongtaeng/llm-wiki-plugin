---
type: concept
title: "슬래시 커맨드 thin wrapper 패턴"
tags: [plugin-design]
sources: [wiki-slash-commands-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 슬래시 커맨드 thin wrapper 패턴

7개 `/wiki:*` 커맨드([[wiki-slash-commands-reference]])는 로직을 담지 않고 스킬 워크플로 문서(`references/*-workflow.md`)를 가리키기만 하는 얇은 래퍼라는 설계 패턴. 실제 절차는 스킬 프로즈([[ingest-workflow]], [[query-workflow]], [[lint-workflow]] 등)에 있고, 커맨드 파일은 트리거 조건(description, argument-hint)과 절차 진입점만 제공한다.

## 근거

`CLAUDE.md`가 "thin wrappers that point Claude at the skill workflow"라고 명시적으로 서술하며, 실제 7개 커맨드 파일 모두 동일한 구조를 갖는다 — 짧은 지시문 + 스킬 참조/절차 목록.

## 왜 이렇게 설계했는가

로직을 커맨드 파일에 중복해서 담으면 스킬 프로즈와 커맨드 파일 두 곳을 항상 동기화해야 한다. thin wrapper 패턴은 단일 진실 원천(스킬 프로즈)을 유지하면서 커맨드는 단지 "언제 이 워크플로를 트리거할지"만 결정하게 한다.

## 관련 페이지

- [[ingest-workflow]], [[query-workflow]], [[lint-workflow]] — 실제 절차가 담긴 곳.
- [[llm-wiki-plugin]]
