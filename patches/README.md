# Local patches (fork-only)

이 디렉토리는 upstream `llm-wiki-plugin`(원본: `praneybehl/llm-wiki-plugin`)에 올리지 않고
이 fork에서만 유지하는 로컬 패치를 보관한다.

## 왜 코드를 직접 고치지 않고 패치 파일로 관리하는가

이 fork를 최신화하는 방법은 `/plugin marketplace update` → 플러그인 재설치다. 이 경로는
`~/.claude/plugins/cache/llm-wiki/llm-wiki/<version>/` 캐시 디렉토리를 통째로 새로 받아오는
방식이라(git merge/rebase가 아님), 그 안의 파일을 직접 고쳐두면 다음 업데이트 때 무조건
사라진다. 대신 diff를 이 저장소(fork)에 patch 파일로 버전관리해두고, 업데이트 후
`scripts/apply-local-patches.sh`로 재적용한다.

## 사용법

```bash
# marketplace update 및 플러그인 재설치 후:
scripts/apply-local-patches.sh

# 적용 여부만 미리 확인 (변경 없음):
scripts/apply-local-patches.sh --check
```

패치가 깨졌다면(upstream이 해당 파일을 크게 바꾼 경우) 스크립트가 실패를 보고한다 —
`patches/<name>.patch`를 열어 현재 캐시 파일과 수동으로 비교해 diff를 다시 만든다.

## 패치 목록

- `multilingual-embedding.patch` — `skills/llm-wiki/scripts/wiki_search.py`의
  `LOCAL_EMBED_MODEL` 상수 하드코딩을 `FASTEMBED_MODEL` 환경변수로 오버라이드 가능하게 만든다.
  한국어 등 비영어 위키에서 다국어 임베딩 모델(예: `intfloat/multilingual-e5-small`,
  `BAAI/bge-m3`)을 쓰기 위함. 차원 수는 `TextEmbedding.get_embedding_size()`가 모델별로
  자동 계산하므로 별도 패치가 필요 없다.

  적용 후:
  ```bash
  export FASTEMBED_MODEL="intfloat/multilingual-e5-small"
  uv run --script skills/llm-wiki/scripts/setup_wiki.py --wiki wiki --cache
  ```
  모델을 바꾸면 벡터 인덱스 스키마 검증(`VECTOR_INDEX_SCHEMA`/차원 비교)이 자동으로
  불일치를 감지해 기존 `embeddings.sqlite` 테이블을 드롭 후 재구축한다 — 수동 마이그레이션
  불필요.

  BM25(lexical) 토크나이징은 이 패치 범위 밖이다 — `wiki_search.py`의 `TOKEN_RE`는 여전히
  `[a-z0-9]+` 기준이라 한글 토큰은 잡히지 않는다. 별도 패치 과제로 남겨둔다.
