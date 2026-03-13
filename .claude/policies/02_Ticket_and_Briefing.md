# §2 — Ticket, Briefing & Phase Dispatch Standards

> **Policy reference file.** Loaded on-demand from `.claude/TeamDocument/1. Policies/`. Core rules live in CLAUDE.md.

---

## Phase Dispatch Report (AM → Commander ท่านผู้บัญชาการ)

When AM opens a phase, AM **must present a Phase Dispatch Report to Commander ท่านผู้บัญชาการ** before any team begins work. This tells Commander ท่านผู้บัญชาการ exactly which teams are active and how to address each one.

**When to present:** Immediately after all phase briefings are written and ZCB-checked — before Commander ท่านผู้บัญชาการ sends any kickoff message.

**Format:**

```markdown
## Phase [N] — [Phase Name] — Dispatch Report
**Issued by:** AM | **Date:** DD-MM-YYYY | **Project:** [Name]

### Active Teams This Phase
| Team | Conductor | Tickets | Start Status |
|------|-----------|---------|--------------|
| Monolith | AT | MON-01 to MON-XX | [DONE] All start immediately |
| Syndicate | DR | SYN-01 to SYN-XX | [DONE] All start immediately |
| Arcade | CP | ARC-01 to ARC-XX | [DONE] Scaffolding with mocks |

*(Teams not listed have no tickets this phase.)*

### How to Kick Off Each Team
Send one message per team in a new session. Use the exact format below — copy and fill in:

**Monolith:**
> You are Team Monolith. Roster: `[PROJECT_ROOT]/.claude/agents/monolith.md` — Briefing: `[PROJECT_ROOT]/Development/01_Implementation Logs/INDEV v1.0.0/Phase [N]/Monolith_Phase[N]_Briefing.md` — Load your roster, read your briefing, and begin implementation.

**Syndicate:**
> You are Team Syndicate. Roster: `[PROJECT_ROOT]/.claude/agents/syndicate.md` — Briefing: `[PROJECT_ROOT]/Development/01_Implementation Logs/INDEV v1.0.0/Phase [N]/Syndicate_Phase[N]_Briefing.md` — Load your roster, read your briefing, and begin implementation.

**Arcade:**
> You are Team Arcade. Roster: `[PROJECT_ROOT]/.claude/agents/arcade.md` — Briefing: `[PROJECT_ROOT]/Development/01_Implementation Logs/INDEV v1.0.0/Phase [N]/Arcade_Phase[N]_Briefing.md` — Load your roster, read your briefing, and begin implementation.

### ZCB Status
All teams: [DONE] ZCB-clean — verified [date]
```

**Rules:**
- AM presents this report in the RoundTable session that dispatches the phase
- Commander ท่านผู้บัญชาการ should NOT send kickoff messages until AM has presented the Dispatch Report
- Commander ท่านผู้บัญชาการ only messages teams that appear in the "Active Teams" table — idle teams are not contacted
- The kickoff message format above is the official template — Commander ท่านผู้บัญชาการ can use it verbatim

---

## Briefing Mail Standard

A **Briefing Mail** is the official dispatch document AM uses to assign a phase or ticket block to a sub-team. It lives inside the **receiving team's subfolder** within `01_Implementation Logs/[VERSION]/Phase [N]/` — alongside that team's tickets.

**File naming:**
```
[TeamName]_Phase[N]_Briefing.md
[TeamName]_Phase[N]_[Descriptor]_Briefing.md   ← for mid-phase dispatches
```

**Examples:**
- `Monolith_Phase0_Briefing.md`
- `Syndicate_Phase0_Briefing.md`
- `Arcade_Phase7_Briefing.md`
- `Monolith_Phase1_RoleExpansion_Briefing.md`

**Location:**
```
01_Implementation Logs/[VERSION]/Phase [N]/[TeamName]_Phase[N]_Briefing.md
```

**Full path example:**
```
Development/01_Implementation Logs/INDEV v1.0.0/Phase 1/Monolith_Phase1_Briefing.md
Development/01_Implementation Logs/INDEV v1.0.0/Phase 1/Syndicate_Phase1_Briefing.md
```

**Note:** Briefings live at the Phase root level, NOT inside team subfolders. Team subfolders contain only ticket files. This keeps the briefing visible immediately when the phase folder is opened, regardless of how many tickets are inside the team subfolders.

**Mandatory sections (in this order):**

```
# Team [Name] — [Phase] Briefing
Issued by: AM | Date: DD-MM-YYYY | Project: [Name] | Phase: [N] | Tickets: [list]

## 0. Pre-Work: Load Your Roster
  - Read CLAUDE.md
  - Read Team Roster file
  - Adopt voice, code names, coding style
  - Create today's Team Chat log

## 1. Context
  - What has already been decided (decisions the team must not re-open)
  - Dependencies completed upstream

## 2. Your Mission
  - What this phase/ticket block produces
  - Output location(s)

## 3. Ticket [ID] — [Name]   (one section per ticket)
  - Ticket file path
  - What to do (step-by-step where needed)
  - Important notes / warnings
  - Acceptance criteria (mirrored from ticket file)

## 4. Parallel Execution — Start Now vs. Wait
  - Tickets this team starts IMMEDIATELY (no cross-team dependency)
  - Tickets BLOCKED on another team, and exactly which ticket/team unblocks them
  - Note: begin all unblocked tickets now; scaffold blocked tickets with mocks if applicable

## 5. Logging & Handoff Requirements
  - Team Chat log location
  - OverseerReport filing instructions (append if file exists)
  - Dependency Signal: when a ticket others depend on completes, include the Dependency Signal block in OverseerReport
  - Ticket status update instructions

## 6. Boundaries — Do NOT Touch
  - Explicit list of what this team must not modify

## 7. If You Hit a Blocker
  - Stop and file a blocker in OverseerReport — do not workaround without AM sign-off

Footer: Issued by AM (Overseer) — DD-MM-YYYY
```

**Rules:**
- One briefing file per team per phase (or per major dispatch if mid-phase)
- Briefings are written by AM (Overseer) only
- The briefing is the single source of truth for the team — if it contradicts a ticket, the briefing wins and AM must be notified to reconcile
- Briefings are never deleted after dispatch — they form part of the project record

---

## Team Kickoff Message Standard (Commander ท่านผู้บัญชาการ → Team)

The **Team Kickoff Message** is what Commander ท่านผู้บัญชาการ sends to a team session to start their work. It is a single message containing three things: team identity, roster path, and briefing path.

**Official template (copy verbatim, fill in [N] and [PROJECT_ROOT]):**

```
You are Team [Monolith / Syndicate / Arcade].
Roster: [PROJECT_ROOT]/.claude/agents/[monolith / syndicate / arcade].md
Briefing: [PROJECT_ROOT]/Development/01_Implementation Logs/INDEV v1.0.0/Phase [N]/[Monolith / Syndicate / Arcade]_Phase[N]_Briefing.md
Load your roster, read your briefing, and begin implementation.
```

> **Note:** Replace `[PROJECT_ROOT]` with the actual project path before pasting. Find the correct path in `.claude/ProjectEnvironment.md → PROJECT_ROOT`.

**Rules:**
- Commander ท่านผู้บัญชาการ sends one kickoff message per team in a **new, separate session** for each team
- Commander ท่านผู้บัญชาการ only kicks off teams listed in the Phase Dispatch Report's "Active Teams" table
- AM provides the filled-in kickoff messages in the Phase Dispatch Report — Commander ท่านผู้บัญชาการ copies them directly
- Do not add extra context or instructions to the kickoff message — the briefing contains everything the team needs

---

## Ticket File Standard

A **Ticket** is the detailed per-task spec for a single unit of work. It lives in the team subfolder alongside the briefing.

**File naming:** `[TEAM_PREFIX]-[NN]_[ShortName].md`
Examples: `MON-01_UIDSchemaAndStorage.md`, `SYN-02_RateLimiterMiddleware.md`

**Mandatory sections:**

```markdown
# [TEAM]-[NN] — [Title]

**Phase:** Phase [N] — [Phase Name]
**Team:** [TeamName] — [Team Subtitle]
**Status:** `[ ] PENDING` | `[~] IN PROGRESS` | `[x] Complete` | `[!] BLOCKED`
**Depends on:** [ticket IDs, or "None"]
**Blocks:** [ticket IDs, or "None"]

---

## Scope
[What this ticket produces — 2–4 sentences. No implementation detail, just the outcome.]

## Acceptance Criteria
- [ ] criterion 1
- [ ] criterion 2
- [ ] all tests pass

## Boundaries — Do NOT Touch
[What this team must NOT modify or own — explicit list]

## Notes
[Important warnings, migration concerns, security notes — omit section if none]
```

**Rules:**
- Status must be updated by the implementing team when work begins (`IN PROGRESS`) and completes (`Complete`)
- Acceptance criteria checkboxes are checked by the Verification Scholar, not the Technologist
- A ticket is only `Complete` when all criteria are checked AND the OverseerReport is filed
- Tickets are never deleted — completed tickets form the project history

---

## Ticket Status Values

| Symbol | Status | Meaning |
|--------|--------|---------|
| `[ ]` | PENDING | Not started |
| `[~]` | IN PROGRESS | Work has begun |
| `[x]` | Complete | All criteria met, tests pass, OverseerReport filed |
| `[!]` | BLOCKED | Cannot proceed — blocker filed in OverseerReport |
| `[>]` | DEFERRED | Intentionally scheduled for a later phase — not forgotten, not pending. Always include target phase in the status field (e.g., `[>] Deferred — scheduled pre-Phase 5 open`) |

---

## UX Smoke Test Gate (NEW — 12-03-2026)

> *Origin: SyncSpace Phase 3 — 100% test pass, every user-facing feature broken.*

**Every user-facing ticket MUST include a UX Smoke Test before Complete.**

1. **Performed by Verification Scholar** — not the implementing Technologist.
2. **Manual test** — exercises the feature as a real user would (click/type/see).
3. **Happy path + at least one failure path** required.
4. **Results logged in ticket** under `### UX Smoke Test` — table: `| # | Scenario | Steps | Expected | Actual | PASS/FAIL |`
5. **FAIL blocks Complete.** Technologist fixes, Verification Scholar re-tests.

---

## Mandatory User Journey Walkthrough (NEW — 12-03-2026)

> *Origin: SyncSpace tickets tested in isolation — pipeline broke E2E.*

**Before any phase is Complete, the Verification Scholar performs a full User Journey Walkthrough chaining ALL delivered tickets into one continuous flow.**

1. **One walkthrough per phase.** File: `[Phase N]/Phase[N]_UserJourney_Walkthrough.md`
2. **User actions only** — "Click Create Snapshot" not "call handleCreateSnapshot()".
3. **Each step records:** action, expected result, actual result, PASS/FAIL.
4. **Any FAIL blocks phase completion.** Fix → re-run from failing step.
5. **Conductor files walkthrough result in OverseerReport.**

---

## COMMANDER Phase Acceptance Gate (NEW — 12-03-2026, revised same day)

> *Origin: SyncSpace — 100% test pass, all user-facing features broken. COMMANDER never tested before advance.*

**Opt-in toggle.** OFF by default (standard Early Phase Advance per §7). ON when Commander ท่านผู้บัญชาการ declares "I will test Phase N before advance."

**When ON:** AM presents deliverables after all tickets Complete + User Journey Walkthrough passes. Commander ท่านผู้บัญชาการ tests as a user. Verdict: **ACCEPTED** (advance) or **REJECTED with issues** (fix + re-test). No Phase N+1 until COMMANDER-ACCEPTED. Logged in RoundTable under `### COMMANDER Phase Acceptance`.

**AM asks at every Phase Dispatch:** "Commander, do you want to personally test Phase N before advance?"

---

## Silent Failure = Critical Bug (NEW — 12-03-2026)

> *Origin: SyncSpace — multiple silent no-ops took hours to diagnose.*

**Any operation that fails silently (no error, no warning, no log, no user feedback) = CRITICAL severity, equivalent to a crash.**

1. **Every failure MUST produce observable feedback:** user-facing (popup/notification) or developer-facing (console.error/warn/`[DBG]`). At minimum: a log line.
2. **"Nothing happens" is never acceptable.** System MUST tell the user why.
3. **Error messages must include:** what failed, why, what to do. Example: `"Cannot create snapshot — no files are open. Open files first."` NOT: `"Snapshot failed."`

---

## Hotfix Regression Gate (NEW — 12-03-2026)

> *Origin: SyncSpace 70+ bugs, fixes creating new bugs, no regression tests.*

**Every bug fix MUST include a test case that reproduces the original bug. The test is permanent.**

1. **Write failing test FIRST** — must fail before fix, pass after.
2. **Committed alongside the fix** — atomic (same commit).
3. **Location:** `Development/09_TestCase/_regression/` (see §4). Named: `test_[bugId]_[shortDescription]`.
4. **Never deleted.** Archived if feature removed — not deleted.
5. **Verification Scholar confirms** fail-before/pass-after and signs off.

---

*Updated: 13-03-2026*
