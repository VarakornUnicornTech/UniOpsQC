# /git

## Purpose
Unified governed version control command. All git operations pass through safety gates and code review before executing. Sub-commands: `status`, `commit`, `pr`, `sync`, `lookback`.

## Usage
```
/git <action> [options]

Actions:
  status     Quick git state overview — branch, divergence, working tree
  commit     Governed commit — safety gates, review, ticket gate, commit
  pr         Governed PR — safety gates, review, test, push, pull request
  sync       Governed sync — fetch upstream/origin, compare, merge/rebase
  lookback   Retrospective — rebase-aware metrics + decision audit
  help       Print usage reference — flags, examples, all sub-commands
```

## Arguments
- `$ARGUMENTS[0]` — Action: `status`, `commit`, `pr`, `sync`, `lookback`, or `help`
- `$ARGUMENTS[1]` — Target (branch, remote, or period — depends on action)
- `$ARGUMENTS[2]` — Secondary target (branch for sync, date range for lookback)
- Flags: `--skip-review`, `--skip-tests`, `--draft`, `--full`, `--strict`, `--compare`, `--dry-run`, `--force`

## Dispatch

Parse `$ARGUMENTS`. The first word is the action (default `status` if empty). Route to the relevant section below.

---

## Help

If `$ARGUMENTS` is `help`, print this block and STOP:

```
/git — Governed Version Control

SYNTAX:
  /git [action] [options]

ACTIONS:
  status                    Read-only state overview (default if no action given)
  commit [flags]            Safety gates → review → ticket gate → commit
  pr [flags]                Safety gates → review → tests → push → create PR
  sync [remote] [branch]    Governed upstream/origin merge with conflict walkthrough
  lookback [period]         Retrospective — rebase-aware git + RoundTable session metrics
  help                      Print this usage reference

FLAGS:
  --skip-review             Skip 2-pass code review (commit only)
  --dry-run                 Preview what would happen without executing
  --force                   Override branch protection (commit/sync only, always logged)
  --skip-tests              Acknowledge no tests ran (pr only)
  --draft                   Create PR as draft (pr only)
  --full                    Enable full cross-layer trace B6 (commit, pr)
  --strict                  INFORMATIONAL findings also block (commit, pr)
  --compare                 Compare with previous retrospective snapshot (lookback)

EXAMPLES:
  /git                      Show current git status
  /git status               Same as above
  /git commit               Full review + commit
  /git commit --skip-review Quick commit without code review
  /git commit --dry-run     Run all checks, show what would be committed, stop
  /git pr                   Full review + push + create PR
  /git pr --draft           Create a draft PR
  /git sync                 Sync current branch with its tracking remote
  /git sync upstream        Merge upstream/main into current branch
  /git sync upstream dev    Merge upstream/dev into current branch
  /git lookback             Show git metrics for current session
  /git lookback 14d         Show metrics for last 14 days
  /git help                 Show this help text
```

---

## Safety Gates (run FIRST for all state-changing actions)

Every action that modifies git state (`commit`, `pr`, `sync`) begins with these gates.
`status` and `lookback` are read-only — they skip safety gates entirely.

### S1. Working Tree Check
```
git status --porcelain

If working tree has uncommitted changes AND action is `sync`:
  → Warn: "Working tree has uncommitted changes. Stash or commit before syncing."
  → Abort unless --force flag (which auto-stashes).

If action is `commit` or `pr`:
  → Working tree changes are expected (about to be committed). Proceed.
```

### S2. Branch Protection Gate
```
CURRENT_BRANCH=$(git branch --show-current)

Protected branches: main, master

If CURRENT_BRANCH is protected:
  If action is `commit` and NO --force flag:
    → ABORT: "Committing directly to $CURRENT_BRANCH is not allowed.
       Create a feature branch first: git checkout -b feat/<name>"

  If action is `pr`:
    → ABORT: "Cannot open PR from $CURRENT_BRANCH.
       PRs must come from a feature branch (feat/, fix/, docs/, refactor/)."
    → No --force override for this gate.

  If action is `commit` and --force flag:
    → WARN + LOG: "Commander override: committing to protected branch $CURRENT_BRANCH"
    → Proceed with explicit acknowledgment logged.
```

### S3. Remote Detection
```
List remotes: git remote -v

ORIGIN=$(git remote get-url origin 2>/dev/null)
UPSTREAM=$(git remote get-url upstream 2>/dev/null)

Log: "Remotes: origin=[url], upstream=[url or 'not configured']"

If upstream exists AND action is `commit` or `pr`:
  → Fetch upstream silently for divergence awareness in B3.
```

### S4. Sensitive File Scan
```
Applies to: commit, pr (before staging)

Scan changed files (git diff --name-only + git ls-files --others --exclude-standard) for:
- .env, .env.*, *.env
- *credential*, *secret*, *key* (in filenames)
- *.pem, *.key, *.p12, *.pfx
- id_rsa, id_ed25519, *.ppk

If any found in changed files:
  → WARN: "Sensitive files detected in working tree:
     - [list files]
     These will NOT be staged unless --force is used."
  → Exclude from staging by default.
  → If --force: stage them but LOG the override.
```

**After safety gates pass → proceed to action-specific steps.**

---

## Review Baseline (runs for `commit` and `pr` only)

### B1. Auto-Detect Destination
```
DESTINATION="${ARGUMENTS[1]}"

If DESTINATION is empty:
  If branch 'dev' exists locally or on origin:
    DESTINATION="dev"
  Else:
    DESTINATION="main"

Log: "Destination branch: $DESTINATION"
```

### B2. Fetch + Rebase
```
git fetch origin # git-skill-internal

BEHIND=$(git rev-list --count HEAD..origin/$DESTINATION 2>/dev/null || echo "0")

If BEHIND > 0:
  Log: "$BEHIND commits behind origin/$DESTINATION — rebasing."
  git rebase origin/$DESTINATION # git-skill-internal

  If rebase conflict:
    → List conflicting files
    → For each file: show conflict zone summary (ours vs theirs)
    → Options:
      (a) Guide through resolution file-by-file
      (b) Abort rebase: git rebase --abort # git-skill-internal
    → If resolved: git rebase --continue # git-skill-internal
    Log: "Rebased onto origin/$DESTINATION at [commit hash]"
Else:
  Log: "Already up to date with origin/$DESTINATION"
```

### B3. Upstream Divergence Check
```
If upstream remote is configured (detected in S3):
  git fetch upstream # git-skill-internal
  UPSTREAM_BEHIND=$(git rev-list --count HEAD..upstream/$DESTINATION 2>/dev/null || echo "0")

  If UPSTREAM_BEHIND > 0:
    → WARN: "Branch is $UPSTREAM_BEHIND commits behind upstream/$DESTINATION.
       Consider running '/git sync upstream' before shipping."
    → Advisory only — does not block. Logged in output.
```

### B4. Diff Compare Check
```
git diff $DESTINATION...HEAD --stat
git diff $DESTINATION...HEAD

If diff is empty → "No changes vs $DESTINATION." and exit.
Log: files changed, lines added/removed.
```

### B5. Two-Pass Review
```
Load checklists from ${CLAUDE_SKILL_DIR}/checklists/:
- critical.md → Pass 1 (CRITICAL — blocking)
- informational.md → Pass 2 (INFORMATIONAL — advisory)
- suppressions.md → Known false positives to filter

Pass 1 — CRITICAL (blocking):
For each changed file, check against critical.md patterns.

Pass 2 — INFORMATIONAL (advisory):
For each changed file, check against informational.md patterns.

Apply suppressions: filter out matches per suppressions.md.

Each finding: file, line, category, severity, description.
```

### B6. Cross-Layer Trace (with --full flag only)
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

## Action: `status`

Quick read-only overview. No safety gates, no baseline.

### Steps
```
1. Branch + last commit:
   git branch --show-current
   git log -1 --oneline --decorate

2. Working tree state:
   git status --short
   Count: staged, modified, untracked files.

3. Divergence vs origin:
   git fetch origin --quiet # git-skill-internal
   git rev-list --left-right --count origin/$CURRENT_BRANCH...HEAD 2>/dev/null
   → Report: N ahead, M behind origin

4. Divergence vs upstream (if remote exists):
   git fetch upstream --quiet # git-skill-internal
   UPSTREAM_DEFAULT=$(git remote show upstream 2>/dev/null | sed -n 's/.*HEAD branch: //p')
   git rev-list --left-right --count upstream/$UPSTREAM_DEFAULT...HEAD 2>/dev/null
   → Report: N ahead, M behind upstream

5. Recent commits:
   git log -5 --oneline --decorate
```

### Output Format
```markdown
## Git Status

| Property | Value |
|----------|-------|
| **Branch** | [current branch] |
| **Last commit** | [hash] [message] |
| **Working tree** | [N staged, M modified, K untracked] or Clean |
| **vs origin/[branch]** | [N ahead, M behind] or Up to date |
| **vs upstream/[branch]** | [N ahead, M behind] or N/A |

### Recent Commits
[last 5 commits with decoration]

### Working Tree Changes
[git status --short output, or "Clean — nothing to commit"]
```

---

## Action: `commit`

Governed commit with safety gates, review, and audit trail.

**Flow:** Safety Gates (S1–S4) → Review Baseline (B1–B6) → Commit Steps (C1–C5)

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
If --skip-review flag → skip this gate entirely (log that review was skipped).
```

### C3. Stage + Commit
```
# Stage all changes, respecting S4 sensitive file exclusions
git add -A # git-skill-internal

# If S4 flagged sensitive files, unstage them:
# git reset HEAD <sensitive-file> # git-skill-internal

# Show what will be committed
git diff --cached --stat # git-skill-internal

# If --dry-run: show summary and exit without committing.

# Create commit with RoundTable-standard message
git commit -m "$(cat <<'EOF'
[TICKET-ID] Brief description of changes

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)" # git-skill-internal
```

### C4. Post-Commit Verification
```
git log -1 --stat # git-skill-internal
Verify commit was created successfully.
If commit failed → report error, do not log success.
```

### C5. Log to RoundTable
```
Append to today's session file:
  ### Git Record — Commit
  - Branch: [branch]
  - Destination: [destination]
  - Ticket: [ticket-id]
  - Commit: [hash]
  - Review: [CLEAN / N findings]
  - Safety: [all gates passed / overrides logged]
  - Time: [timestamp]
```

### Output
Display commit hash, ticket ID, review summary, and any safety warnings.

---

## Action: `pr`

Full governed shipping pipeline — commit through to pull request.

**Flow:** Safety Gates (S1–S4) → Review Baseline (B1–B6) → PR Steps (P1–P8)

### P1. Branch Enforcement
```
If current branch is main, master, or dev:
  → ABORT: "Cannot open PR from $CURRENT_BRANCH.
     PRs must come from a feature branch (feat/, fix/, docs/, refactor/).
     Create one: git checkout -b feat/<name>"
  → No --force override for this gate. Hard block.

If branch doesn't have upstream tracking:
  → Will set during push (P6).
```

### P2. Ticket Verification (Governance Gate)
```
Same as C1. Scan Development/ for matching ticket.
If no ticket found → abort.
Log ticket ID for PR body.
```

### P3. Run Tests
```
Detect test command:
- package.json scripts.test → npm test
- Makefile test target → make test
- pytest.ini / setup.cfg → pytest
- Cargo.toml → cargo test
- go.mod → go test ./...

If no test command detected:
  → WARN: "No test suite detected. Proceeding without tests."
  → Log: "Tests: SKIPPED — no test suite found"

If --skip-tests flag:
  → Log: "Tests: SKIPPED — --skip-tests flag"

Otherwise: run detected test command.
If tests fail → abort with failure output.
Log test results for PR body.
```

### P4. Review Gate
```
If Pass 1 found any CRITICAL findings → abort with findings list.
INFORMATIONAL findings included in PR body as advisory.
If --strict flag → INFORMATIONAL findings also block.
If --skip-review flag → skip this gate (log that review was skipped).
```

### P5. Commander Approval Check
```
Check if Commander Phase Acceptance Gate is ON for this project.
If ON → present summary and wait for explicit approval before pushing.
If OFF → proceed automatically.
```

### P6. Push
```
# Verify push target is not a protected branch
PUSH_TARGET=$(git rev-parse --abbrev-ref HEAD)

If PUSH_TARGET is main or master:
  → ABORT: "Refusing to push to $PUSH_TARGET. PRs merge into protected branches — never push directly."

# If --dry-run: show push target and exit without pushing.

git push -u origin HEAD # git-skill-internal
```

### P7. Create Pull Request
```
DESTINATION from B1 auto-detection.

gh pr create --base "$DESTINATION" --title "[TICKET-ID] Brief description" --body "$(cat <<'EOF'
## Summary
[Auto-generated from commit messages and ticket description]

## Ticket Reference
[Link to ticket file in Development/]

## Review Findings
[CRITICAL: 0 | INFORMATIONAL: N findings listed]

## Test Results
[Test command and pass/fail status, or "No test suite detected"]

## Cross-Layer Trace (if --full)
[Layer verification results]

## RoundTable Governance
- Rebased onto $DESTINATION: ✓
- Upstream divergence: [up to date / N behind — advisory]
- Ticket verified: ✓
- Tests: ✓ passed / skipped [reason]
- Review: ✓ completed / skipped
- Branch protection: ✓ (from feature branch)
- Sensitive file scan: ✓ [N excluded / clean]
- Commander approval: ✓ / not required

---
Shipped via `/git pr` — RoundTable governed pipeline
EOF
)"

If --draft flag → add --draft to gh pr create.
```

### P8. Log to RoundTable
```
Append to today's session file:
  ### Git Record — Pull Request
  - Branch: [branch] → [destination]
  - Ticket: [ticket-id]
  - PR: [PR URL]
  - Tests: PASS / SKIPPED [reason]
  - Review: [CLEAN / N informational findings]
  - Safety: [all gates passed / overrides]
  - Time: [timestamp]
```

### Output
Display the PR URL and a summary of what was shipped.

---

## Action: `sync`

Governed upstream/origin synchronization. Safely pulls in remote changes with conflict handling.

### Usage
```
/git sync                  — sync current branch with its origin tracking branch
/git sync upstream         — sync current branch with upstream's default branch
/git sync upstream dev     — sync current branch with upstream/dev specifically
```

**Flow:** Safety Gates S1 + S3 (working tree + remote detection) → Sync Steps (SY1–SY6)

S2 (branch protection) and S4 (sensitive file scan) are skipped — sync doesn't commit or stage.

### SY1. Determine Sync Source
```
SOURCE="${ARGUMENTS[1]:-origin}"
SOURCE_BRANCH="${ARGUMENTS[2]}"

If SOURCE == "upstream":
  If no upstream remote configured:
    → ABORT: "No upstream remote configured. Add with:
       git remote add upstream <url>"
  If SOURCE_BRANCH is empty:
    → Detect default branch: git remote show upstream | sed -n 's/.*HEAD branch: //p'
    → Use detected branch (typically 'main' or 'dev')
  SYNC_REF="upstream/$SOURCE_BRANCH"

Else (SOURCE == "origin" or default):
  TRACKING=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
  If no tracking branch:
    → ABORT: "No tracking branch set for current branch.
       Push first: git push -u origin HEAD"
  SYNC_REF="$TRACKING"
```

### SY2. Fetch + Divergence Report
```
git fetch $SOURCE # git-skill-internal

AHEAD=$(git rev-list --count $SYNC_REF..HEAD 2>/dev/null || echo "0")
BEHIND=$(git rev-list --count HEAD..$SYNC_REF 2>/dev/null || echo "0")

Present:
  "Sync source: $SYNC_REF
   Status: $AHEAD ahead, $BEHIND behind"

If BEHIND == 0:
  → "Already up to date with $SYNC_REF. Nothing to sync."
  → Exit.
```

### SY3. Show Incoming Changes
```
git log HEAD..$SYNC_REF --oneline --stat # git-skill-internal

Present: list of incoming commits and which files they touch.
Highlight files that overlap with local uncommitted or recent changes.
```

### SY4. Execute Sync
```
If --dry-run flag:
  → Present divergence report and incoming changes. Do not execute. Exit.

Strategy selection:
  If SOURCE == "upstream":
    → Use merge (preserves fork history, clear upstream integration points)
    git merge $SYNC_REF --no-edit # git-skill-internal
  Else (origin):
    → Use rebase (clean linear history on own branch)
    git rebase $SYNC_REF # git-skill-internal

If conflict:
  → List all conflicting files.
  → For each conflicting file, present:
    - File path
    - Conflict zone count
    - Summary: what "ours" changed vs what "theirs" changed
    - Options per file:
      (a) Accept ours — keep local version
      (b) Accept theirs — keep remote version
      (c) Manual — open for line-by-line resolution
      (d) Skip — leave conflicted (must resolve before continue)
  → After all files handled:
    If merge: git add <resolved> && git merge --continue # git-skill-internal
    If rebase: git add <resolved> && git rebase --continue # git-skill-internal
  → If user chooses abort at any point:
    git merge --abort OR git rebase --abort # git-skill-internal
    → Restore original state. Log: "Sync aborted — no changes applied."
```

### SY5. Post-Sync Verification
```
git log -5 --oneline --decorate # git-skill-internal

Verify:
- HEAD advanced correctly
- No leftover conflict markers in tracked files
- Branch state is clean

Report: strategy used, commits integrated, conflicts resolved (if any).
```

### SY6. Log to RoundTable
```
Append to today's session file:
  ### Git Record — Sync
  - Branch: [branch]
  - Source: [sync ref]
  - Strategy: merge / rebase
  - Commits pulled: [N]
  - Conflicts: [N resolved / 0]
  - Time: [timestamp]
```

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
DESTINATION: auto-detect per B1 logic.

Show how current branch relates to destination:
  git log $DESTINATION...HEAD --oneline
  git rev-list --left-right --count $DESTINATION...HEAD

Report: N commits ahead, M commits behind.
If behind → flag: "Branch is M commits behind $DESTINATION — consider /git sync."

If upstream remote exists:
  Also report divergence vs upstream.
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
| Behind upstream | N commits / N/A |

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

---

## Flags Reference

| Flag | Actions | Effect |
|------|---------|--------|
| `--skip-review` | commit, pr | Skip two-pass code review (logged) |
| `--skip-tests` | pr | Skip test execution (logged) |
| `--draft` | pr | Create PR as draft |
| `--full` | commit, pr | Enable cross-layer trace (B6) |
| `--strict` | commit, pr | INFORMATIONAL findings also block |
| `--compare` | lookback | Compare with previous retrospective snapshot |
| `--dry-run` | commit, pr, sync | Preview what would happen without executing |
| `--force` | commit, sync | Override branch protection (commit) or dirty-tree block (sync) — always logged |

---

## Bypass Marker

All git commands executed by this skill append `# git-skill-internal` as a comment. This marker tells the PreToolUse hook (`check-git-workflow.sh`) to allow the command. Raw git commands without this marker are blocked.

**This marker must NEVER be used outside of this skill file.** Any manual use of `# git-skill-internal` bypasses all safety gates and is a critical policy violation — logged with root cause.

---

## Notes

- **Internal bypass marker:** All git commands run by this skill append `# git-skill-internal` to bypass the `check-git-workflow.sh` PreToolUse hook. Raw git state-changing commands without this marker are blocked.
- **Branch naming convention:** Feature branches should follow `feat/`, `fix/`, `docs/`, `refactor/` prefixes. The `/git pr` action enforces this — PRs cannot be opened from `main`, `master`, or `dev`.
- **Destination default:** Auto-detects — uses `dev` if the branch exists, otherwise `main`. Override with explicit argument: `/git commit main`.
- **Upstream vs origin:** `origin` = your fork or primary remote. `upstream` = the source/parent repository. Use `/git sync upstream` to pull in upstream changes.
- **Protected branches:** `main` and `master` are protected. Direct commits are blocked unless `--force` is used (logged). PRs from protected branches are always blocked (no override).
- **Sensitive files:** `.env`, `*.key`, `*.pem`, `credentials.*`, `*secret*`, `*.pfx`, `*.p12`, `*.ppk`, `id_rsa`, `id_ed25519` are excluded from staging by default. Use `--force` to include (logged).
- **Conflict resolution:** Sync and rebase conflicts trigger a guided walkthrough — not just an abort. Each file gets individual resolution options.
- **Logging:** Every `/git` action logs to RoundTable (Overseer) or Team Chat (sub-teams) as a `### Git Record` entry.

---

## Rules

- **All state-changing git operations go through this skill.** No raw `git commit`, `git push`, `git merge`, `git rebase`, `git pull`, or `git reset --hard`.
- **Safety gates are non-negotiable.** S1–S4 run before every state-changing action.
- **Branch protection cannot be overridden for PRs.** Only commits allow `--force` on protected branches.
- **Sensitive files are never committed.** S4 auto-excludes them.
- **Conflicts are resolved, not aborted.** The conflict walkthrough guides resolution file-by-file.
- **Every override is logged.** Force commits, test skips, and branch protection overrides are recorded in session logs.
- **Upstream awareness is always active.** If an upstream remote exists, divergence is reported on every commit and PR.
