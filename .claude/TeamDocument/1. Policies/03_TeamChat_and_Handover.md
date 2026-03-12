# §3 — Team Chat, OverseerReport & HandOver Standards

> **Policy reference file.** Loaded on-demand from `.claude/TeamDocument/1. Policies/`. Core rules live in CLAUDE.md.

---

## Cross-Team Protocol

### Team Chat (Inter/Intra Team Communication)

Each team has a **daily log file** (like RoundTable) in their team-specific subfolder:

**Location:** `.claude/TeamDocument/2. TeamChat/[N]. [TeamName]/`

**Directory Structure:**
```
TeamDocument/2. TeamChat/
├── 1. Monolith/
│   ├── DD-MM-YYYY_Monolith.md         # Daily team log (like RoundTable)
│   └── HandOver/                      # Cross-team handoffs (non-Overseer)
│       └── [NUMBER]. [REFER_TEAM_NAME]_[WORK_TITLE]_DD-MM-YYYY.md
├── 2. Syndicate/
│   ├── DD-MM-YYYY_Syndicate.md
│   └── HandOver/
│       └── [NUMBER]. [REFER_TEAM_NAME]_[WORK_TITLE]_DD-MM-YYYY.md
├── 3. Arcade/
│   ├── DD-MM-YYYY_Arcade.md
│   └── HandOver/
│       └── [NUMBER]. [REFER_TEAM_NAME]_[WORK_TITLE]_DD-MM-YYYY.md
└── 4. OverseerReport/                 # Shared daily roundtable for sub-team → Overseer reports
    └── DD-MM-YYYY_OverseerReport.md
```

**Team Daily Log Format:** `DD-MM-YYYY_[TeamName].md`

**Examples:**
- `2. Syndicate/09-02-2026_Syndicate.md`
- `3. Arcade/08-02-2026_Arcade.md`
- `1. Monolith/09-02-2026_Monolith.md`

**Rules:**
- Each team logs ALL internal discussions for that day in a single daily file (like RoundTable does)
- Multiple sessions/tasks on the same day go into the same daily file as separate sections
- Teams must **NOT** write directly to the RoundTable file — only AM/Overseer writes to RoundTable
- Team Conductors must also file a summary in `OverseerReport/` for AM to review
- AM (Principal Manager) reads these files to stay informed and present work to Commander

### Handoff Process

**Handoffs TO Overseer** go in `TeamDocument/2. TeamChat/4. OverseerReport/`:

**OverseerReport File Format:** `DD-MM-YYYY_OverseerReport.md`

**Rules:**
- This is a **shared daily roundtable** that any sub-team can write to
- All sub-team (Monolith, Syndicate, Arcade) reports/handoffs to Overseer go here
- Multiple teams writing on the same day append to the same daily file as separate sections
- AM reads this folder to stay informed and present work to Commander

---

**Handoffs BETWEEN sub-teams** go in the originating team's `HandOver/` subfolder:

**HandOver File Format:** `[NUMBER]. [REFER_TEAM_NAME]_[WORK_TITLE]_DD-MM-YYYY.md`

**Examples:**
- `Monolith/HandOver/01. Syndicate_APISchemaHandoff_08-02-2026.md`
- `Arcade/HandOver/01. Monolith_AssetList_09-02-2026.md`

**Steps:**
1. Originating team creates a handoff file in their `HandOver/` folder
2. File must include: task description, what was done, what remains, any blockers
3. `REFER_TEAM_NAME` is the sub-team receiving the handoff
4. Receiving team reads the handoff file before starting work

---

## Team Chat Daily Log Standard

A **Team Chat daily log** is the internal discussion record for one team on one day. All sessions and tasks that day go into a single file.

**File naming:** `DD-MM-YYYY_[TeamName].md`
**Location:** `TeamDocument/2. TeamChat/[TeamName]/DD-MM-YYYY_[TeamName].md`

**Mandatory structure:**

```markdown
# Team [Name] — DD-MM-YYYY

---

## Session [N] — [Title]
**Ticket:** [ID or "Internal"]
**Status:** [IN PROGRESS / COMPLETE / BLOCKED]

### [CONDUCTOR_CODE] ([Team] — Conductor)
"[Conductor opens: task assignment, context, any concerns]"

### [TECHNOLOGIST_CODE] ([Team] — Technologist)
"[Technical analysis, implementation plan, or findings]"

### [DESIGN_SCHOLAR_CODE] ([Team] — Design Scholar)
"[UX, schema, or structural observations — within scope only]"

### [VERIFICATION_SCHOLAR_CODE] ([Team] — Verification Scholar)
"[Test plan, acceptance criteria review, or sign-off]"

### Actions Taken
- [action] ✅
- [blocker filed] ⛔
```

**Rules:**
- Members speak **only** when the topic is within their field (Selective Response Rule)
- Conductor opens each session; other members contribute in order of relevance
- Multiple tasks on the same day are separate `## Session [N]` blocks in the same file
- The Conductor must also file a summary in `OverseerReport/` when a ticket completes or a blocker is raised

---

## OverseerReport Standard

The **OverseerReport** is the shared daily file where all sub-teams file their completed ticket reports and blockers for AM to review.

**File naming:** `DD-MM-YYYY_OverseerReport.md`
**Location:** `TeamDocument/2. TeamChat/OverseerReport/DD-MM-YYYY_OverseerReport.md`
**Rule:** Append to the existing daily file — do not create a new file per report.

**Each report entry format:**

```markdown
## [TeamName] — [Ticket ID]: [Title]
**Filed by:** [Conductor code]
**Date:** DD-MM-YYYY
**Status:** COMPLETE | BLOCKED | IN PROGRESS

### Summary
[What was built/done — 2–5 sentences. Technologist-level detail.]

### Acceptance Criteria
- [x] criterion 1
- [x] criterion 2
- [x] all [N] tests pass

### Blockers
None | [Description of blocker — what is needed to unblock]

### Next Step for AM
[What Overseer must do: authorize next ticket, review report, assign follow-up, etc.]

---
```

**Rules:**
- Only sub-teams (Monolith, Syndicate, Arcade) file here — Overseer does not self-report to OverseerReport
- The Conductor files the report; the Verification Scholar must confirm criteria are checked before filing
- For blockers: file immediately — do not wait for task completion
- AM reads this file to stay informed and determine what to present to Commander

---

## HandOver File Standard

A **HandOver** is a cross-team work transfer document filed by the originating team in their own `HandOver/` folder.

**File naming:** `[NUMBER]. [RECEIVING_TEAM]_[WorkTitle]_DD-MM-YYYY.md`
**Location:** `TeamDocument/2. TeamChat/[OriginatingTeam]/HandOver/`
Examples:
- `Monolith/HandOver/01. Syndicate_UIDSchemaHandoff_28-02-2026.md`
- `Arcade/HandOver/01. Monolith_AssetList_28-02-2026.md`

**Mandatory structure:**

```markdown
# [NUMBER]. [WorkTitle] → [Receiving Team]
**From:** [Originating Team]
**To:** [Receiving Team]
**Date:** DD-MM-YYYY
**Related Ticket(s):** [IDs or "None"]

---

## What Was Done
[Summary of completed work being handed over — 2–5 sentences]

## What Remains
[What the receiving team must do next — specific and actionable]

## Files Modified / Created
- `path/to/file` — [brief description]
- `path/to/other` — [brief description]

## Blockers / Risks
None | [Description of any risk the receiving team should know about]

## Notes for Receiving Team
[Any context, warnings, or constraints the receiving team needs before they start]
```

**Rules:**
- The originating team creates the HandOver file before marking their ticket Complete
- The receiving team reads the HandOver file before starting their dependent work
- HandOver files are never deleted — they form the cross-team audit trail

---

*Adopted from ClaudeTemplate — 11-03-2026. Adapted for RoundTable: AM naming, Windows paths.*
