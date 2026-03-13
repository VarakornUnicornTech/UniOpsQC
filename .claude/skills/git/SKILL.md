# /git

## Purpose
Unified governed version control command. All git operations go through a common rebase + diff review baseline before executing. Sub-commands: `commit`, `pr`, `lookback`.

## Usage
```
/git <action> [options]

Actions:
  commit     Governed commit — rebase, review, commit
  pr         Governed pull request — rebase, review, test, PR
  lookback   Retrospective — rebase-aware metrics + decision audit
```

## Arguments
- `$ARGUMENTS[0]` — Action: `commit`, `pr`, or `lookback`
- `$ARGUMENTS[1]` — Target branch (optional, defaults to `main`)
- Flags: `--skip-review`, `--draft`, `--full`, `--strict`, `--compare`

---

## Common Baseline (runs FIRST for ALL actions)

Every sub-command begins with this identical sequence. No exceptions.

### B1. Fetch + Rebase
```
DESTINATION="${ARGUMENTS[1]:-main}"

git fetch origin
git rebase origin/$DESTINATION

If rebase conflict → abort with conflict list and resolution instructions.
Log: "Rebased onto origin/$DESTINATION at [commit hash]"
```

### B2. Diff Compare Check
```
git diff $DESTINATION...HEAD --stat
git diff $DESTINATION...HEAD

If diff is empty → "No changes vs $DESTINATION." and exit.
Log: files changed, lines added/removed.
```

### B3. Two-Pass Review
```
Load checklists from ${CLAUDE_SKILL_DIR}/checklists/:
- critical.md → Pass 1 (CRITICAL — blocking)
- informational.md → Pass 2 (INFORMATIONAL — advisory)
- suppressions.md → Known false positives to filter

Pass 1 — CRITICAL (blocking):
For each changed file, check for:
- SQL injection: raw string concatenation in queries
- Race conditions: shared mutable state without locks/mutexes
- XSS: unescaped user input in HTML output
- Auth bypass: missing authentication checks on protected routes
- LLM trust boundary: user input passed directly to system prompts
- Silent failures: catch blocks that swallow errors without logging
- Resource leaks: listeners/timers added without cleanup path
- Unvalidated input: external data used without validation at boundary

Pass 2 — INFORMATIONAL (advisory):
- Magic numbers without named constants
- Dead code (unreachable branches, unused imports)
- Missing test coverage for new functions
- Type coercion at system boundaries
- Conditional side effects (mutations inside conditionals)
- Performance: N+1 queries, unbounded loops
- Inconsistent error handling patterns

Apply suppressions: filter out type system guarantees, non-logic changes,
test patterns, and framework conventions per suppressions.md.

Each finding: file, line, category, severity, description.
```

### B4. Cross-Layer Trace (with --full flag)
```
For each changed file, verify the change is complete across all layers:
1. Identify which layer the changed file belongs to (handler, service, DB, client, types)
2. Trace the data/control flow from that layer outward
3. Check: does every layer that touches this interface reflect the change?
4. Flag any layer where the change is missing = potential gap bug

This catches bugs that diff-only review misses:
- Server adds a field but client doesn't read it
- Handler validates input but service doesn't
- DB schema changes but queries don't reflect it
```

**After baseline completes → proceed to action-specific steps below.**

---

## Action: `commit`

Governed commit with full audit trail.

### C1. Ticket Verification (Governance Gate)
```
Scan Development/ for a ticket matching this branch or feature name.
Look for: ticket file with status [~] IN PROGRESS or [x] Complete.
If no ticket found → abort with:
  "No ticket found for this branch. Create one with /bug-report, /mod-log, or /sub-feature first."
Log ticket ID.
```

### C2. Review Gate
```
If Pass 1 found any CRITICAL findings → abort with findings list.
INFORMATIONAL findings logged but do not block.
If --strict flag → INFORMATIONAL findings also block.
```

### C3. Commit
```
Stage all changes.
Create commit with RoundTable-standard message:
  "[TICKET-ID] Brief description of changes"
```

### C4. Log to RoundTable
```
Append to today's session file:
  ### Git Record — Commit
  - Branch: [branch]
  - Ticket: [ticket-id]
  - Commit: [hash]
  - Review: [CLEAN / N findings]
  - Time: [timestamp]
```

### Output
Display commit hash, ticket ID, and review summary.

---

## Action: `pr`

Full governed shipping pipeline — commit through to pull request.

### P1. Ticket Verification (Governance Gate)
```
Same as C1. Scan Development/ for matching ticket.
If no ticket found → abort.
Log ticket ID for PR body.
```

### P2. Run Tests
```
Detect test command:
- package.json scripts.test → npm test
- Makefile test target → make test
- pytest.ini / setup.cfg → pytest
- Cargo.toml → cargo test

Run detected test command.
If tests fail → abort with failure output.
Log test results for PR body.
```

### P3. Review Gate
```
If Pass 1 found any CRITICAL findings → abort with findings list.
INFORMATIONAL findings included in PR body.
If --strict flag → INFORMATIONAL findings also block.
If --skip-review flag → skip this gate entirely (log that review was skipped).
```

### P4. Commander Approval Check
```
Check if Commander Phase Acceptance Gate is ON for this project.
If ON → present summary and wait for explicit approval before pushing.
If OFF → proceed automatically.
```

### P5. Push
```
Push to origin with upstream tracking:
  git push -u origin HEAD
```

### P6. Create Pull Request
```
gh pr create --title "[TICKET-ID] Brief description" --body "$(cat <<'EOF'
## Summary
[Auto-generated from commit messages and ticket description]

## Ticket Reference
[Link to ticket file in Development/]

## Review Findings
[CRITICAL: 0 | INFORMATIONAL: N findings listed]

## Test Results
[Test command and pass/fail status]

## Cross-Layer Trace (if --full)
[Layer verification results]

## RoundTable Governance
- Rebased onto $DESTINATION: ✓
- Ticket verified: ✓
- Tests passed: ✓
- Review completed: ✓ / skipped
- Commander approval: ✓ / not required

---
Shipped via `/git pr` — RoundTable governed pipeline
EOF
)"

If --draft flag → add --draft to gh pr create.
```

### P7. Log to RoundTable
```
Append to today's session file:
  ### Git Record — Pull Request
  - Branch: [branch]
  - Destination: [destination]
  - Ticket: [ticket-id]
  - PR: [PR URL]
  - Tests: PASS
  - Review: [CLEAN / N informational findings]
  - Time: [timestamp]
```

### Output
Display the PR URL and a summary of what was shipped.

---

## Action: `lookback`

Governed retrospective — rebase-aware analysis of git history, session data, and project health.

### L1. Determine Time Range
```
PERIOD="${ARGUMENTS[1]:-7d}"

Parse period:
- "7d" → last 7 days
- "14d" → last 14 days
- "30d" → last 30 days
- "YYYY-MM-DD..YYYY-MM-DD" → explicit date range

Set $SINCE and $UNTIL for git and file scanning.
```

### L2. Branch Divergence (rebase-aware)
```
Show how current branch relates to destination:
  git log $DESTINATION...HEAD --oneline
  git rev-list --left-right --count $DESTINATION...HEAD

Report: N commits ahead, M commits behind.
If behind → flag: "Branch is M commits behind $DESTINATION — consider /git commit or /git pr."
```

### L3. Shipping Velocity (from git)
```
git log --since="$SINCE" --until="$UNTIL" --oneline --stat

Extract:
- Total commits
- Lines added / removed
- Files changed
- Unique committers
- Commits per day average
```

### L4. Session Activity (from RoundTable)
```
Scan RoundTable/*.md files within date range.
Extract:
- Total sessions logged
- Teams active (grep for team names in session headers)
- Decisions made (grep for "Decision:", "Approved:", "Architecture Decision")
- Tickets completed (grep for status changes to [x])
```

### L5. Commit Time Distribution
```
git log --since="$SINCE" --until="$UNTIL" --format="%aI"

Build hourly histogram of commit activity.
Identify peak productivity hours.
```

### L6. Session Detection
```
Analyze commit timestamps with 45-minute gap threshold.
Identify distinct coding sessions.
Calculate: session count, average duration, longest session.
Focus Score: % of commits in most-active directory.
```

### L7. Phase Progress (from Development/)
```
Scan Development/01_Implementation Logs/ for phase folders.
For each phase:
- Tickets with [ ] PENDING
- Tickets with [~] IN PROGRESS
- Tickets with [x] Complete
- Tickets with [!] BLOCKED
- Tickets with [>] DEFERRED
Calculate: phase velocity (tickets completed / days)
```

### L8. Bug Density (from Development/)
```
Scan Development/05_BugFixesLog/ within date range.
Extract:
- Bugs found / Bugs fixed
- Severity distribution
- Regression rate (bugs from fixes)
```

### L9. Decision Audit (from RoundTable)
```
Grep RoundTable session files for:
- "MT:" entries (architecture decisions by Technologist)
- "Commander" / "ACCEPTED" / "REJECTED" entries
- "BLOCKED" entries and their resolution
Produce decision timeline.
```

### L10. Team Contribution (from OverseerReport + git)
```
Scan OverseerReport files within date range.
Per team: tickets completed, files touched, review findings.
Cross-reference with git log for per-team commit counts.
```

### L11. AI Collaboration Metrics
```
git log --since="$SINCE" --grep="Co-Authored-By" --oneline | wc -l
Calculate: % of commits AI-assisted.
```

### L12. Snapshot and Compare
```
Save retro data as JSON snapshot to .roundtable/retros/retro-YYYY-MM-DD.json

If --compare flag:
- Load previous snapshot
- Calculate deltas for all metrics
- Highlight improvements and regressions
```

### Output Format
```markdown
# Lookback — [date range]

## Branch Status
| Metric | Value |
|--------|-------|
| Ahead of $DESTINATION | N commits |
| Behind $DESTINATION | M commits |

## Shipping Velocity
| Metric | Value |
|--------|-------|
| Commits | N |
| Lines added | +N |
| Lines removed | -N |
| Files changed | N |

## Session Activity
| Metric | Value |
|--------|-------|
| Sessions logged | N |
| Teams active | [list] |
| Decisions recorded | N |
| Tickets completed | N |

## Commit Time Distribution
[Hourly histogram]

## Phase Progress
| Phase | Pending | In Progress | Complete | Blocked |
|-------|---------|-------------|----------|---------|

## Bug Density
| Metric | Value |
|--------|-------|
| Bugs found | N |
| Bugs fixed | N |

## Decision Audit Trail
[Timeline of key decisions]

## Team Contributions
| Team | Tickets | Commits | Files |
|------|---------|---------|-------|

## Trends
[Period-over-period comparison if --compare]
```
