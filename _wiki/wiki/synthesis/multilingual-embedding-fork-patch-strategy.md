---
type: synthesis
title: "한글/다국어 임베딩 지원 — fork 패치 전략"
tags: [plugin-design, retrieval, open-question]
sources: [llm-wiki-wiki-search-script-reference, llm-wiki-retrieval-setup-reference, llm-wiki-plugin]
created: 2026-08-15
updated: 2026-08-15
---

# 한글/다국어 임베딩 지원 — fork 패치 전략

이 저장소(`moongtaeng/llm-wiki-plugin`)는 [[llm-wiki-plugin]]에 이미 hedge로 기록된 대로 원본
(`praneybehl/llm-wiki-plugin`)의 fork이며, 사용자는 원본에 자신의 수정을 반영하고 싶어하지 않는다.
동시에 이 fork를 최신화하는 방식은 `/plugin marketplace update` → 재설치이며, 이는 git
merge/rebase가 아니라 `~/.claude/plugins/cache/llm-wiki/llm-wiki/<version>/` 캐시 디렉토리
전체를 새로 받아오는 구조다. 이 두 제약(원본에 반영 안 함 + 캐시 통째 교체) 위에서
한글/다국어 임베딩 지원을 어떻게 유지할지 정리한다.

## 확인된 사실 — 무엇이, 어디에 하드코딩되어 있는가

[[baai-bge-small-en-v1-5]]는 `skills/llm-wiki/scripts/wiki_search.py` 56번째 줄
(플러그인 v3.0.0 기준)의 **모듈 레벨 상수** `LOCAL_EMBED_MODEL = "BAAI/bge-small-en-v1.5"`로
정의되어 있다. 이전에 이 위키의 다른 페이지들([[local-semantic-backend]] 등)은 이를
"`load_local_embedding_backend` 함수 내부 리터럴"로 서술했는데, 실제 소스를 다시 확인한
결과 함수 내부가 아니라 **모듈 상수를 참조**하는 구조였다 — 서술 오류이므로 이 synthesis
페이지가 정정본이다.

중요한 점: 벡터 차원(`dimension`)은 하드코딩되어 있지 않고 `TextEmbedding.get_embedding_size(LOCAL_EMBED_MODEL)`로
**모델에 따라 자동 계산**된다(`wiki_search.py`). `setup_wiki.py`도 `wiki_search.LOCAL_EMBED_MODEL`을
그대로 참조할 뿐 자체 검증 로직을 갖지 않는다. 즉 `LOCAL_EMBED_MODEL` 상수 하나만 오버라이드
가능하게 만들면, 벡터 인덱스 스키마 버전 체크([[baai-bge-small-en-v1-5]] 참고 — 모델/차원이
바뀌면 `embeddings.sqlite` 테이블을 자동 드롭·재생성)가 나머지를 알아서 처리한다.

한편 [[bm25-scoring]]의 lexical 토크나이저 `TOKEN_RE = re.compile(r"[a-z0-9]+")`는 한글
유니코드 범위를 전혀 포함하지 않아, `--no-embed` 경로나 RRF의 lexical 절반에서는 한글 텍스트가
토큰을 하나도 생성하지 못한다. 이는 임베딩 모델 교체와 별개의 문제이며 아직 해결되지 않았다.

## SCHEMA.md로는 해결되지 않는다는 정정

애초에 이 논의에서 "SCHEMA.md 설정만으로 해결 가능한가"라는 질문이 나왔는데, 답은 아니오다.
`wiki/SCHEMA.md`는 위키 콘텐츠·워크플로 설정 파일이며 [[schema-upgrade-marker-detection]]/
[[wiki-upgrade-idempotent-strategy]]가 보장하는 것은 "업그레이드가 SCHEMA.md를 함부로
덮어쓰지 않는다"는 것뿐이다. `wiki_search.py`가 SCHEMA.md를 읽어 모델을 선택하는 코드 경로는
플러그인에 없다. 모델을 바꾸려면 반드시 `wiki_search.py`(Python) 자체를 고쳐야 한다.

## 채택한 전략: patch 파일 + 재적용 스크립트

fork이므로 코드를 직접 고치는 것 자체는 문제가 아니다. 문제는 `/plugin marketplace update`가
캐시 디렉토리를 통째로 교체해 직접 수정을 매번 삼킨다는 것이다. 따라서:

- diff를 이 저장소의 `patches/*.patch`에 버전관리 (`patches/multilingual-embedding.patch`)
- `scripts/apply-local-patches.sh`가 설치된 플러그인 캐시 경로를 자동 탐색해 패치를 재적용
  (`--check`로 dry-run, 이미 적용됐으면 스킵, upstream이 해당 라인을 바꿔 conflict가 나면
  실패를 보고하고 수동 병합을 안내)
- 절차는 `patches/README.md`에 문서화

이 방식을 택한 이유는 git merge/rebase 기반 전략이 애초에 불가능하기 때문이다 — 플러그인
설치가 마켓플레이스 배포판 교체형이라 로컬 git 히스토리가 캐시 디렉토리에 이어지지 않는다.
patch 파일은 diff가 작을수록(이번 건은 상수 한 줄) 매 업데이트마다 clean하게 재적용될
가능성이 높다.

## 패치 내용

`LOCAL_EMBED_MODEL`을 `os.environ.get("FASTEMBED_MODEL", "BAAI/bge-small-en-v1.5")`로 변경.
`FASTEMBED_MODEL` 환경변수를 설정하면 다국어 모델(`intfloat/multilingual-e5-small`,
`BAAI/bge-m3` 등)로 즉시 전환되며, 미설정 시 기존 기본값을 그대로 유지해 upstream과의
동작 동등성을 보존한다. dry-run과 실제 적용 모두 실제 설치된 플러그인 캐시
(`~/.claude/plugins/cache/llm-wiki/llm-wiki/3.0.0/`)를 대상으로 검증 완료.

## 남은 과제

- BM25 lexical 토크나이저의 한글 미지원(`TOKEN_RE`)은 이번 패치 범위 밖. 별도 패치 필요.
- 임베딩 모델 교체 후 실제 검색 품질(recall/precision) 검증은 아직 수행하지 않음 — 다음 단계.

## 관련 페이지

- [[llm-wiki-plugin]]
- [[baai-bge-small-en-v1-5]]
- [[local-semantic-backend]]
- [[bm25-scoring]]
- [[wiki-upgrade-idempotent-strategy]]
- [[schema-upgrade-marker-detection]]
- [[pep-723-inline-dependency-declaration]]
