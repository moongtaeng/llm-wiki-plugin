---
type: source
title: "llm-wiki 스킬 에이전트 메모리 통합 레퍼런스"
authors: ["llm-wiki plugin maintainers"]
url: null
raw: "_wiki/raw/llm-wiki-agent-memory-integration-reference.md"
ingested: 2026-08-15
tags: [plugin-design]
entities: []
concepts: [agent-memory-integration-concept, dogfooding-llm-wiki]
created: 2026-08-15
updated: 2026-08-15
---

# llm-wiki 스킬 에이전트 메모리 통합 레퍼런스

`references/agent-memory-integration.md`는 위키 부트스트랩 후 에이전트가 재요청 없이도 매 세션 위키를 알도록 프로젝트의 에이전트 메모리 파일에 짧은 스탠자를 추가하는 절차다. 이걸 하지 않으면 에이전트가 위키 대신 훈련 데이터로 답하기 시작하고 지식 축적이 멈춘다.

## 어느 파일을 쓸지

Claude Code는 `CLAUDE.md`, Codex/Cursor/OpenCode/Pi/OMP/OpenClaw는 `AGENTS.md`, Gemini CLI는 `GEMINI.md`. 여러 에이전트를 쓰거나 불확실하면 `AGENTS.md`를 canonical로 삼고 `CLAUDE.md`를 심볼릭 링크(또는 내용 복제)한다.

## Canonical 스탠자

```markdown
## LLM Wiki

This project maintains an LLM-curated wiki at `wiki/` following Andrej Karpathy's "LLM Wiki" pattern...
```

경로, 인덱스 우선 탐색, ingest 워크플로 요약, 확장성 규율(400/800줄, ~150페이지/300줄 샤딩, frontmatter, 위키링크), 그리고 `SCHEMA.md`가 권위 있는 소스라는 점을 담은 짧은 문단이다. 위키가 비표준 디렉터리에 부트스트랩됐으면 경로 참조를 조정한다 — 스키마 파일과 스탠자는 항상 서로 일치해야 한다.

## 부트스트랩 대화

초기화 시점에 디렉터리 구조와 스키마 워크스루가 끝난 뒤 스탠자를 제안한다. 침묵 속에 덧붙이지 않는다 — 사용자가 메모리 파일을 소유한다. 어느 에이전트를 쓰는지 묻고, 대상 파일이 이미 있으면 추가할지 묻고, 더 짧은 3줄 변형을 원하는지 묻는다. 무엇을 고르든 쓴 뒤 확인한다.

## 스탠자가 바뀌는 시점

포인터일 뿐 플레이북이 아니다 — 새 페이지 타입, 새 태그, 도메인 컨벤션 같은 대부분의 위키 진화는 `SCHEMA.md`에서 일어나야 한다. 메모리 파일은 위키가 비표준 디렉터리로 이동하거나, 인덱스가 샤딩되거나, 위키가 폐기될 때만 바뀐다. 사용자를 대신해 메모리 파일을 편집할 때는 항상 diff를 보여주고 동의를 얻는다 — 침묵의 재작성은 사용자 신뢰를 가장 빨리 깨뜨리는 방법이다.

## 여러 프로젝트, 여러 위키

각 위키는 자신의 프로젝트 안에 산다. 스탠자는 `wiki/`를 상대 경로로 참조하므로 프로젝트마다 독립적인 위키와 독립적인 스탠자를 갖는다. 이 스탠자를 글로벌 메모리 파일(`~/.claude/CLAUDE.md` 등)에 쓰면 안 된다 — 위키가 없는 프로젝트에도 적용되어 혼란스러운 에이전트 행동을 만든다.

## 이 소스와 이 저장소 자신의 관계

이 저장소(`llm-wiki-plugin`)의 `_wiki/memory.md`가 바로 이 canonical 스탠자를 실제로 적용한 사례다 — 문구가 실질적으로 일치한다. [[dogfooding-llm-wiki]] 참고.

## 이 소스가 연결되는 곳

- [[agent-memory-integration-concept]]
- [[dogfooding-llm-wiki]]
