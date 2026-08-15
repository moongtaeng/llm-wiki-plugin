# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

This is a **Claude Code plugin** (`llm-wiki`) that implements Andrej Karpathy's "LLM Wiki" pattern: a personal/team knowledge base built and maintained by an LLM inside a project, with local hybrid (BM25 + semantic) retrieval. The repo is the plugin's source — it is not itself a wiki. When installed into a project, the plugin creates and maintains a `wiki/` + `raw/` directory structure *in that project*, not here.

Four surface areas make up the plugin:
- `skills/llm-wiki/SKILL.md` + `skills/llm-wiki/references/*.md` — the skill itself, which Claude reads to know how to ingest sources, answer queries, and lint a wiki. This prose is the actual "logic" of the product.
- `skills/llm-wiki/scripts/*.py` — bundled Python tools the skill invokes (search, lint, stats, graph extraction, init/upgrade).
- `commands/wiki/*.md` — the seven `/wiki:*` slash command manifests (thin wrappers that point Claude at the skill workflow).
- `docs/` — VitePress documentation site (separate from the plugin runtime).

There is also `integrations/paperclip/plugin/` — a separate TypeScript/Node sub-project (a Paperclip UI plugin) with its own `package.json`, tests, and build.

## Commands

### Docs site (root `package.json`)
```bash
pnpm install
pnpm docs:dev       # VitePress dev server
pnpm docs:build     # build docs
pnpm docs:preview   # preview built docs
```

### Plugin scripts (Python, in `skills/llm-wiki/scripts/`)
No project-wide build/lint/test command exists for the plugin itself — it's markdown + stdlib-first Python scripts. Two dependency modes:

- **Pure stdlib** (no install): `wiki_lint.py`, `wiki_stats.py`, `wiki_graph_query.py`, and `wiki_search.py --no-embed` run directly with `python3`.
- **PEP 723 pinned scripts** (`wiki_search.py` default mode, `setup_wiki.py`, `wiki_graph_extract.py`, `wiki_graph_lint.py`): declare `fastembed==0.8.0`, `sqlite-vec==0.1.9`, `pyyaml==6.0.3` inline and must be run with `uv run --script <file>` so `uv` resolves the pinned env.

Manual smoke test against a throwaway wiki (see CONTRIBUTING.md):
```bash
mkdir /tmp/test-wiki && cd /tmp/test-wiki
python /path/to/llm-wiki-plugin/skills/llm-wiki/scripts/init_wiki.py .
python /path/to/llm-wiki-plugin/skills/llm-wiki/scripts/wiki_lint.py wiki/
python /path/to/llm-wiki-plugin/skills/llm-wiki/scripts/wiki_stats.py wiki/
python /path/to/llm-wiki-plugin/skills/llm-wiki/scripts/wiki_search.py "your query terms"
```

Validate plugin manifests (also run in CI / before release):
```bash
python -c "import json; json.load(open('.claude-plugin/plugin.json')); json.load(open('.claude-plugin/marketplace.json'))"
claude plugin validate .
```

### Retrieval eval suite (`eval/retrieval/`)
```bash
python3 eval/retrieval/run_eval.py                       # lexical-only report
uv run --with fastembed==0.8.0 --with sqlite-vec==0.1.9 \
  python eval/retrieval/run_eval.py                       # + hybrid retrieval
python3 eval/retrieval/run_eval.py --gate                 # + CI regression gate
```
Also plain `unittest` files runnable directly: `python3 eval/retrieval/test_search_contracts.py`, `test_setup.py`, `test_embedding_mode.py` (each loads `wiki_search.py`/`setup_wiki.py` via `importlib` from `skills/llm-wiki/scripts/`, not via package imports — mirror that pattern for new tests).

### Local plugin development loop
```
/plugin marketplace add /absolute/path/to/llm-wiki-plugin
/plugin install llm-wiki@llm-wiki
```
After edits: `/plugin marketplace update` then reinstall. No build step — skill, commands, and scripts run as-is from the filesystem.

This fork carries local patches (Korean/multilingual retrieval support) that live outside the installed plugin cache and do not survive `/plugin marketplace update` on their own — see `patches/README.md`. Run `scripts/apply-local-patches.sh` after every marketplace update/reinstall.

### Paperclip sub-plugin (`integrations/paperclip/plugin/`)
Has its own `package.json`, `esbuild.config.mjs`, `vitest.config.ts` — treat it as an independent Node/TS project when working there; check its own README/scripts rather than assuming root commands apply.

## Architecture

### The wiki's three layers + three operations
The entire skill design (see `skills/llm-wiki/references/architecture.md` for the full rationale) is organized around:
- **Layers**: raw sources (`raw/`, immutable, user-curated) → the wiki (`wiki/{sources,entities,concepts,synthesis}/`, LLM-owned, generated markdown) → the schema (`wiki/SCHEMA.md`, co-evolved config that overrides default conventions for that specific wiki — always read it first when entering an existing wiki).
- **Operations**: ingest (compile a new source into wiki pages), query (answer a question by reading the index then candidate pages, optionally filing the answer back as synthesis), lint (structural + semantic health check).
- **Optional 4th layer**: `wiki/graph/` — typed `graph:` frontmatter metadata compiled by `wiki_graph_extract.py` into `nodes.jsonl`/`edges.jsonl`/`graph.sqlite`/`graph.graphml`. Markdown stays canonical; the graph is always regenerable from it.

### Retrieval architecture (`wiki_search.py`)
Default path is **local-first hybrid**: FastEmbed runs `BAAI/bge-small-en-v1.5` on-device, vectors are cached in `wiki/.wiki-cache/embeddings.sqlite` via sqlite-vec, and semantic ranks are fused with BM25 ranks via RRF. No API key, no outbound network call, no provider consent flow. `--no-embed` is the dependency-free pure-BM25 fallback (also the automatic fallback if the local backend fails). Retrieval is **section-level** by default (`--granularity page` restores whole-page ranking), with incremental content-hash caching so only changed sections get re-embedded.

### Scalability discipline (why the skill is opinionated)
The plugin's core design bet is that naive LLM-wiki implementations collapse once the wiki gets big enough that queries either read too many pages or skip the relevant ones. Every convention below exists to prevent that, and contributions that would erode them (see CONTRIBUTING.md) need an issue discussion first:
- **Atomic pages**: soft cap 400 lines / hard cap 800 lines per page, enforced by `wiki_lint.py`.
- **Index-first navigation**: always read `wiki/index.md` (or sharded `wiki/indexes/*.md` once the wiki passes ~150 pages / index exceeds ~300 lines) before reading any page bodies.
- **YAML frontmatter on every page** (`type`, `tags`, `sources`, `updated` minimum) so search/filtering never needs to open page bodies.
- **Surgical edits**: `str_replace` on the relevant section during ingest, never whole-page rewrites.
- **Chunked source ingestion**: large raw sources are read in chunks, never loaded whole.

### Script dependency conventions
Scripts either declare **PEP 723 inline metadata** (a `# /// script` block with pinned `dependencies`) and require `uv run --script`, or are **pure stdlib**. When adding a new bundled script, follow whichever mode fits — don't add a new third-party dependency without inline pinning, and never make `wiki_lint.py`/`wiki_stats.py`/`wiki_graph_query.py` require anything beyond stdlib (that dependency-free path is load-bearing, per CONTRIBUTING.md).

### Version bookkeeping
Plugin version lives in three places that must move together: `.claude-plugin/plugin.json` (`version`), `.claude-plugin/marketplace.json` (`metadata.version` and `plugins[0].version`), and a `CHANGELOG.md` heading. `claude plugin validate .` catches mismatches. `skills/llm-wiki/SKILL.md`, `commands/wiki/*.md`, and reference docs carry no version field of their own — see CONTRIBUTING.md's "Releasing" section for the full checklist if doing a release.

## Working on the skill prose itself

`SKILL.md` and `references/*.md` are read by an LLM at runtime, not compiled — style matters as much as correctness:
- Prose with minimal bullets; the reference files favor continuous reasoning over bullet lists (more than 3-4 bullets in a row is a signal to convert to prose).
- Imperative voice for instructions, explanatory voice for rationale.
- Hedge claims that aren't established as fact; avoid unearned absolutes.
- If you change the `SKILL.md` frontmatter `description`, keep it under 1024 characters and make sure the change genuinely improves trigger recall (this description is Claude's primary signal for when to reach for the skill).

## LLM Wiki

This repo maintains its own dogfood knowledge base at `_wiki/wiki/` (non-default path — see why in `_wiki/memory.md`). Read `_wiki/memory.md` before answering questions that could draw on accumulated wiki knowledge.
