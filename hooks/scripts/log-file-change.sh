#!/usr/bin/env bash
# RoundTable Hook: log-file-change
# Event: PostToolUse (Write|Edit)
# Purpose: Appends file change to today's session log for audit trail.
# Always exits 0 (logging should never block work).
#
# NOTE: Claude Code passes the tool input as the $TOOL_INPUT environment variable
# containing a JSON object. Parse with jq or string extraction.
#
# Windows: Requires Git Bash or WSL. Ensure bash is in PATH.

# Extract file_path from JSON input
if command -v jq &>/dev/null; then
  FILE_PATH=$(echo "$TOOL_INPUT" | jq -r '.file_path // empty' 2>/dev/null)
else
  FILE_PATH=$(echo "$TOOL_INPUT" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"//;s/"$//')
fi

# If we couldn't extract a path, skip logging
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

TODAY=$(date +%d-%m-%Y)
LOG_DIR="RoundTable"

# Skip logging for log files themselves (prevent recursion)
case "$FILE_PATH" in
  *RoundTable/*|*TeamChat/*|*OverseerReport/*)
    exit 0
    ;;
esac

# Find today's RoundTable file
LOG_FILE=$(ls "$LOG_DIR"/${TODAY}_RoundTable_Vol*.md 2>/dev/null | tail -1)

if [ -z "$LOG_FILE" ]; then
  LOG_FILE=$(ls "$LOG_DIR"/${TODAY}_RoundTable.md 2>/dev/null | head -1)
fi

if [ -n "$LOG_FILE" ]; then
  # Atomic append — write to temp file then append with a single redirect
  # This prevents partial writes from concurrent hook executions
  ENTRY=$(printf '\n> [Hook] File modified: `%s` at %s' "$FILE_PATH" "$(date +%H:%M:%S)")
  printf '%s' "$ENTRY" >> "$LOG_FILE"
fi

exit 0
