---
type: concept
title: "wiki:upgrade의 idempotent 업그레이드 전략"
tags: [plugin-design]
sources: [wiki-slash-commands-reference]
created: 2026-08-15
updated: 2026-08-15
---

# wiki:upgrade의 idempotent 업그레이드 전략

`/wiki:upgrade`가 기존 위키를 현재 플러그인 버전으로 갱신할 때, `init_wiki.py --upgrade`로 누락 파일만 추가하고 기존 콘텐츠는 절대 건드리지 않으며, `SCHEMA.md` 병합은 섹션 단위로 사용자 승인을 받는 전략.

## 런타임 준비 상태 확인 (fail-closed)

런타임 준비 상태(`"status": "ready"`)를 명시적으로 확인하기 전엔 완료로 보고하지 않는다 — 이는 [[schema-upgrade-marker-detection]]이 코드 레벨에서 구현하는 "SCHEMA.md를 절대 덮어쓰지 않는다"는 원칙과, [[retrieval-setup-interview]]의 fail-closed 검증 원칙 둘 다를 커맨드 레벨에서 재확인하는 것이다.

## SCHEMA.md 섹션별 승인 병합

업그레이드 스크립트가 감지한 각 누락 섹션에 대해, `assets/SCHEMA.md.template`에서 해당 섹션을 찾아 사용자에게 보여주고 `str_replace`로 추가할지 승인을 받는다. 사용자의 SCHEMA.md가 이미 커스터마이즈되어 충돌 가능성이 있으면 그 충돌을 표면화하고 처리 방법(건너뛰기/끝에 추가/수동 병합)을 묻는다.

## 관련 페이지

- [[schema-upgrade-marker-detection]]
- [[retrieval-setup-interview]]
- [[llm-wiki-plugin]]
