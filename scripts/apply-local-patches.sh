#!/usr/bin/env bash
# Re-applies this fork's local patches (patches/*.patch) to the currently
# installed llm-wiki plugin cache after `/plugin marketplace update`.
#
# Why this exists: `/plugin marketplace update` replaces the plugin cache
# directory wholesale (it is not a git merge), so any direct edits made to
# files under ~/.claude/plugins/cache/llm-wiki/ are lost on every update.
# Keeping the diffs here as patch files, versioned in this fork, and
# re-applying them after each update is the low-conflict way to carry
# local changes forward without diverging from upstream in a way that
# blocks future `git merge`/rebase from the original repo.
#
# Usage:
#   scripts/apply-local-patches.sh            # apply all patches/*.patch
#   scripts/apply-local-patches.sh --check    # dry-run only, no changes
#   scripts/apply-local-patches.sh --plugin-root /custom/path

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATCH_DIR="${SCRIPT_DIR}/../patches"
DRY_RUN=0
PLUGIN_ROOT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --check)
      DRY_RUN=1
      shift
      ;;
    --plugin-root)
      PLUGIN_ROOT="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

if [[ -z "${PLUGIN_ROOT}" ]]; then
  # Pick the highest-versioned installed llm-wiki plugin under the default
  # Claude Code plugin cache layout: ~/.claude/plugins/cache/llm-wiki/llm-wiki/<version>/
  CACHE_BASE="${HOME}/.claude/plugins/cache/llm-wiki/llm-wiki"
  if [[ ! -d "${CACHE_BASE}" ]]; then
    echo "error: plugin cache not found at ${CACHE_BASE}" >&2
    echo "       pass --plugin-root explicitly if this plugin is installed elsewhere" >&2
    exit 1
  fi
  PLUGIN_ROOT="$(find "${CACHE_BASE}" -mindepth 1 -maxdepth 1 -type d | sort -V | tail -n1)"
  if [[ -z "${PLUGIN_ROOT}" ]]; then
    echo "error: no version directories under ${CACHE_BASE}" >&2
    exit 1
  fi
fi

echo "Plugin root: ${PLUGIN_ROOT}"

if [[ ! -d "${PATCH_DIR}" ]]; then
  echo "error: patch directory not found at ${PATCH_DIR}" >&2
  exit 1
fi

shopt -s nullglob
PATCHES=("${PATCH_DIR}"/*.patch)
shopt -u nullglob

if [[ ${#PATCHES[@]} -eq 0 ]]; then
  echo "No patches found in ${PATCH_DIR}, nothing to do."
  exit 0
fi

FAILED=0
for patch_file in "${PATCHES[@]}"; do
  name="$(basename "${patch_file}")"
  echo "--- ${name} ---"

  # Check "already applied" first (reverse-dry-run succeeds) — the forward
  # dry-run's "ignored hunks" wording differs across patch implementations
  # (GNU vs BSD/Apple), so exit-code-based detection is what's portable.
  if (cd "${PLUGIN_ROOT}" && patch -R --dry-run -p1 --forward < "${patch_file}") >/tmp/patch-check.$$ 2>&1; then
    echo "Already applied — skipping."
  elif (cd "${PLUGIN_ROOT}" && patch --dry-run -p1 --forward < "${patch_file}") >/tmp/patch-check.$$ 2>&1; then
    if [[ "${DRY_RUN}" -eq 1 ]]; then
      echo "OK (would apply cleanly)"
    else
      (cd "${PLUGIN_ROOT}" && patch -p1 --forward -b --suffix=.pre-local-patch < "${patch_file}")
      echo "Applied. Original files backed up with .pre-local-patch suffix."
    fi
  else
    echo "FAILED to apply (upstream likely changed this file):"
    sed 's/^/  /' /tmp/patch-check.$$
    echo "  -> resolve by hand: diff patches/${name} against"
    echo "     ${PLUGIN_ROOT}/skills/llm-wiki/scripts/wiki_search.py and update the patch."
    FAILED=1
  fi
  rm -f /tmp/patch-check.$$
done

if [[ "${FAILED}" -eq 1 ]]; then
  echo ""
  echo "One or more patches failed to apply. See docs/local-patches.md for the manual-merge procedure." >&2
  exit 1
fi

echo ""
echo "Done. Verify with: uv run --script \"${PLUGIN_ROOT}/skills/llm-wiki/scripts/setup_wiki.py\" --wiki wiki --cache"
