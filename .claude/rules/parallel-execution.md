---
description: "Parallel execution policy: ZCB guarantee, ticket ownership, multi-session rules"
---

# Parallel Execution Rules
> Full standard: `TeamDocument/1. Policies/07_Parallel_Execution.md` + `09_Multi_Session_Parallel_Work.md`

## All Teams Work in Parallel
All sub-teams work in parallel across every phase. No team waits for another
to fully finish. Start immediately on all unblocked tickets.

## Ticket Ownership Rules
1. **Consumer Owns Foundation** — Team consuming deliverable owns its foundation
   tickets. Consumer team owns full vertical (data → logic → API). NO EXCEPTIONS.
2. **ZCB Guarantee** — No team may have ticket blocked waiting on another team's
   output within same phase. Any block = design error — reassign before dispatch.
3. **Independent Execution** — Every team's tickets must execute using only their
   own output + prior-phase foundations already completed.
4. **Arcade Mock-First Exception** — Arcade scaffolds UI with mock data first,
   wires live APIs after backend signals complete in OverseerReport.
5. **Infrastructure Priority** — Shared infrastructure owned by Monolith regardless
   of which team raised consuming ticket.
6. **One-Hop Maximum** — Cross-team dependency chains must not exceed one hop.
   A → B acceptable. A → B → C = design smell — restructure.

## Early Phase Advance — Commander Gate
Team completing all Phase N tickets may NOT advance to Phase N+1 on own initiative.
Must file OverseerReport, enter wait state, wait for Commander's explicit authorization.
Conductor does NOT have this authority — only Commander does.

## COO Sync Gate
Async phase advance requires explicit Commander opt-in. Default is synchronous:
all teams finish → Commander accepts → all advance together.
Provisional advances do not stack — each requires separate Commander authorization.

## Dependency Signal Format
When ticket others depend on completes:
```
### Dependency Signal
Ticket [ID] is COMPLETE. Teams waiting on this ticket may now proceed:
- [TeamName]: [ticket IDs now unblocked]
```

---

## Multi-Session Rules (§9)

### Rule 1: One Session Per Project (HARD RULE)
Each CLI session owns exactly one project. Two sessions MUST NOT work on the same
project simultaneously. Concurrent writes cause silent merge conflicts, stale tests,
and corrupted state.

### Rule 2: Session Declaration
Each session declares its project at start. Project prefix in every session header:
`## Session [N] [ProjectName] — [Title]`

### Rule 3: Session Numbering
Global, first-come-first-served. Whichever session writes first claims next number.
No reserved or pre-allocated session numbers.

### Rule 4: Shared RoundTable File
All sessions write to same daily RoundTable Volume. Project prefix distinguishes entries.
Vol rotation: each session checks line count before every write (standard §1).
If file passed 400-line soft limit (potentially from another session's writes),
rotate to new Vol immediately.

### Rule 5: OverseerReport — Project-Prefixed Sections
Multi-project OverseerReport entries include project header:
```
## [ProjectName]
### [TicketID] — [Title]
```

## Safe Resources (no collision risk)
| Resource | Why Safe |
|----------|---------|
| Source code | Different `SOURCE_ROOT` per project |
| Development folders | Each project has own tree |
| Plan files | UUID-named, per-session |
| Team Chat logs | Each team's own subfolder |
| Phase Briefings | Project-scoped, inside project's Development folder |

## Collision-Prone Resources
| Resource | Mitigation |
|----------|-----------|
| RoundTable Vol file | Project prefix on session headers (Rule 2 + 4) |
| `_Index.md` | Each session updates after own Vol rotation — check before write |
| OverseerReport | Project-prefixed sections (Rule 5) |
| Session numbering | First-come-first-served (Rule 3) |
| `ProjectEnvironment.md` | Low risk — check before write when adding/removing projects |

## Violation Consequences
| Violation | Consequence | Recovery |
|-----------|-------------|----------|
| Two sessions on same project | Silent merge conflicts, stale tests | Stop one session immediately, audit changed files |
| Missing project prefix | RoundTable entries unreadable | Retroactively add prefixes to session headers |
| Both sessions rotate Vol simultaneously | Duplicate/skipped Vol numbers | AM reconciles `_Index.md` manually |
