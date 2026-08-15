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

두 패치 모두 `skills/llm-wiki/scripts/wiki_search.py`의 서로 다른 줄을 건드리므로 순서
무관하게 함께 적용 가능하다(`scripts/apply-local-patches.sh`가 순서대로 모두 처리한다).

### `multilingual-embedding.patch`

`LOCAL_EMBED_MODEL` 상수 하드코딩을 `FASTEMBED_MODEL` 환경변수로 오버라이드 가능하게 만들고,
**환경변수 미설정 시의 폴백 기본값도 upstream의 영문 전용 `BAAI/bge-small-en-v1.5`가 아니라
`intfloat/multilingual-e5-large`로 바꾼다.** 차원 수는 `TextEmbedding.get_embedding_size()`가
모델별로 자동 계산하므로 별도 패치가 필요 없다.

폴백 기본값 자체를 바꾼 이유: 처음에는 "환경변수 오버라이드만 가능하게 하고 기본값은
upstream 그대로 둔다"는 설계였으나, 다른 (소설 집필용) 레포에서 이 fork의 검색을 쓰다가
`FASTEMBED_MODEL`을 설정하지 않은 세션에서 `~/.cache/llm-wiki`에 남아있던 이전 캐시
모델(영문 전용)을 계속 읽어 들이는 문제가 드러났다. 즉 "환경변수로 바꿀 수 있다"는
것만으로는 설정을 깜빡하면 여전히 한글이 사실상 동작하지 않는 모델로 조용히 폴백된다.
이 fork의 존재 이유가 한글 지원이므로, 폴백 기본값 자체를 다국어 모델로 바꿔 환경변수를
전혀 건드리지 않아도 한글 위키가 기본으로 동작하도록 했다. `multilingual-e5-small`이나
`bge-m3`도 후보로 검토했으나 그 레포에서 최종적으로 검증에 쓴 모델이 `multilingual-e5-large`
였고, 용량은 더 크지만(수백MB~1GB대) 한국어 검색 품질이 더 안정적이라 기본값으로 채택했다.

영어 전용 위키 등 upstream 기본값(`BAAI/bge-small-en-v1.5`)이 필요하면 `FASTEMBED_MODEL`을
명시적으로 지정한다:
```bash
export FASTEMBED_MODEL="BAAI/bge-small-en-v1.5"
uv run --script skills/llm-wiki/scripts/setup_wiki.py --wiki wiki --cache
```
모델을 바꾸면 벡터 인덱스 스키마 검증(`VECTOR_INDEX_SCHEMA`/차원 비교)이 자동으로
불일치를 감지해 기존 `embeddings.sqlite` 테이블을 드롭 후 재구축한다 — 수동 마이그레이션
불필요. 캐시가 꼬였을 때(예: 이전 모델이 계속 읽히는 것으로 보일 때)는
`~/.cache/llm-wiki`와 wiki별 `wiki/.wiki-cache/`를 지우고 재설치해 이전 모델이 남아있지
않은지 확인할 것.

### `hangul-tokenizer.patch`

BM25(lexical) 토크나이저 `TOKEN_RE`를 `r"[a-z0-9]+"`에서 `r"[a-z0-9]+|[가-힣ㄱ-ㆎ]+"`로
확장해 한글 완성형 음절(U+AC00–D7A3)과 자모(U+3131–318E)도 토큰으로 인식하게 한다.
패치 전에는 한글 쿼리/문서가 lexical 경로에서 토큰을 하나도 생성하지 못해 `--no-embed`나
semantic 백엔드 폴백 시 검색이 사실상 무력화됐다.

이 패치는 스크립트 경계(한글 vs 비한글) 기준으로만 토큰을 나누는 것이지 진짜 형태소
분석기가 아니다 — "다국어를", "다국어가" 같이 조사가 붙은 형태는 서로 다른 토큰으로
남는다(어간 분리 없음). 완벽한 한국어 형태소 분석이 필요하면 별도 라이브러리 도입이
필요하지만, `wiki_lint.py`/`wiki_stats.py`/`wiki_search.py --no-embed` 등은 stdlib-only
규율을 지켜야 하므로([[pure-stdlib-fallback-scripts]]) 이 패치는 의도적으로 정규식
확장에 그친다.

적용 확인:
```bash
python3 skills/llm-wiki/scripts/wiki_search.py "한글쿼리" --wiki wiki --no-embed --json
```
`--no-embed` 결과에 관련 섹션이 잡히면 정상 적용된 것이다.
