---
type: concept
title: "LLM Wiki의 4대 실패 모드"
tags: [plugin-design]
sources: [llm-wiki-skill-md-reference]
created: 2026-08-15
updated: 2026-08-15
---

# LLM Wiki의 4대 실패 모드

Andrej Karpathy의 원 gist에 달린 커뮤니티 코멘트에서 드러난, LLM Wiki 패턴이 잘못되는 방식 4가지. [[llm-wiki-skill-md-reference]]가 이 4가지를 정리해 명시한다.

## 1. 침묵의 부패 (silent corruption)

한 소스의 오독이 권위 있어 보이는 위키 페이지가 되고, 그것이 이후 소스 해석에 영향을 미치며 오류가 눈에 띄지 않게 복리로 쌓인다. 완화책: 모든 위키 주장이 `sources:` frontmatter로 원본 raw 파일을 가리키게 하고, 린트가 근거를 찾을 수 없는 주장을 표면화하게 한다. 불확실하면 hedge한다.

## 2. 위키가 자기 출력을 읽는 드리프트

LLM이 이전 위키 페이지를 근거(ground truth)로 취급하기 시작하고 원본 소스와의 대조를 멈춘다. 완화책: 기존 페이지를 갱신할 때 그 기존 주장의 원본 raw 소스를 다시 읽고 나서 새 소스를 병합한다.

## 3. 유지보수 래칫 (maintenance ratchet)

위키가 커질수록 LLM 출력에 필요한 사람의 감독이 늘어나 사람의 일이 줄지 않고 오히려 늘어나는 경향. 완화책은 [[scalability-discipline]](샤딩된 인덱스, 원자적 페이지, frontmatter, 린트 스크립트)과 강한 린트 cadence다. 린트 리포트가 사용자가 감당 못 할 만큼 길어지면 위키가 자신의 컨벤션을 넘어섰다는 신호이고 스키마 개정이 필요하다.

## 4. 관계형 도메인으로의 스코프 크리프

이 패턴은 텍스트 연구를 축적하는 데 강하지만 조직도, 재무 원장, 구조화 데이터셋처럼 근본적으로 관계형인 데이터에는 약하다. 사용자의 도메인이 근본적으로 관계형이면 그렇다고 말하고 더 나은 도구를 제안해야 한다.

## 관련 페이지

- [[scalability-discipline]]
- [[lint-workflow]]
- [[query-workflow]] — confabulation 금지 원칙이 실패 모드 1과 직결.
- [[ingest-workflow]] — 실패 모드 2에 대한 방어(원본 재확인 없이 병합하지 않기)가 인제스트 안티패턴으로 명시됨.
