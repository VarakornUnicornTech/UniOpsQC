#!/usr/bin/env bash
# RoundTable Hook: check-git-workflow
# Event: PreToolUse (Bash)
# Purpose: Enforces /git skill usage for all state-changing git operations.
#          Blocks raw git push/commit/merge/rebase/pull/reset --hard — use /git skill instead.
# Exit 0 = allow, Exit 2 = block
#
# Bypass: Add '# git-skill-internal' anywhere in the command.
#         The /git skill uses this marker for its own internal git calls.
#
# Allowed without skill: git status, log, diff, fetch, add, checkout, branch, stash, show, remote, tag

# Parse command from TOOL_INPUT JSON
if command -v jq &>/dev/null; then
  COMMAND=$(echo "$TOOL_INPUT" | jq -r '.command // ""' 2>/dev/null)
else
  COMMAND=$(echo "$TOOL_INPUT" | grep -o '"command"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"command"[[:space:]]*:[[:space:]]*"//;s/"$//')
fi

# Allow if command couldn't be parsed
[ -z "$COMMAND" ] && exit 0

# Allow bypass marker — used by /git skill for its own internal git calls
if echo "$COMMAND" | grep -q '# git-skill-internal'; then
  exit 0
fi

# Block destructive reset (--hard)
if echo "$COMMAND" | grep -qE '(^|;|&&|\|\|)\s*git\s+reset\s+--hard\b'; then
  echo ""
  echo "╔════════════════════════════════════════════════════════════════════════╗"
  echo "║  [RoundTable] BLOCKED — Destructive Git Operation               ║"
  echo "╠════════════════════════════════════════════════════════════════════════╣"
  echo "║  git reset --hard is destructive and bypasses all safety gates. ║"
  echo "║  This operation permanently discards uncommitted changes.       ║"
  echo "║                                                                 ║"
  echo "║  Alternatives:                                                  ║"
  echo "║    git stash          Save changes temporarily                  ║"
  echo "║    git checkout -- .  Discard changes to tracked files only     ║"
  echo "║    /git sync          Governed sync with conflict handling      ║"
  echo "╚════════════════════════════════════════════════════════════════════════╝"
  echo ""
  exit 2
fi

# Block state-changing git operations
if echo "$COMMAND" | grep -qE '(^|;|&&|\|\|)\s*git\s+(push|commit|merge|rebase|pull)\b'; then
  echo ""
  echo "╔═════════════════════════════════════════════════════════════════════════╗"
  echo "║  [RoundTable] BLOCKED — Git Workflow Violation                   ║"
  echo "╠═════════════════════════════════════════════════════════════════════════╣"
  echo "║  Raw git state-changing commands are not allowed.                ║"
  echo "║  Use the /git skill instead:                                     ║"
  echo "║                                                                  ║"
  echo "║    /git status     Quick state overview: branch + divergence     ║"
  echo "║    /git commit     Governed commit: safety gates + 2-pass review ║"
  echo "║    /git pr         Governed PR: safety gates + review + tests    ║"
  echo "║    /git sync       Governed sync: upstream/origin merge/rebase   ║"
  echo "║    /git lookback   Retrospective: git + session metrics          ║"
  echo "║                                                                  ║"
  echo "║  Allowed without skill:                                          ║"
  echo "║    git status / log / diff / fetch / add / checkout              ║"
  echo "║    git branch / stash / show / remote / tag                      ║"
  echo "╚═════════════════════════════════════════════════════════════════════════╝"
  echo ""
  exit 2
fi

exit 0
