---
type: source
title: "플러그인 매니페스트와 버전 북키핑"
authors: ["llm-wiki plugin maintainers"]
url: null
raw: "_wiki/raw/plugin-manifest-and-versioning.md"
ingested: 2026-08-15
tags: [plugin-design]
entities: [llm-wiki-plugin]
concepts: [version-bookkeeping-three-sync-points]
created: 2026-08-15
updated: 2026-08-15
---

# 플러그인 매니페스트와 버전 북키핑

`.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `CHANGELOG.md`를 하나의 소스로 묶었다.

## 매니페스트 내용

`plugin.json`은 `name: llm-wiki`, `version: 3.0.0`, 저자 `Praney Behl`, MIT 라이선스, `homepage`/`repository`가 `github.com/praneybehl/llm-wiki-plugin`을 가리킨다고 선언한다. `marketplace.json`은 같은 버전(`metadata.version`과 `plugins[0].version` 둘 다 `3.0.0`)을 "productivity" 카테고리로 분류하고 "7 /wiki:* commands"를 포함한다고 명시한다.

## 현재 버전과 릴리스 이력

현재 최신 릴리스는 **3.0.0**(2026-07-20), `[Unreleased]` 섹션은 비어있다. 3.0.0의 핵심 변경: OpenAI 호환 HTTP 임베딩을 로컬 FastEmbed(`BAAI/bge-small-en-v1.5`) + sqlite-vec로 교체, 로컬 하이브리드 섹션 검색을 기본값으로 전환(`--no-embed`는 의존성 없는 BM25 탈출구로 유지), `setup_wiki.py`를 필수 init/upgrade 런타임 게이트로 추가, 그래프 lint/extract에 독립적인 PyYAML PEP 723 메타데이터 부여, v2 제공자 캐시(`embeddings.jsonl`)를 obsolete 처리.

## 이 저장소와 원본 플러그인의 관계

이 저장소의 git 리모트(`origin`)는 `moongtaeng/llm-wiki-plugin`을 가리키는데, 매니페스트의 `homepage`/`repository`는 `praneybehl/llm-wiki-plugin`을 가리킨다 — 즉 이 도그푸드 위키가 속한 저장소는 원저자 Praney Behl의 플러그인을 fork한 것으로 보인다. 이 사실은 매니페스트 파일 자체에서 직접 확인된 것이며, 추가 소스로 corroborate되지 않았다.

## 이 소스가 연결되는 곳

- [[version-bookkeeping-three-sync-points]]
- [[llm-wiki-plugin]]
