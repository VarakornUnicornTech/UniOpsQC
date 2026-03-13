---
name: team-start
description: Formal team kickoff. Logs session start, reads Phase Briefing, runs ZCB check, confirms Early Advance authorization. Use at the beginning of any phase execution.
---

# /team-start [Team] [Project] [Phase] [free|hold]

## Arguments

- `[Team]` — Team name: `Monolith`, `Syndicate`, `Arcade`, or `Overseer`
- `[Project]` — Project name (must match an entry in `ProjectEnvironment.md`)
- `[Phase]` — Phase number (e.g., `1`, `2`)
- `[free|hold]` — Early Advance authorization: `free` = Commander has authorized advancing to next phase when done; `hold` = team must wait for Commander before advancing

## Steps

1. **Log SESSION START:**
   - AM logs in RoundTable; sub-teams log in their Team Chat file.
   - Entry title: `[Team] Kickoff — [Project] Phase [N]`

2. **Read agent file:**
   - Read `.claude/agents/[team].md` and adopt team voice.

3. **Read Phase Briefing Mail:**
   - Path: `Development/01_Implementation Logs/INDEV v1.0.0/Phase [N]/[Team]_Phase[N]_Briefing.md`
   - If not found: report `[BLOCKED] Phase Briefing Mail missing for [Team] Phase [N]. Cannot proceed.`

4. **Run ZCB check (AM only — sub-teams skip):**
   - Verify no cross-team dependency blocks exist for this phase's tickets.
   - Perform inline check against the Briefing: confirm no ticket in this phase depends on an incomplete ticket from another team.

5. **Confirm Early Advance status:**
   - If `free`: log `Early Advance AUTHORIZED — team may proceed to Phase [N+1] upon completion without waiting for Commander.`
   - If `hold`: log `Early Advance ON HOLD — team must report to AM upon Phase [N] completion and await Commander authorization before advancing.`

6. **Output kickoff summary:**
   ```
   [Team] KICKOFF — [Project] Phase [N]
   Briefing: READ ✅
   ZCB: CLEAR ✅ (or BLOCKED ❌ with details)
   Early Advance: [AUTHORIZED / ON HOLD]
   Tickets: [list ticket IDs from Briefing]
   Ready to execute.
   ```

## Notes
- This skill may be invoked by Commander directly (Mode B) or by AM internally during Mode A orchestration
- Never begin ticket work before the Briefing is confirmed read
- If ZCB check finds a block, report to AM/Commander immediately — do not begin the blocked ticket
