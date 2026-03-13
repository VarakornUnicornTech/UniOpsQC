#!/usr/bin/env bash
# RoundTable Hook: verify-tests-exist
# Event: PostToolUse (on task completion patterns)
# Purpose: Checks if test files were created/modified alongside implementation.
# Warns if implementation files changed but no test files touched.
# Exit 0 = allow (warning only), Exit 2 = block (strict mode)

# Check git diff for recently modified files
IMPL_FILES=$(git diff --name-only HEAD 2>/dev/null | grep -E '\.(ts|js|py|go|rs|java)$' | grep -v '\.test\.' | grep -v '\.spec\.' | grep -v '__tests__' | grep -v '/test/' | wc -l)
TEST_FILES=$(git diff --name-only HEAD 2>/dev/null | grep -E '(\.test\.|\.spec\.|__tests__|/test/)' | wc -l)

if [ "$IMPL_FILES" -gt 0 ] && [ "$TEST_FILES" -eq 0 ]; then
  echo "[RoundTable] WARNING: $IMPL_FILES implementation file(s) modified but no test files touched."
  echo "RoundTable policy requires tests for every ticket. Consider adding tests."
  # Warning only — change to exit 2 for strict enforcement
fi

exit 0
