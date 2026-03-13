#!/usr/bin/env bash
# RoundTable Hook: check-ticket-exists
# Event: PreToolUse (Write|Edit)
# Purpose: Enforces No-Code-Before-Ticket rule.
# Checks that a ticket file exists in Development/ before allowing code edits.
# Exit 0 = allow, Exit 2 = block
#
# NOTE: Claude Code passes the tool input as the $TOOL_INPUT environment variable
# containing a JSON object (e.g., {"file_path": "/path/to/file", ...}).
# Parse with jq or string extraction — do NOT treat as a plain file path.
#
# Windows: Requires Git Bash or WSL. Ensure bash and jq are in PATH.

# Extract file_path from JSON input
if command -v jq &>/dev/null; then
  FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty' 2>/dev/null)
else
  # Fallback: extract file_path with grep/sed if jq not available
  FILE_PATH=$(echo "$TOOL_INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')
fi

# If we couldn't extract a path, allow (don't block on parse failure)
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Skip non-source files (policies, docs, logs, configs, plans)
case "$FILE_PATH" in
  *.md|*.json|*.yml|*.yaml|*.txt|*.gitkeep|*.gitignore)
    exit 0
    ;;
  *Development/*|*RoundTable/*|*TeamChat/*|*TeamDocument/*|*.claude/*)
    exit 0
    ;;
esac

# Check if any Development directory exists with ticket files
DEV_DIR=$(find . -maxdepth 3 -type d -name "Development" 2>/dev/null | head -1)

if [ -z "$DEV_DIR" ]; then
  # No Development directory at all — allow (project may not use tickets yet)
  exit 0
fi

# Check for any IN PROGRESS or PENDING ticket files
TICKET_COUNT=$(grep -rl "\[~\]\|\[ \]" "$DEV_DIR" --include="*.md" 2>/dev/null | wc -l)

if [ "$TICKET_COUNT" -eq 0 ]; then
  echo "[RoundTable] WARNING: No active tickets found in $DEV_DIR. Code edits require a ticket."
  echo "Create a ticket first with /bug-report, /mod-log, or /sub-feature."
  # Warning only — not blocking (exit 0) for initial adoption
  # Change to exit 2 for strict enforcement
  exit 0
fi

exit 0
