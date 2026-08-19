#!/bin/sh
# graphify-session-hook.sh — called by Claude Code SessionStart/SessionEnd
# hooks (see ~/.claude/settings.json). Seeds graphify-out/ from the shared
# cache on start; saves it back on end. Cache key is derived from the git
# remote of `cwd`, so this same script works for any repo:
#   - ccdb-triage worktrees at /workspace/wt-<id> → key ff-k8s
#   - holyclaude / cc-connect user projects → key <project-name>
#
# Non-fatal on every path — Claude Code SessionStart cannot block session
# start per schema, so failures here never impact session boot.
set -eu

CACHE="${HOME}/.claude/graphify-cache"
mode="${1:-start}"

# Prefer the image-baked binary at /usr/local/bin/graphify explicitly.
# ~/.claude is on a shared CephFS home mounted across all three consumer
# pods; any `pip install --user graphifyy` (accidental or intentional)
# lands a shim at ~/.local/bin/graphify with a shebang pointing at the
# INSTALLING container's Python, which will not exist in the OTHER two
# containers. Because HolyClaude / CloudCLI puts ~/.local/bin before
# /usr/local/bin on PATH, `command -v graphify` would resolve to that
# broken shim first. Hard-pin to the image binary instead.
GRAPHIFY="/usr/local/bin/graphify"
[ -x "$GRAPHIFY" ] || GRAPHIFY="$(command -v graphify 2>/dev/null || true)"

# Derive a stable key from `git config remote.origin.url`. Fall back to the
# leaf directory name for repos without a remote. Give up quietly if we
# can't determine either.
key=""
if key=$(git -C . config --get remote.origin.url 2>/dev/null); then
  # Strip trailing .git and everything up to the last slash.
  key=$(printf '%s' "$key" | sed -E 's|.*/||; s|\.git$||')
fi
[ -z "$key" ] && key=$(basename "$(pwd)")
[ -z "$key" ] && exit 0

case "$mode" in
  start)
    # Seed only if there is no local graph AND a cached graph exists.
    if [ ! -d graphify-out ] && [ -d "$CACHE/$key/graphify-out" ]; then
      cp -a "$CACHE/$key/graphify-out" ./ 2>/dev/null || true
    fi
    # Foreground reflect — the caller in settings.json backgrounds this
    # whole invocation with `&`, so we're already async from Claude's POV.
    if [ -n "$GRAPHIFY" ] && [ -x "$GRAPHIFY" ]; then
      exec "$GRAPHIFY" reflect --if-stale --code-only
    fi
    ;;
  end)
    if [ -d graphify-out ]; then
      mkdir -p "$CACHE/$key" 2>/dev/null || true
      cp -a graphify-out "$CACHE/$key/" 2>/dev/null || true
    fi
    ;;
  *)
    echo "graphify-session-hook.sh: unknown mode '$mode'" >&2
    exit 2
    ;;
esac
