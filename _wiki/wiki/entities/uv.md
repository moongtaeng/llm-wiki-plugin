---
type: entity
title: "uv"
kind: tool
aliases: ["uv"]
tags: [plugin-design]
sources: [llm-wiki-retrieval-setup-reference, llm-wiki-bundled-scripts-reference]
created: 2026-08-15
updated: 2026-08-15
---

# uv

Astral의 Python 패키지/스크립트 러너. [[pep-723-inline-dependency-declaration]] 컨벤션으로 pin된 의존성을 선언한 스크립트를 격리된 환경에서 실행하는 필수 전제조건이다.

## 사용 방식

`init_wiki.py`가 `shutil.which("uv")`로 존재를 확인한 뒤에만 `uv run --script setup_wiki.py`를 서브프로세스로 실행한다. `retrieval-setup.md`는 `uv` 사용 가능 여부를 셋업 인터뷰 전 사전 점검 항목 1번으로 명시한다 — "required prerequisite".

## 없을 때의 영향

`uv`가 없으면 PEP 723 pinned 스크립트 계열(`setup_wiki.py`, `wiki_search.py`의 기본 semantic 모드, `wiki_graph_lint.py`, `wiki_graph_extract.py`) 전체가 실행되지 않는다. [[pure-stdlib-fallback-scripts]] 그룹(`wiki_lint.py`, `wiki_stats.py`, `wiki_graph_query.py`, `wiki_search.py --no-embed`)만 `uv` 없이도 동작한다.

## 관련 페이지

- [[pep-723-inline-dependency-declaration]]
- [[pure-stdlib-fallback-scripts]]
- [[retrieval-setup-interview]]
