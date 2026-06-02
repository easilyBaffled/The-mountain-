#!/usr/bin/env bash
# Bootstrap superpowers (https://github.com/obra/superpowers) for Claude Code.
#
# superpowers ships as a git submodule at .superpowers. On a fresh clone that
# did not use --recurse-submodules (e.g. Claude Code on the web), that directory
# is empty, so we init it on demand before running the real SessionStart hook.
# The script always exits 0 and only writes the hook's JSON to stdout, so a
# missing network or submodule never breaks the session.

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." 2>/dev/null && pwd)"
sp_root="$repo_root/.superpowers"

# Self-heal: check out the submodule if it isn't present yet.
if [ ! -f "$sp_root/hooks/session-start" ]; then
  git -C "$repo_root" submodule update --init --recursive >/dev/null 2>&1
fi

# Run superpowers' own SessionStart hook, which injects the using-superpowers
# bootstrap so skills auto-trigger. CLAUDE_PLUGIN_ROOT is what that hook expects.
if [ -f "$sp_root/hooks/session-start" ]; then
  CLAUDE_PLUGIN_ROOT="$sp_root" bash "$sp_root/hooks/session-start" 2>/dev/null
fi

exit 0
