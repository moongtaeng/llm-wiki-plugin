---
type: concept
title: "PEP 723 인라인 의존성 선언 컨벤션"
tags: [plugin-design]
sources: [llm-wiki-bundled-scripts-reference, llm-wiki-wiki-search-script-reference]
created: 2026-08-15
updated: 2026-08-15
---

# PEP 723 인라인 의존성 선언 컨벤션

`setup_wiki.py`, `wiki_graph_lint.py`, `wiki_graph_extract.py`, `wiki_search.py`(기본 모드) 상단에 `# /// script` 블록으로 pinned 의존성을 선언하고, `uv run --script`로만 격리 실행하는 컨벤션. `CLAUDE.md`가 이를 "PEP 723 pinned scripts" 그룹으로 명명하고 있다.

## 왜 인라인 pin인가

`requirements.txt`나 프로젝트 전역 `pyproject.toml` 없이도 스크립트 파일 자체가 실행에 필요한 정확한 의존성 버전을 선언한다 — 스크립트를 단독 파일로 복사해도 재현 가능한 실행 환경을 `uv`가 즉석에서 구성해준다. 이는 플러그인이 사용자 프로젝트에 별도 패키지 관리 설정을 요구하지 않게 해준다.

## [[pure-stdlib-fallback-scripts]]와의 상호 배제

이 컨벤션을 쓰는 스크립트와, 완전히 stdlib만 쓰는 스크립트(`wiki_lint.py`, `wiki_stats.py`, `wiki_graph_query.py`, `wiki_search.py --no-embed`)는 명확히 나뉘어 있다 — CLAUDE.md가 "새 스크립트를 추가할 때 어느 모드에 맞는지 따르고, `wiki_lint.py`/`wiki_stats.py`/`wiki_graph_query.py`는 절대 stdlib 이상을 요구하게 만들지 말라"고 명시한다.

## [[uv]]가 실행 전제조건

`init_wiki.py`가 `shutil.which("uv")`로 존재를 확인한 뒤에만 `uv run --script setup_wiki.py`를 서브프로세스로 실행한다 — `uv`가 없으면 이 계열 스크립트는 아예 실행되지 않는다.

## 관련 페이지

- [[pure-stdlib-fallback-scripts]]
- [[uv]]
- [[pyyaml]], [[fastembed]], [[sqlite-vec]]
