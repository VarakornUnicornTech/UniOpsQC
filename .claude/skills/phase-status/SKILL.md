---
name: phase-status
description: Full project phase and ticket status report. Scans all ticket files for a project and returns a complete status breakdown by team and phase.
---

# /phase-status [Project]

## Arguments

- `[Project]` — Project name (must match an entry in `.claude/ProjectEnvironment.md`)

## Steps

1. **Read ProjectEnvironment.md:**
   - Path: `.claude/ProjectEnvironment.md`
   - Extract `PROJECT_ROOT` for the specified project.

2. **Locate the Implementation Logs folder:**
   - Path: `[PROJECT_ROOT]/Development/01_Implementation Logs/INDEV v1.0.0/`
   - List all Phase folders found.

3. **For each Phase folder:**
   - List all ticket files (any `.md` file that is not a Briefing).
   - Read each ticket file and extract: ticket ID, title, and status (`[ ]` / `[~]` / `[x]` / `[!]` / `[>]`).
   - Identify the owning team from the ticket ID prefix (MON = Monolith, SYN = Syndicate, ARC = Arcade, OVR = Overseer).

4. **Build the status report:**

```markdown
## Phase Status Report — [Project]
**Generated:** DD-MM-YYYY

### Phase [N] — [Phase Name if available]

#### Monolith
| ID | Title | Status |
|----|-------|--------|
| MON-01 | [title] | ✅ Complete / 🔄 In Progress / ⬜ Pending / 🚫 Blocked / ➡️ Deferred |

#### Syndicate
| ID | Title | Status |
|----|-------|--------|

#### Arcade
| ID | Title | Status |
|----|-------|--------|

**Phase [N] Summary:** [X] Complete, [X] In Progress, [X] Pending, [X] Blocked, [X] Deferred

---

### Overall Project Summary
| Phase | Complete | In Progress | Pending | Blocked | Deferred |
|-------|----------|-------------|---------|---------|----------|
| Phase 1 | X | X | X | X | X |
| Phase 2 | X | X | X | X | X |
```

5. **Flag any blockers** prominently at the top of the report if any `[!]` tickets exist.

## Status Icon Legend
- `[ ]` PENDING → ⬜
- `[~]` IN PROGRESS → 🔄
- `[x]` Complete → ✅
- `[!]` BLOCKED → 🚫
- `[>]` DEFERRED → ➡️
