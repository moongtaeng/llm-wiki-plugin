---
type: concept
title: "의존성 없는(pure stdlib) 스크립트 그룹"
tags: [plugin-design]
sources: [llm-wiki-bundled-scripts-reference, llm-wiki-wiki-search-script-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 의존성 없는(pure stdlib) 스크립트 그룹

`wiki_lint.py`, `wiki_stats.py`, `wiki_graph_query.py`(sqlite3만 사용), 그리고 `wiki_search.py --no-embed` 모드는 어떤 서드파티 의존성도 없이 Python stdlib만으로 동작하도록 설계된 그룹이다([[llm-wiki-bundled-scripts-reference]] 참고).

## 왜 이것이 load-bearing 규율인가

이 프로젝트의 `CLAUDE.md`가 이 경로를 명시적으로 "load-bearing"이라 부른다 — 즉 우연히 stdlib만 쓰게 된 게 아니라, 사용자가 `uv`나 인터넷 접속 없이도 최소한의 위키 건강 점검(린트)과 통계, 그래프 조회를 항상 할 수 있어야 한다는 설계 요구사항이다. 새 스크립트를 추가할 때 이 세 스크립트에 새로운 서드파티 의존성을 요구하게 만드는 것은 금지된다.

## [[pep-723-inline-dependency-declaration]]와의 대비

`wiki_search.py`의 기본 모드, `setup_wiki.py`, `wiki_graph_lint.py`, `wiki_graph_extract.py`는 PEP 723으로 pinned 의존성을 선언하고 `uv run --script`가 필요하다 — 이 두 그룹(pure stdlib vs PEP 723 pinned)은 서로 배타적이며, 어느 스크립트가 어느 그룹에 속하는지는 그 스크립트가 요구하는 기능(임베딩·YAML 파싱 여부)에 따라 갈린다.

## 관련 페이지

- [[pep-723-inline-dependency-declaration]]
- [[bm25-scoring]]
- [[staleness-heuristic-lint]] — `wiki_lint.py`(stdlib 그룹)의 기능 중 하나.
