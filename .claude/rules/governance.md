---
description: "Core governance rules: plan-before-implementation, no-code-before-ticket, phase gates, tickets, briefings, development structure"
---

# Governance Rules
> Covers §2 (Tickets & Briefings) + §4 (Development Structure)

---

## Plan-Before-Implementation (CRITICAL)
1. Create a plan document FIRST in the appropriate Development folder
2. Wait for explicit Commander confirmation before implementing
3. Never implement without approval — no matter how simple

## No-Code-Before-Ticket (ABSOLUTE)
No code change — not a single line — until its ticket exists in Development/.
Applies to ALL scenarios: live bugs, approved features, quick fixes, urgent issues.
Conductor must halt and create the ticket first. Violations logged with root cause.

Enumerated scenarios:
- Bug discovered during live testing → HALT. Create ticket in `05_BugFixesLog/` first.
- Commander approves a feature verbally → HALT. Create ticket in `03_SubFeatures Implementation/` first.
- Quick one-line fix → HALT. Still needs a ticket. No exceptions.
- Urgent production issue → HALT. Create ticket, then fix.

**Only Commander can waive** this rule for a specific change — Conductor cannot self-waive.
**Verification step:** Before any Edit/Write tool call on source code, verify the ticket exists.

---

## Ticket File Standard (Mandatory Sections)
```
# [TicketID] — [Title]
**Phase:** [N]
**Team:** [TeamName]
**Status:** [ ] PENDING
**Complexity:** Simple | Medium | Complex
**Depends on:** [TicketIDs or "None"]
**Blocks:** [TicketIDs or "None"]

## Scope
[What this ticket delivers — be specific]

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]

## Boundaries
- Do NOT touch: [files/systems out of scope]

## Notes
[Additional context, Commander direction, links]
```

## Ticket Status Values
| Symbol | Status | Meaning |
|--------|--------|---------|
| `[ ]` | PENDING | Not started |
| `[~]` | IN PROGRESS | Work underway |
| `[x]` | Complete | Delivered and verified |
| `[!]` | BLOCKED | Cannot proceed — blocker documented |
| `[>]` | DEFERRED | Moved to future phase — target phase noted |

Tickets are NEVER deleted. Status changes are the only modification allowed.

---

## Briefing Mail Standard (7 mandatory sections)
Path: `Development/01_Implementation Logs/INDEV v1.0.0/Phase [N]/[TeamName]_Phase[N]_Briefing.md`
One Briefing per team per phase. Briefings live at Phase root (not in team subfolders).

```
# [TeamName] — Phase [N] Briefing

## 1. Pre-Work: Load Your Roster
Read `.claude/agents/[team].md`. Adopt voice.

## 2. Context
[Fixed decisions from prior phases, upstream dependencies, architecture calls by MT]

## 3. Your Mission
[What this phase produces. Output locations. Definition of done.]

## 4. Tickets
### [TicketID] — [Title]
- File path: [where the deliverable goes]
- What to do: [step-by-step]
- Acceptance criteria: [checkboxes]

## 5. Parallel Execution — Start Now vs. Wait
- Start immediately: [ticket IDs with no dependencies]
- Wait for signal: [ticket IDs waiting on dependency signal from other team]

## 6. Logging and Handoff Requirements
- Log all work in Team Chat
- File OverseerReport on completion
- If handing work to another team: create HandOver file

## 7. Boundaries — Do NOT Touch
- [Files/systems explicitly out of scope]
- If you hit a blocker: file in OverseerReport, do NOT attempt workarounds
```

## Team Kickoff Message Standard
Commander kickoff message per team includes: team name, phase, ticket scope,
Commander direction, Early Advance authorization (free/hold).

## Phase Dispatch Report
Required before any team begins work. AM presents to Commander:
- Active Teams table (team → ticket scope → Early Advance auth)
- How to Kick Off Each Team (Mode A subagent spawn or Mode B separate session)
- ZCB Status (pass/fail + any redesigns needed)

---

## UX Smoke Test Gate (user-facing tickets)
Manual UX smoke test by **Verification Scholar** (NOT Technologist) before marking Complete.
- Happy path + at least one failure path
- Results logged in ticket as table: `| Step | Action | Expected | Actual | PASS/FAIL |`
- FAIL blocks Complete — re-test after fix
- Re-test covers original failure path + regression on happy path

## User Journey Walkthrough (before phase completion)
Full E2E walkthrough chaining ALL delivered tickets in the phase.
- User actions only ("Click X", "Enter Y") — never code-level ("call handleX()")
- Step format: `| Step | Action | Expected | Actual | PASS/FAIL |`
- Any single FAIL blocks phase completion
- File: `Development/.../Phase [N]/UserJourney_Phase[N]_[DD-MM-YYYY].md`
- Conductor files OverseerReport with walkthrough result

## Commander Phase Acceptance Gate (toggleable — OFF by default)
AM asks Commander at every Phase Dispatch: "Do you want to test this phase before we advance?"
- When ON: no phase advance until COMMANDER-ACCEPTED
- Verdict: ACCEPTED (advance) or REJECTED (specific issues listed → fix → re-test)
- Result logged in RoundTable session entry

## Silent Failure = CRITICAL Bug
Any operation that fails silently (no error, no warning, no log, no user feedback) = CRITICAL severity.
Every failure MUST produce observable feedback:
- **User-facing:** error message explaining what failed, why, and what to do
- **Developer-facing:** log entry with error details, stack context, affected state
- Bad: `if (!x) return;` (silent) — Good: `if (!x) { showError("X failed because..."); return; }`
"Nothing happens" is never acceptable.

## Hotfix Regression Gate
Every bug fix MUST include a test case reproducing the original bug.
Test must fail before fix, pass after. Test is permanent — never deleted.
Location: `Development/09_TestCase/_regression/`

## Early Phase Advance — Commander Gate
Team completing all Phase N tickets may NOT advance to Phase N+1 on own initiative.
Must file OverseerReport, enter wait state, and wait for Commander's explicit authorization.
Conductor does NOT have this authority — only Commander does.

## Zero Cross-Team Block (ZCB) Guarantee — HARD RULE
No team may have a ticket blocked waiting on another team's output within same phase.
Conductor runs ZCB check before dispatching every phase briefing.
Any remaining cross-team block = design error — reassign ownership before dispatch.

---

## Development Folder Structure (§4)

### Planning-First Workflow
| Commander's Request | Destination Folder |
|--------------------|-------------------|
| "Fix bug in X" | `05_BugFixesLog/[FeatureName]/` |
| "Add feature X" | `03_SubFeatures Implementation/` |
| "Modify/expand X" | `04_Modification Logs/[FeatureName]/` |
| "Document X" | `02_FeatureDescription/[FeatureName]/` |

### Canonical Folder Tree
```
Development/[ProjectName]/
├── 01_Implementation Logs/INDEV v1.0.0/Phase [N]/
├── 02_FeatureDescription/[FeatureName]/
├── 03_SubFeatures Implementation/
├── 04_Modification Logs/[FeatureName]/
├── 05_BugFixesLog/[FeatureName]/
├── 06_InstallationGuide/        # Setup and deployment docs
├── 07_TechnicalDebt/            # Flagged shortcuts requiring Commander sign-off
├── 08_AuditReport/              # Audit findings (mandatory, naming convention enforced)
├── 09_TestCase/                 # Test plans + _regression/ subfolder
│   └── _regression/             # Permanent regression tests
└── PreExisting TechStack/       # L1/L2/L3 scan documentation
```

### ProjectEnvironment.md Standard
Location: `.claude/ProjectEnvironment.md` — check BEFORE constructing any Development path.
Declares: active mode, project root paths, source code locations.

Two modes:
- **Centralized** — planning and source share same root (greenfield / solo)
- **Decentralized** — planning hub and source code fully separated (pre-existing codebases)

Format includes: `ACTIVE_PROJECTS` list, per-project `PROJECT_ROOT`, `SOURCE_ROOT`, `MODE`.

### State Transparency Rule
No silent no-ops. Every skipped operation must log WHY it was skipped.
Observable state: if a function decides not to act, it must emit a reason.
```
// Bad: if (!ready) return;
// Good: if (!ready) { log('[SKIP] Not ready because: ...'); return; }
```

### Error Code Catalog
Every project maintains `ErrorCatalog.md` in its Development folder.
- Error constants: `ERR_SUBSYSTEM_DESC` naming pattern
- Prefix ranges: `-1xxx` (auth), `-2xxx` (data), `-3xxx` (network), `-4xxx` (UI), `-5xxx` (system)
- Integer codes only — no string error codes

### Cross-Package Change Manifest
Multi-package changes require a manifest BEFORE implementation:
```
| Package | Files Changed | Interface Impacts | Breaking? |
```
TechStack update is a blocker — cannot merge without updating `Current TechStack.md`.

### Living Documentation Rule
`Current TechStack.md` updated in the same session as code changes.
Verification Scholar checks currency as sign-off requirement.
Missing documentation entry = ticket not Complete.

### 09_TestCase
Mandatory folder in every Development directory.
- Test plans and documentation stored here
- Executable test code lives in source tree (not in Development)
- `_regression/` subfolder for permanent regression tests
- Verification Scholar owns and maintains the test index
