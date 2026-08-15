---
type: source
title: "llm-wiki 스킬 SKILL.md (허브 문서)"
authors: ["llm-wiki plugin maintainers"]
url: null
raw: "_wiki/raw/llm-wiki-skill-md-reference.md"
ingested: 2026-08-15
tags: [plugin-design]
entities: [llm-wiki-plugin, andrej-karpathy]
concepts: [three-layer-three-operation-architecture, scalability-discipline, wiki-failure-modes, graph-layer]
created: 2026-08-15
updated: 2026-08-15
---

# llm-wiki 스킬 SKILL.md (허브 문서)

`skills/llm-wiki/SKILL.md`는 스킬 전체의 진입점이다. 트리거 조건, 3계층/3연산 구조 요약, 그래프 레이어 개요, 기본 디렉터리 레이아웃, 확장성 규율, 초기화 절차, ingest/query/lint 요약, 4대 실패 모드, 레퍼런스·스크립트·템플릿 목록을 한 문서에 압축해 담고 있으며, 나머지 8개 reference 파일 각각을 상세화 대상으로 가리키는 색인 역할을 한다.

## 패턴 한 문단 요약

통상적 RAG는 매 질의마다 원본 청크에서 지식을 재유도하므로 아무것도 축적되지 않는다. LLM Wiki 패턴은 이를 뒤집는다 — 새 소스가 도착하면 LLM이 그것을 한 번 지속적이고 구조화된 위키로 컴파일한다(개념 추출, 엔티티 페이지 작성, 교차 참조 갱신, 모순 플래그). 이후 질의는 원본 소스가 아니라 이미 종합된 위키를 읽는다. 지식이 복리로 쌓인다.

## 그래프 레이어 개요

페이지는 frontmatter에 타입 있는 `graph:` 메타데이터를 가질 수 있다. 번들 추출기가 모든 페이지를 `wiki/graph/`(nodes.jsonl, edges.jsonl, graph.sqlite, graph.graphml)로 컴파일한다. 마크다운이 canonical이고 그래프는 재생성 가능한 인덱스다. `graph:`가 없는 페이지도 `type`/`kind`에서 파생된 노드로 나타나며 본문 위키링크에서 낮은 신뢰도의 `mentions` 엣지를 만들어낸다. `founded`, `proposed`, `depends_on` 같은 타입 있는 의미 엣지는 명시적 소스와 근거 인용이 필요하며, 훈련 데이터로부터 추론해 만들어내면 안 된다.

## 기본 프로젝트 레이아웃

```
<project-root>/
├── wiki/{SCHEMA.md, index.md, log.md, indexes/, entities/, concepts/, sources/, synthesis/}
└── raw/{assets/}
```
이 레이아웃은 기본값일 뿐 강제 사항은 아니다 — 프로젝트가 이미 다른 이름(`kb/`, `notes/`, `vault/`)을 쓴다면 그것을 따른다. (이 저장소 자체가 `_wiki/`라는 비표준 경로를 쓰는 사례임 — [[dogfooding-llm-wiki]] 참고.)

## 초기화 절차 요약

`wiki/` 디렉터리가 없으면 `scripts/init_wiki.py <project-root>`로 부트스트랩한다. 디렉터리 구조 생성, `SCHEMA.md`/`index.md`/`log.md` 템플릿 배치 후 필수 로컬 런타임 셋업(pinned 의존성 설치, 모델 다운로드, 파싱 캐시 구축, 전체 섹션 임베딩)까지 실행하며, 셋업이 `"status": "ready"`를 방출하지 않으면 초기화·업그레이드를 완료로 취급하지 않는다. 부트스트랩 전 `retrieval-setup.md`의 그룹 인터뷰로 경로·모델 캐시 위치·그래프 사용 여부·에이전트 메모리 통합을 확인한다.

## 4대 실패 모드 (요약)

Karpathy의 gist 코멘트에서 드러난 실패 모드들이다:
1. **침묵의 부패(silent corruption)** — 한 소스의 오독이 권위 있어 보이는 위키 페이지가 되고, 그것이 이후 소스 해석에 영향을 미치며 오류가 눈에 띄지 않게 복리로 쌓인다.
2. **위키가 자기 출력을 읽는 드리프트** — LLM이 이전 위키 페이지를 근거(ground truth)로 취급하기 시작하고 원본 소스와 대조하는 것을 멈춘다.
3. **유지보수 래칫(maintenance ratchet)** — 위키가 커질수록 LLM 출력에 필요한 사람의 감독이 늘어나 사람의 일이 오히려 더 많아지는 경향.
4. **관계형 도메인으로의 스코프 크리프** — 조직도, 재무 원장, 구조화 데이터셋처럼 근본적으로 관계형인 도메인에는 이 패턴이 맞지 않는다.

## 이 소스가 연결되는 곳

- [[three-layer-three-operation-architecture]]
- [[scalability-discipline]]
- [[wiki-failure-modes]]
- [[graph-layer]]
- [[llm-wiki-plugin]]
- [[andrej-karpathy]]
