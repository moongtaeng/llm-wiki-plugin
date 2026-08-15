---
type: concept
title: "스키마 업그레이드 마커 감지"
tags: [plugin-design]
sources: [llm-wiki-bundled-scripts-reference]
created: 2026-08-15
updated: 2026-08-15
---

# 스키마 업그레이드 마커 감지

`init_wiki.py --upgrade`가 `SCHEMA_SECTION_MARKERS`로 기존 `SCHEMA.md`의 텍스트에서 버전별 마커 문자열(예: 0.3.0의 그래프 절, 2.0.0의 retrieval 절, 3.0.0의 로컬 semantic 절)의 존재 여부만으로 누락된 섹션을 감지하는 방식.

## 왜 병합은 사용자에게 위임하는가

감지된 갭에 대해 `print_schema_upgrade_guidance`가 안내만 출력하고 **SCHEMA.md 파일 자체는 절대 건드리지 않는다**. 코드 주석 겸 모듈 docstring: "It never overwrites SCHEMA.md — the schema is co-evolved with the user." 이는 [[dogfooding-llm-wiki]]가 말하는 "SCHEMA.md는 사용자와 co-evolve한다"는 원칙을 코드 레벨에서 강제하는 구현이다 — 자동 병합이 사용자가 이미 커스터마이즈한 스키마의 뉘앙스를 지워버릴 위험을 피하는 설계.

## 관련 페이지

- [[dogfooding-llm-wiki]]
- [[wiki-upgrade-idempotent-strategy]]
