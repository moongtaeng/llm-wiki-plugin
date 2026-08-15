---
links: "[[SCHEMA]]"
---

# LLM Wiki — agent memory

This project maintains an LLM-curated wiki at `_wiki/wiki/` (raw sources in `_wiki/raw/`) following Andrej Karpathy's "LLM Wiki" pattern (https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). Note the non-default paths: this repo is the `llm-wiki` plugin's own source, so the wiki lives under `_wiki/` instead of the plugin defaults `wiki/`/`raw/` to avoid colliding with the plugin's shipped templates and docs.

Before answering questions that rely on knowledge accumulated in this project, read `_wiki/wiki/index.md` (or the relevant shard under `_wiki/wiki/indexes/` if the wiki has been sharded) and use its one-line summaries to find the pages you need. Cite with `[[wikilinks]]`. If the index does not surface good candidates, fall back to the `llm-wiki` skill's `wiki_search.py` for local hybrid retrieval, pointed at `--wiki _wiki/wiki`; add `--no-embed` for dependency-free BM25.

To add a new source, follow the `llm-wiki` skill's ingest workflow: decide placement under `_wiki/wiki/sources/`, `_wiki/wiki/entities/`, `_wiki/wiki/concepts/`, or `_wiki/wiki/synthesis/`; identify touched pages and make surgical `str_replace` updates rather than rewrites; update the index; append a one-line entry to `_wiki/wiki/log.md`.

Scaling discipline: atomic pages (400-line soft cap, 800-line hard cap), sharded indexes past ~150 pages or 300 index lines, required YAML frontmatter on every page, `[[wikilinks]]` for every cross-reference.

Tag taxonomy for this wiki: `plugin-design` (this repo's own architecture decisions), `retrieval` (search/embedding/BM25/RRF pipeline), `external-ref` (notes distilled from outside sources), `open-question`, `contested`.

Full conventions live in `_wiki/wiki/SCHEMA.md`. Treat it as authoritative when it disagrees with this summary.
