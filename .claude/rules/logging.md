---
description: "Session logging, RoundTable format, rotation, OverseerReport, handover protocol"
---

# Logging Rules
> Covers §1 (Logging & RoundTable) + §3 (TeamChat & Handover)

---

## Session Start (NON-NEGOTIABLE)
Conductor must open/append to daily RoundTable file and write `## Session [N] — [Title]`
BEFORE responding to any prompt. No exceptions. No minimum complexity threshold.

## Per-Interaction Logging
Every prompt + response = one logged session entry. No exceptions for "quick answers."

## All-Voices Rule
Team Overseer: AM (Conductor), MT (Technologist), AS (Design & Verification Scholar)
may all speak in a session. Each uses their own voice per `agents/overseer.md`.
AM does not speak for MT or AS. Sub-teams: same rule applies per their agent file.

**Selective Response Rule:** Members speak ONLY when the topic is within their field.
If unsure, write less — not more. A short in-character line beats a long out-of-character paragraph.

## Output Delivered Block (MANDATORY)
Every session entry must end with an **Output Delivered** section after Actions Taken:
```
### Output Delivered
- [Verbatim content: commands run, configs written, tables produced, code blocks]
- **Reason:** [Link output to Commander's intent — why this was delivered]
```
Without this, future sessions cannot reconstruct exact deliverables.

## Open Discourse Rule
Every team member may share conflicting views constructively:
1. State the concern clearly
2. Explain the risk
3. Propose an alternative
Commander has final authority — but the team ensures decisions are made with full information.

## Best Option Rule
Always recommend the best solution — not the quickest or most convenient.
"Best" means: highest quality, most secure, most maintainable.
If a "good enough" shortcut is proposed: flag as Technical Debt, require Commander sign-off,
log the trade-off explicitly. Discipline over convenience.

---

## RoundTable Rotation Policy
- Format: `DD-MM-YYYY_RoundTable_Vol[N].md`
- Soft limit: 400 lines — wrap up current session, start new volume at next session
- Hard limit: 500 lines — MUST start new volume immediately
- Session numbering is continuous across volumes (Vol1 Session 1-4, Vol2 Session 5-8, etc.)
- Old volumes are read-only historical records — never modify them
- Never split a single session across two volumes

**Context Overlay** (mandatory at top of every new volume):
```
## Context Overlay — Vol [N]
**Previous volume:** [filename of Vol N-1]
**Sessions so far:** [range, e.g., 1-12]
**Active work streams:** [what's in progress]
**Key decisions:** [major decisions from prior volumes]
**Pending items:** [unresolved blockers, waiting-for items]
```

**_Index.md** — Updated when new volume created:
```
| Date | Volume | File | Sessions | Key Topics |
|------|--------|------|----------|------------|
```

---

## Sub-Team Logging
Sub-teams log in TeamChat, NOT RoundTable. Only Overseer writes to RoundTable.

### Team Chat Daily Log Standard
- Location: `TeamDocument/2. TeamChat/[N. TeamName]/DD-MM-YYYY_[TeamName].md`
- File created at session start — one file per team per day
- Mandatory structure: Conductor speaks first, then role-labeled entries
- Sub-team persona rules, role labels, and speaking order cascade from RoundTable rules
- OverseerReport filing trigger: when any ticket reaches Complete or BLOCKED status

### OverseerReport
- Location: `TeamDocument/2. TeamChat/4. OverseerReport/DD-MM-YYYY_OverseerReport.md`
- Entry format:
```
## [TeamName]
### [TicketID] — [Title]
**Filed by:** [Conductor code name]
**Date:** DD-MM-YYYY
**Status:** COMPLETE | BLOCKED | IN PROGRESS

**Summary** (2-5 sentences, Technologist-level detail)
[What was done, how, key decisions]

**Acceptance Criteria**
- [x] [Criterion 1 — verified]
- [x] [Criterion 2 — verified]

**Blockers:** [None | description]
**Next Step for AM:** [What AM should do with this — present to Commander, assign follow-up, etc.]
```
- Filed by sub-team Conductor, verified by Verification Scholar

---

## HandOver File Standard
Cross-team handovers go in originating team's `HandOver/` subfolder.
File naming: `[NUMBER]. [REFER_TEAM_NAME]_[WORK_TITLE]_DD-MM-YYYY.md`

Mandatory fields and sections:
```
**From:** [Team]
**To:** [Team]
**Date:** DD-MM-YYYY
**Related Tickets:** [IDs]

## What Was Done
[Specific and complete — what was built/fixed/configured]

## What Remains
[Specific and actionable — exact next steps for receiving team]

## Files Modified
| File | What Changed |
|------|-------------|

## Blockers / Risks
[Any issues the receiving team should know about]

## Notes
[Additional context, links, caveats]
```

HandOver files are NEVER deleted — they form the cross-team audit trail.
