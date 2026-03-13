# §9 — Multi-Session Parallel Work

> **Policy reference file.** Loaded on-demand from `.claude/TeamDocument/1. Policies/`. Core rules live in CLAUDE.md.

---

## Purpose

When Commander runs multiple Claude CLI sessions simultaneously (e.g., one session working on Project A, another on Project B), each session operates independently. This policy defines the rules that prevent shared-resource collisions while preserving a unified audit trail.

**This policy extends §7 (Parallel Execution).** §7 covers parallel execution of *teams within a single session*. §9 covers parallel execution of *multiple CLI sessions across projects*.

---

## Hard Rules

### Rule 1: One Session Per Project

**Each CLI session owns exactly one project. Two sessions MUST NOT work on the same project simultaneously.**

Rationale: Source code, test state, Development folders, plan files, and build artifacts are shared within a project. Concurrent writes from two sessions will cause silent merge conflicts, stale test results, and corrupted state.

### Rule 2: Session Declaration

At the start of each session, Commander declares which project that session owns. The session records this in its first RoundTable or Team Chat entry:

```
## Session [N] [ProjectName] — [Title]
```

The project prefix `[ProjectName]` appears in every session header for the duration of that CLI session. Example:

```
## Session 17 [SyncSpace] — Phase 2 Room CRUD
## Session 18 [AeroMedica] — 3D Asset Pipeline Fix
## Session 19 [SyncSpace] — Phase 2 Presence Protocol
```

### Rule 3: Session Numbering — First-Come-First-Served

Session numbers are global (not per-project) and assigned by the order sessions write to the RoundTable file. If Session A and Session B both start:

- Whichever session writes its entry first claims the next session number
- The other session claims the following number
- There are no reserved or pre-allocated session numbers

### Rule 4: Shared RoundTable File

All sessions write to the **same daily RoundTable Volume file**. The project prefix in the session header distinguishes entries. This preserves the chronological cross-project timeline.

**Vol rotation:** Each session checks the current Vol file's line count before every write (standard §1 behavior). If a session detects the file has passed the 400-line soft limit (potentially due to another session's writes), it rotates to a new Vol immediately.

### Rule 5: OverseerReport — Project-Prefixed Sections

When multiple sessions file to the same daily OverseerReport, each entry includes a project header:

```markdown
## [ProjectName]

### [TicketID] — [Title]
...
```

This prevents interleaving of unrelated project reports in the shared file.

---

## Safe Resources (No Collision)

These resources are inherently isolated across projects and require no special handling:

| Resource | Why It's Safe |
|----------|--------------|
| **Source code** | Different `SOURCE_ROOT` per project (see `ProjectEnvironment.md`) |
| **Development folders** | Each project has its own `Development/` tree |
| **Plan files** | UUID-named, per-session |
| **Team Chat logs** | Each team writes to its own subfolder (`TeamChat/1. Monolith/`, `2. Syndicate/`, etc.) |
| **Phase Briefings** | Project-scoped, inside each project's Development folder |

---

## Collision-Prone Resources

These require the rules above to remain safe:

| Resource | Mitigation |
|----------|-----------|
| **RoundTable Vol file** | Project prefix on session headers (Rule 2 + Rule 4) |
| **`_Index.md`** | Each session updates after its own Vol rotation — check before write |
| **OverseerReport** | Project-prefixed sections (Rule 5) |
| **Session numbering** | First-come-first-served (Rule 3) |
| **`ProjectEnvironment.md`** | Low risk — only update if adding/removing a project. Check before write. |

---

## What Happens If Rules Are Violated

| Violation | Consequence | Recovery |
|-----------|-------------|----------|
| Two sessions on same project | Silent merge conflicts, stale tests, corrupted state | Stop one session immediately. Audit changed files. |
| Missing project prefix | RoundTable entries become unreadable — cannot tell which project a session belongs to | Retroactively add prefixes to session headers |
| Both sessions rotate Vol simultaneously | Duplicate Vol files or skipped Vol numbers | AM reconciles `_Index.md` manually |

---

## Quick Reference

```
BEFORE STARTING A PARALLEL SESSION:
1. Commander declares: "This session works on [ProjectName]"
2. Session logs: ## Session [N] [ProjectName] — [Title]
3. Verify no other session is working on the same project
4. Check RoundTable Vol line count before first write

DURING THE SESSION:
- All session headers include [ProjectName]
- Check Vol line count before every write (standard §1)
- OverseerReport entries include project header

ON SESSION END:
- No special cleanup required — entries are already project-tagged
```

---

*Added: 13-03-2026 — Originated from RoundTable Vol5 Session 16-17 discussion*
