---
type: source
title: "llm-wiki 7개 /wiki:* 슬래시 커맨드 레퍼런스"
authors: ["llm-wiki plugin maintainers"]
url: null
raw: "_wiki/raw/commands/init.md; _wiki/raw/commands/ingest.md; _wiki/raw/commands/query.md; _wiki/raw/commands/lint.md; _wiki/raw/commands/stats.md; _wiki/raw/commands/upgrade.md; _wiki/raw/commands/graph.md"
ingested: 2026-08-15
tags: [plugin-design]
entities: [llm-wiki-plugin]
concepts: [slash-command-thin-wrapper-pattern, wiki-upgrade-idempotent-strategy, graph-layer-opt-in-triple-script]
created: 2026-08-15
updated: 2026-08-15
---

# llm-wiki 7개 /wiki:* 슬래시 커맨드 레퍼런스

`commands/wiki/*.md` 7개 파일을 하나의 소스로 묶었다 — 각 커맨드가 몇 줄짜리 얇은 요약에 그쳐 개별 페이지로 쪼개면 원자성 원칙에 어긋나고, 커맨드들은 스킬로의 7개 진입점이라는 하나의 표면을 이룬다.

## 공통 패턴

모든 커맨드가 `${CLAUDE_PLUGIN_ROOT}/skills/llm-wiki/scripts/*.py`를 절대경로로 호출하고 `${PWD}/wiki`(프로젝트 로컬 위키 경로)를 인자로 넘긴다. 스크립트 경로(플러그인 설치 위치)와 대상 프로젝트 루트가 명확히 분리되며, init/upgrade는 "절대 플러그인 디렉터리 자체를 대상으로 실행하지 말라"고 명시적으로 경고한다. [[slash-command-thin-wrapper-pattern]] 참고.

## 커맨드별 요약

- **`/wiki:init`** — `retrieval-setup.md`의 그룹 인터뷰(경로/모델캐시/그래프/에이전트 통합) → `init_wiki.py <project-root>` 실행(런타임 설치·검증까지 겸함, `"status": "ready"` 확인 전엔 완료 보고 금지) → `SCHEMA.md` 워크스루 → `agent-memory-integration.md` 제안. 소스 인제스트는 하지 않는다.
- **`/wiki:ingest`** — [[ingest-workflow]]의 8단계(스키마 확인→raw 배치→청크 읽기→논의→서베이→페이지 작성→그래프 갱신→로그). 위키가 없으면 `/wiki:init`을 먼저 권한다.
- **`/wiki:query`** — 인덱스 읽기 → 후보 페이지 읽기 → 필요시 `wiki_search.py`(하이브리드/`--no-embed`) → 관계형 질문이면 `wiki_graph_query.py` → 답변 종합 → `wiki/synthesis/`로 파일링 제안.
- **`/wiki:lint`** — `wiki_lint.py`(구조) + 그래프 있으면 `wiki_graph_lint.py`(타입 엣지) + 의미 패스(최다링크/최신페이지 훑기). 수정은 항상 사용자 승인 후.
- **`/wiki:stats`** — `wiki_stats.py` 실행 후 해석(스케일 임계값 150/300/500페이지, 300줄 인덱스, 400/800줄 페이지 상한, 링크밀도 1.5). 유일하게 인자 없는 커맨드.
- **`/wiki:upgrade`** — [[wiki-upgrade-idempotent-strategy]] 참고. `init_wiki.py --upgrade`(idempotent) → SCHEMA.md 섹션별 승인 병합 → v3.0.0 마이그레이션 노트 안내 → 에이전트 메모리 파일에 그래프 언급 추가 제안.
- **`/wiki:graph`** — `ontology.yaml` 존재 확인(없으면 시딩 제안) → 서브커맨드 디스패치(`extract`/`lint`/`neighbors`/`edges`/`path`/`facts`). [[graph-layer-opt-in-triple-script]] 참고.

## 이 소스가 연결되는 곳

- [[slash-command-thin-wrapper-pattern]]
- [[wiki-upgrade-idempotent-strategy]]
- [[graph-layer-opt-in-triple-script]]
- [[llm-wiki-plugin]]
