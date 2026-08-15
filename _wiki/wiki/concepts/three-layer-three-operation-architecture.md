---
type: concept
title: "3계층 / 3연산 아키텍처"
tags: [plugin-design]
sources: [llm-wiki-architecture-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 3계층 / 3연산 아키텍처

`llm-wiki` 플러그인의 핵심 설계를 이루는 구조로, 세 개의 계층(raw 소스, 위키, 스키마 — 선택적으로 그래프까지 네 번째)과 세 개의 연산(ingest, query, lint)으로 구성된다. 이 저장소의 `CLAUDE.md`가 "스킬 설계 전체가 이 구조를 중심으로 조직되어 있다"고 명시할 만큼 플러그인 전체의 조직 원리다.

## 계층

- **raw 소스** (`raw/`) — 불변, 사용자 큐레이션. LLM은 읽기만 한다.
- **위키** (`wiki/{sources,entities,concepts,synthesis}/`) — LLM 소유, 생성된 마크다운. 페이지 타입별 서브디렉터리로 나뉜다.
- **스키마** (`wiki/SCHEMA.md`) — 사용자와 co-evolve하는 설정 계층. 이 위키에 한해 기본 컨벤션을 오버라이드한다. 기존 위키에 진입할 때 항상 먼저 읽는다.
- **그래프** (`wiki/graph/`, 선택) — frontmatter의 타입 있는 `graph:` 메타데이터를 `wiki_graph_extract.py`가 `nodes.jsonl`/`edges.jsonl`/`graph.sqlite`/`graph.graphml`로 컴파일한 것. 마크다운이 항상 canonical이며 그래프는 항상 재생성 가능하다.

## 연산

- **Ingest** — 새 소스를 위키 페이지로 컴파일한다.
- **Query** — 질문에 답하고(인용 포함), 필요하면 답을 synthesis로 파일링한다.
- **Lint** — 구조적·의미적 건강 점검을 한다.

## 확장성 규율과의 관계

이 아키텍처는 그 자체로 목적이 아니라, 위키가 커져도 질의가 너무 많은 페이지를 읽거나 관련 페이지를 놓치지 않도록 하는 확장성 규율의 토대다 — 원자적 페이지 크기 상한, 인덱스 우선 탐색, 모든 페이지의 YAML frontmatter, 수술적 편집(str_replace), 청크 단위 소스 읽기가 모두 이 3계층/3연산 구조 위에서 강제된다.

## 관련 페이지

- [[llm-wiki-architecture-reference]] — 이 개념의 근거가 된 아키텍처 레퍼런스 소스.
- [[dogfooding-llm-wiki]] — 이 아키텍처를 플러그인 자체 개발에 재귀적으로 적용하는 실천.
