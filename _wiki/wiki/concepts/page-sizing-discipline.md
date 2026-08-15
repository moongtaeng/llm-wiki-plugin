---
type: concept
title: "페이지 크기 규율 (400/800줄 캡)"
tags: [plugin-design]
sources: [llm-wiki-page-conventions-reference, llm-wiki-ingest-workflow-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 페이지 크기 규율

소프트 캡 400줄(~2,000단어)/하드 캡 800줄과, "페이지는 하나의 주제만 다룬다"는 원자성 휴리스틱. `wiki_lint.py`가 위반을 기계적으로 잡아낸다.

## 근거: 컨텍스트 병목 원칙

캡이 존재하는 이유는 단일 페이지 읽기 비용을 유계(bounded)로 만드는 것이다 — 이래야 LLM이 여러 페이지를 자신 있게 연이어 읽어도 컨텍스트를 소진하지 않는다. 이는 [[scalability-discipline]]이 규정하는 확장성 규율 8원칙 중 하나이자 가장 직접적으로 컨텍스트 예산을 통제하는 원칙이다.

## 원자성 휴리스틱

"## Variants"에 다섯 개의 실질적인 하위 절이 있다면, 그 하위 절들은 대개 독립 페이지여야 한다. "Diffusion Models" 페이지가 "Stable Diffusion"까지 다뤄서는 안 되고, 둘은 교차 참조하는 두 개의 페이지여야 한다.

## 인제스트 시점에 즉시 분할

페이지가 인제스트 도중 크기 캡을 넘으면, 그 즉시 분할한다 — 나중의 린트 패스로 미루지 않는다. 이는 [[ingest-workflow]]가 명시하는 안티패턴("페이지 분할 결정을 미래의 린트 패스로 미루기")과 직결된다.

## 관련 페이지

- [[page-conventions]]
- [[scalability-discipline]]
- [[ingest-workflow]]
