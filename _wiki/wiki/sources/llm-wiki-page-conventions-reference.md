---
type: source
title: "llm-wiki 스킬 페이지 컨벤션 레퍼런스"
authors: ["llm-wiki plugin maintainers"]
url: null
raw: "_wiki/raw/llm-wiki-page-conventions-reference.md"
ingested: 2026-08-15
tags: [plugin-design]
entities: []
concepts: [page-conventions, page-sizing-discipline]
created: 2026-08-15
updated: 2026-08-15
---

# llm-wiki 스킬 페이지 컨벤션 레퍼런스

`references/page-conventions.md`는 모든 위키 페이지가 따르는 구조적 규칙의 기본값이다(스키마가 개별 위키에 맞게 확장/오버라이드 가능).

## Frontmatter

필수 필드: `type`(source/entity/concept/synthesis/...), `title`, `tags`, `sources`, `created`, `updated`. **frontmatter 리스트 값은 맨 슬러그이며 이중 대괄호 위키링크 문법은 본문에만 쓴다.** `tags`는 flat list이고 작게 유지해야 한다(200개 태그를 가진 위키는 사실상 태그가 없는 것과 같다). `sources`는 entity/concept/synthesis 페이지엔 항상 채워지고 source 페이지 자신엔 생략된다. `updated`가 lint의 staleness 체크와 "무엇이 새로운가" 뷰를 좌우하는 load-bearing 필드다.

타입별 추가 필드: source 페이지는 `authors`, `url`, `raw`, `ingested`; entity 페이지는 `aliases`, `kind`; synthesis 페이지는 `question`, `sources_consulted`.

## 위키링크

이중 대괄호로 슬러그를 감싼 위키링크 문법(슬러그는 디렉터리 접두사 없는 파일명), 파이프 뒤에 표시 텍스트를 붙이면 alias도 가능하다. 모든 페이지는 최소 하나의 인바운드 링크를 가져야 하며 없으면 lint가 고아로 플래그한다.

## 페이지 크기

소프트 캡 400줄/~2,000단어, 하드 캡 800줄. 원자성 휴리스틱: 페이지는 *하나*의 주제만 다룬다. "## Variants"에 다섯 개의 실질적 하위 절이 있다면 그 하위 절들은 대개 각자의 페이지여야 한다. 크기 캡의 근거는 컨텍스트 병목 원칙 — 어떤 페이지 하나를 읽어도 그 비용이 유계(bounded)여야 LLM이 여러 페이지를 자신 있게 연이어 읽을 수 있다.

## 네이밍

소문자, 하이픈, 특수문자 없음. 사람 엔티티는 전체 이름을 슬러그화(`andrej-karpathy.md`), 짧은 이름은 `aliases:`에. 소스 페이지는 소스 제목에서 파생(필요시 연도로 구분). synthesis 페이지는 질문/주제에서 파생하지 날짜에서 파생하지 않는다.

## 본문 구조 기본값

Source 페이지는 핵심 기여 요약 → 핵심 주장/방법론/결론/미해결 질문 절 → "Where this fits"로 마무리. Entity 페이지는 정의 리드 문단 → 관련 속성 절. Concept 페이지는 명확한 정의 리드 → 핵심 정식화/변형/논쟁점/관련 개념 절, 위키링크를 무겁게 쓴다. Synthesis 페이지는 질문으로 시작 → 답변/분석 → 참조한 소스로 마무리.

## Hedging과 voice-neutral 원칙

여러 소스가 corroborate하지 않은 주장은 hedge한다("소스 X는 Y를 주장하지만, 위키 내 다른 소스로부터 아직 corroborate되지 않았다"). 두 소스가 모순되면 양쪽을 다 기록하고 어느 한쪽을 침묵 속에 선택하지 않는다. 위키는 소스 저자의 목소리도 사용자의 목소리도 아닌 LLM 자신의 목소리다 — quote보다 paraphrase를 우선하고, Wikipedia에 가까운 일관되고 중립적인 백과사전식 어조를 유지한다.

## 이 소스가 연결되는 곳

- [[page-conventions]]
- [[page-sizing-discipline]]
