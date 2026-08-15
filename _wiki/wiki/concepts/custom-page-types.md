---
type: concept
title: "커스텀 페이지 타입 도입 기준"
tags: [plugin-design]
sources: [llm-wiki-scaling-playbook-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 커스텀 페이지 타입 도입 기준

기본 4타입(source/entity/concept/synthesis) 외에 위키가 도입할 수 있는 커스텀 페이지 타입의 도입/보류 기준.

## 도입 기준

사용자가 어떤 기본 타입에도 깔끔히 맞지 않는 명확한 카테고리를 가지고 있고, 그것이 별도 서브디렉터리로서 쿼리 가능성·별도 린트 규칙·별도 템플릿의 이득을 볼 때만 도입한다. 정당화 예시: 팀의 아키텍처 결정 기록용 `decision`, 연구소의 시행착오 기록용 `experiment`, 팬 위키의 캐릭터 프로필용 `character`, 팀 회의록용 `meeting`.

## 일회성엔 타입 대신 태그

타입 추가는 인덱스, 린트 스크립트, 향후 모든 인제스트에 영향을 미치는 스키마 변경이다. 일회성 카테고리에는 타입 대신 태그를 쓴다.

## 이 도그푸드 위키에서의 적용

`_wiki/wiki/SCHEMA.md`는 현재 4개 기본 타입만 선언하고 있으며 아직 커스텀 타입을 추가하지 않은 상태다. 향후 이 저장소의 개발 과정에서 예컨대 "설계 결정" 성격의 페이지가 반복적으로 필요해지면, 이 기준에 따라 `decision` 타입 도입 여부를 판단할 수 있다.

## 관련 페이지

- [[scaling-playbook-thresholds]]
- [[page-conventions]]
