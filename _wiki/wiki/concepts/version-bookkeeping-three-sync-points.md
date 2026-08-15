---
type: concept
title: "버전 북키핑 3곳 동기화"
tags: [plugin-design]
sources: [plugin-manifest-and-versioning]
created: 2026-08-15
updated: 2026-08-15
---

# 버전 북키핑 3곳 동기화

플러그인 버전은 `.claude-plugin/plugin.json`(`version`), `.claude-plugin/marketplace.json`(`metadata.version`과 `plugins[0].version`), `CHANGELOG.md` 헤딩 3곳이 동시에 움직여야 한다는 규율([[plugin-manifest-and-versioning]] 참고).

## 검증 수단

`claude plugin validate .`가 이 세 지점의 불일치를 잡아낸다. 실제로 이 저장소의 세 파일 모두 `3.0.0`으로 일치하는 것을 확인했다.

## 왜 3곳인가

`plugin.json`은 플러그인 자체의 정체성, `marketplace.json`은 마켓플레이스 카탈로그에 노출되는 메타데이터(설명, 버전이 두 군데 — 마켓플레이스 전체 메타데이터와 개별 플러그인 항목 각각), `CHANGELOG.md`는 사람이 읽는 릴리스 이력이다. 세 파일이 서로 다른 소비자(플러그인 로더, 마켓플레이스 UI, 사람)를 향하기 때문에 각각 별도로 존재하지만, 버전 번호 자체는 하나의 사실이어야 하므로 동기화가 필요하다.

## 관련 페이지

- [[llm-wiki-plugin]]
