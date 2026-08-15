---
type: entity
title: "PyYAML"
kind: library
aliases: ["pyyaml", "yaml"]
tags: [plugin-design]
sources: [llm-wiki-retrieval-setup-reference, llm-wiki-bundled-scripts-reference, plugin-manifest-and-versioning]
created: 2026-08-15
updated: 2026-08-15
---

# PyYAML

YAML 파싱 파이썬 라이브러리. `llm-wiki`에서는 `wiki_graph_extract.py`/`wiki_graph_lint.py`/`setup_wiki.py`가 frontmatter와 `ontology.yaml` 파싱에 사용한다(`pyyaml==6.0.3` pin).

## 의도적으로 사용하지 않는 곳

`wiki_search.py`와 `wiki_lint.py`는 의도적으로 PyYAML에 의존하지 않고 정규식 기반의 자체 경량 frontmatter 파서를 쓴다 — [[pure-stdlib-fallback-scripts]] 규율(이 두 스크립트, 그리고 `--no-embed` 모드가 stdlib만으로 동작해야 한다는 요구) 때문이다. 즉 같은 "frontmatter를 읽는다"는 기능이 스크립트에 따라 PyYAML을 쓰기도 하고 자체 파서를 쓰기도 하는데, 이 구분은 우연이 아니라 해당 스크립트가 stdlib-only 그룹에 속하는지 여부로 결정된다.

## 관련 페이지

- [[pure-stdlib-fallback-scripts]]
- [[pep-723-inline-dependency-declaration]]
- [[wiki-graph-ontology]]
