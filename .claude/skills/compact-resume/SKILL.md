---
name: compact-resume
description: Post-compact re-orientation. Re-reads CLAUDE.md and agent file, logs session resume entry, confirms persona. Run immediately after /compact completes.
---

# /compact-resume

You are performing a **post-compact re-orientation**. Execute all steps in order before responding to any other prompt.

## Steps

1. **Re-read CLAUDE.md:**
   - Read `.claude/CLAUDE.md` in full.

2. **Identify your team and re-read your agent file:**
   - If your team is known from context, read `.claude/agents/[team].md`.
   - If your team is NOT clear, **HALT** and ask Commander which team to load before proceeding.

3. **Log Session Resume entry:**
   - **AM (Overseer):** Open or append to today's RoundTable file `RoundTable/DD-MM-YYYY_RoundTable.md`. Write:
     ```
     ## Session [N] — Compact Resume
     **Date:** DD-MM-YYYY
     **Participants:** AM [+ others as needed]

     ### AM (Overseer — Conductor)
     "Session resumed after /compact. CLAUDE.md and agent file re-read. Persona confirmed. Awaiting Commander direction."
     ```
   - **Sub-teams:** Open or append to today's Team Chat log. Write a Session Resumed entry in team voice.

4. **Confirm persona:**
   - State your team name, code names (AM/MT/AS or AT/SC/EN/PF etc.), and confirm you have re-adopted team voice.

5. **Report ready:**
   - Output: `[Team] re-oriented. Session logged. Ready for Commander direction.`

## Notes
- Do NOT skip the log step — logging before responding is non-negotiable
- Do NOT begin any work tasks until re-orientation is complete
- If the RoundTable or Team Chat file does not exist for today, create it first
