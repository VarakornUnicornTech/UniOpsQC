---
name: overseer-report
description: File an OverseerReport entry for a completed ticket or blocker. Used by sub-teams to report to AM. Provide ticket ID (e.g., /overseer-report MON-01).
---

# File OverseerReport Entry

Append a report entry to today's OverseerReport file following the RoundTable OverseerReport Standard.

## Steps

1. **Parse arguments:** `$1` = Ticket ID (e.g., MON-01) or "BLOCKER" for a blocker report.
2. **Determine today's date** in DD-MM-YYYY format.
3. **Locate or create** the OverseerReport file:
   ```
   .claude/TeamDocument/2. TeamChat/4. OverseerReport/DD-MM-YYYY_OverseerReport.md
   ```
   If the file doesn't exist, create it with a header: `# OverseerReport — DD-MM-YYYY`
4. **If ticket ID provided**, read the ticket file to get:
   - Team name
   - Ticket title
   - Acceptance criteria
5. **Determine the filing team** from the ticket prefix (MON→Monolith, SYN→Syndicate, ARC→Arcade).
6. **Read the appropriate agent file** (`.claude/agents/[monolith / syndicate / arcade].md`) to get the Conductor code name.
7. **Append the report entry:**

```markdown
---

## [TeamName] — $1: [Ticket Title]
**Filed by:** [Conductor code]
**Date:** DD-MM-YYYY
**Status:** COMPLETE | BLOCKED | IN PROGRESS

### Summary
[What was built/done — to be filled]

### Acceptance Criteria
- [x] criterion 1
- [x] criterion 2
- [x] all tests pass

### Dependency Signal
[If this ticket unblocks others:]
Ticket $1 is COMPLETE. Teams waiting on this ticket may now proceed:
- [TeamName]: [ticket IDs now unblocked]

### Blockers
None | [Description of blocker]

### Next Step for AM
[What Overseer must do next]
```

8. **Remind** the filing team to also update the ticket status to `[x] Complete`.

## Arguments

- `$1` — Ticket ID (required, e.g., `MON-01`) or `BLOCKER` for a blocker-only report
