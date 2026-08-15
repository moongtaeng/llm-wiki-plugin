---
source_url: null
collected: 2026-08-15
published: Unknown
---

# 플러그인 매니페스트 및 버전 북키핑 (plugin.json / marketplace.json / CHANGELOG.md 발췌)

(이 문서는 `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json` 전체와 `CHANGELOG.md`의 최신 릴리스 노트를 발췌해 raw 소스로 수집한 것이다. 전체 이력은 저장소의 `CHANGELOG.md`를 참조.)

## .claude-plugin/plugin.json (전체)

```json
{
  "name": "llm-wiki",
  "version": "3.0.0",
  "description": "Build and maintain an LLM-curated personal knowledge base with default local FastEmbed + sqlite-vec search, BM25 fusion, structured evidence, incremental caching, and a compiled graph layer.",
  "author": {
    "name": "Praney Behl"
  },
  "license": "MIT",
  "homepage": "https://github.com/praneybehl/llm-wiki-plugin",
  "repository": "https://github.com/praneybehl/llm-wiki-plugin",
  "keywords": [
    "knowledge-base",
    "wiki",
    "notes",
    "research",
    "second-brain",
    "obsidian",
    "markdown",
    "rag-alternative",
    "llm-wiki"
  ]
}
```

## .claude-plugin/marketplace.json (전체)

```json
{
  "name": "llm-wiki",
  "owner": {
    "name": "Praney Behl"
  },
  "metadata": {
    "description": "LLM Wiki v3: durable agent knowledge bases with default local semantic retrieval, BM25 fusion, structured evidence, incremental caching, and a compiled graph.",
    "version": "3.0.0"
  },
  "plugins": [
    {
      "name": "llm-wiki",
      "source": "./",
      "description": "Build and maintain an LLM-curated personal knowledge base with default local FastEmbed + sqlite-vec search, BM25 fusion, structured JSON evidence, incremental caching, and a compiled graph layer. Includes the llm-wiki skill and seven /wiki:* commands.",
      "version": "3.0.0",
      "author": {
        "name": "Praney Behl"
      },
      "homepage": "https://github.com/praneybehl/llm-wiki-plugin",
      "repository": "https://github.com/praneybehl/llm-wiki-plugin",
      "license": "MIT",
      "category": "productivity",
      "keywords": ["knowledge-base", "wiki", "notes", "research", "second-brain"]
    }
  ]
}
```

## CHANGELOG.md 최신 릴리스: [3.0.0] - 2026-07-20

### Changed

- Replace OpenAI-compatible HTTP embeddings with local FastEmbed `BAAI/bge-small-en-v1.5` embeddings stored in sqlite-vec.
- Make local hybrid section retrieval the default and retain `--no-embed` as the dependency-free BM25 escape hatch.
- Keep the Paperclip worker lexical-only while preserving byte-for-byte parity with Python `--no-embed`; its documentation now distinguishes that surface from the default Python hybrid path.
- Declare pinned FastEmbed and sqlite-vec dependencies through PEP 723 for isolated `uv run --script` execution.
- Add `setup_wiki.py` as the mandatory init/upgrade runtime gate: it installs pinned FastEmbed 0.8.0, sqlite-vec 0.1.9, and PyYAML 6.0.3, caches the local model, builds the parse cache, synchronizes every wiki section, and emits a machine-readable readiness report.
- Give graph lint and extraction their own pinned PyYAML PEP 723 metadata so every dependency-bearing agent tool runs reproducibly through `uv run --script`.
- Bump the Paperclip companion, `paperclip-plugin-llm-wiki` v0.5.1, for its updated v3 local-retrieval agent setup guidance.
- Replace provider consent, credential, endpoint, and cache-marker setup with local model-download and index-build guidance.
- Add an idempotent v3 upgrade marker; existing Markdown needs no migration and legacy `embeddings.jsonl` caches are ignored.
- Make initialization and upgrade fail closed when `uv` or runtime setup is unavailable instead of reporting a partially ready wiki.

### Fixed

- Persist content-hashed section vectors in `wiki/.wiki-cache/embeddings.sqlite`, re-embedding only changed sections and removing deleted sections.
- Rebuild derived vectors automatically when the model, dimension, or vector schema changes.
- Apply the cosine metric consistently to filtered and unfiltered vector queries, and reject low-similarity semantic candidates before RRF to avoid false-positive answers on out-of-domain questions.
- Fall back to valid lexical JSON on missing dependencies, model failures, or sqlite-vec load failures without exposing exception details.
- Cover index reuse, incremental updates, deletions, filter-scoped vector search, dimension rebuilds, and lexical fallback with focused regressions.

`[Unreleased]` 섹션은 CHANGELOG.md 최상단에서 비어있는 상태로 확인됨(3.0.0이 현재 최신 릴리스).
