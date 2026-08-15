---
type: source
title: "llm-wiki 스크립트: wiki_search.py (하이브리드 검색 엔진)"
authors: ["llm-wiki plugin maintainers"]
url: null
raw: "_wiki/raw/scripts/wiki_search.py"
ingested: 2026-08-15
tags: [plugin-design, retrieval]
entities: [fastembed, sqlite-vec, baai-bge-small-en-v1-5]
concepts: [hybrid-retrieval-search, reciprocal-rank-fusion-search, section-level-vs-page-level-search-granularity, content-hash-incremental-embedding-cache, local-semantic-backend, bm25-scoring, pep-723-inline-dependency-declaration]
created: 2026-08-15
updated: 2026-08-15
---

# llm-wiki 스크립트: wiki_search.py

`skills/llm-wiki/scripts/wiki_search.py`(840줄)는 번들 스크립트 중 가장 크고 핵심적인, 위키의 하이브리드 검색 엔진이다. PEP 723으로 `fastembed==0.8.0`, `sqlite-vec==0.1.9`를 pin한다.

## 핵심 구성요소

- **자체 frontmatter 파서** — `--no-embed` 모드가 완전히 stdlib로 남도록 YAML 라이브러리를 쓰지 않는 경량 파서.
- **섹션 분할(`split_sections`)** — ATX 헤딩(`#`~`######`) 기준으로 페이지를 쪼갠다. 코드펜스 내부의 `#`은 헤딩으로 취급하지 않고(`in_fence` 플래그), `heading_stack`으로 계층적 `heading_path`를 추적한다.
- **파싱 캐시(`load_parse_cache`/`write_parse_cache`/`collect_pages`)** — 파일별 SHA256으로 변경을 감지해 안 변한 파일은 캐시된 섹션을 재사용한다. 캐시 스키마 검증 실패 시 자동 재구축하고, `os.replace`로 원자적 쓰기를 한다.
- **[[bm25-scoring]](`build_bm25`/`bm25_score`)** — 표준 BM25(k1=1.5, b=0.75)를 외부 라이브러리 없이 직접 구현.
- **[[local-semantic-backend]](`load_local_embedding_backend`)** — `fastembed.TextEmbedding("BAAI/bge-small-en-v1.5")`를 로드. 캐시 경로는 `FASTEMBED_CACHE_PATH` 환경변수 또는 `~/.cache/llm-wiki/fastembed/` 기본값.
- **벡터 인덱스(`open_vector_index`/`sync_vector_index`)** — sqlite-vec의 `vec0` 가상 테이블(`semantic_vectors`, cosine distance). 스키마/모델/차원이 바뀌면 테이블을 드롭 후 재생성한다(`VECTOR_INDEX_SCHEMA = "2"`). [[content-hash-incremental-embedding-cache]] 전략으로 변경/신규 섹션만 재임베딩하고 삭제된 섹션은 벡터·메타 둘 다 제거한다.
- **[[reciprocal-rank-fusion-search]]** — `score += 1.0 / (60 + rank)` 공식을 BM25 랭크와 semantic 랭크 각각에 적용해 합산한다(k=60). BM25 후보는 top 50까지만 후보 풀에 편입된다.

## 안전한 폴백

로컬 백엔드 로딩/동기화가 예외를 던지면 `except Exception`으로 잡아 `mode="lexical"`로 조용히 폴백하고 stderr 경고만 출력한다 — 하이브리드가 기본이지만 항상 안전한 폴백 경로가 존재해야 한다는 설계 원칙(모듈 docstring)이 명시적으로 뒷받침한다.

## CLI 옵션

위치인자 query, `--wiki`, `--top`(기본10), `--type`, `--tag`(반복가능), `--since`, `--backlinks`, `--top-linked`, `--cache`, `--granularity`(section/page), `--per-page`(기본2), `--json`, `--no-embed`.

## 주목할 설계 결정

`edge_id`류 절충과 달리, 이 스크립트 자체의 모듈 docstring은 "FastEmbed and sqlite-vec provide the default semantic path. BM25 remains available without dependencies through --no-embed and as a safe fallback."이라고 명시한다. 또한 `split_sections` 내부 주석은 "Kept in the API for parity with the TypeScript implementation."라고 언급하는데, 이는 `integrations/paperclip/plugin/`(TS/Node 서브프로젝트)에 이 스크립트의 TS 포트가 존재할 가능성을 시사한다 — 이번 인제스트 범위 밖이라 확인은 보류.

## 이 소스가 연결되는 곳

- [[hybrid-retrieval-search]]
- [[reciprocal-rank-fusion-search]]
- [[section-level-vs-page-level-search-granularity]]
- [[content-hash-incremental-embedding-cache]]
- [[local-semantic-backend]]
- [[bm25-scoring]]
- [[pep-723-inline-dependency-declaration]]
