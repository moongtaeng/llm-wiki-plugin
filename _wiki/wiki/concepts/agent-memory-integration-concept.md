---
type: concept
title: "에이전트 메모리 통합"
tags: [plugin-design]
sources: [llm-wiki-agent-memory-integration-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 에이전트 메모리 통합

부트스트랩 후 프로젝트의 에이전트 메모리 파일(`CLAUDE.md`/`AGENTS.md`/`GEMINI.md`)에 짧은 스탠자를 추가해, 에이전트가 재요청 없이도 매 세션 위키를 알도록 하는 관행. 근거: [[llm-wiki-agent-memory-integration-reference]].

## 왜 필요한가

이 스탠자가 없으면 에이전트는 위키 대신 훈련 데이터로 답하기 시작하고, [[three-layer-three-operation-architecture]]가 말하는 "지식이 복리로 쌓인다"는 패턴의 핵심 이득이 끊긴다.

## 사용자 동의가 필수

침묵 속에 덧붙이지 않는다 — 스탠자를 제안하고, 사용자가 어느 파일에 어떻게(전체/3줄 축약) 쓸지 결정한다. 위키가 이동/샤딩/폐기될 때만 스탠자를 갱신하며, 이때도 diff를 보여주고 동의를 받는다.

## 이 도그푸드 위키의 실제 사례

`_wiki/memory.md`가 바로 이 canonical 스탠자를 실제로 적용한 결과물이다. 원본 스탠자와 `_wiki/memory.md`의 문구가 실질적으로 일치한다 — 다만 이 프로젝트는 비표준 경로(`_wiki/wiki/`, `_wiki/raw/`)를 쓰므로 스탠자의 경로 참조가 그에 맞게 조정되어 있다. [[dogfooding-llm-wiki]] 참고.

## 관련 페이지

- [[dogfooding-llm-wiki]]
- [[three-layer-three-operation-architecture]]
