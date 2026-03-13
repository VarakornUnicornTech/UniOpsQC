# §7 — Parallel Execution Policy & Ticket Ownership Rules

> **Policy reference file.** Loaded on-demand from `.claude/TeamDocument/1. Policies/`. Core rules live in CLAUDE.md.

---

## Parallel Execution Policy (MANDATORY)

**All three sub-teams (Monolith, Syndicate, Arcade) work in parallel across every phase by default.** No team waits for another team to fully finish before starting their own unblocked tickets.

**Rules:**
1. **Start immediately on all unblocked tickets.** When a phase opens, each team reads their Briefing, identifies which tickets have no cross-team dependency, and begins those at once.
2. **Blocked tickets wait only on the specific dependency — not the full team.** If SYN-06 depends on MON-07, Syndicate starts SYN-01 through SYN-05 immediately and picks up SYN-06 only after MON-07 signals complete in OverseerReport. Syndicate does NOT wait for all of Monolith to finish.
3. **Dependency signal = OverseerReport entry.** When a ticket that others depend on completes, the completing team files an OverseerReport entry immediately. Waiting teams poll OverseerReport — when they see the entry, they unblock and proceed.
4. **Arcade scaffolds with mock data.** When Arcade's tickets depend on backend data, they build the UI against mock/stub data first and wire live APIs when the dependency signals complete.
5. **No idle waiting.** If a team exhausts all unblocked tickets while blocked tickets remain, they file an OverseerReport noting the wait state and take up internal prep work (code review, documentation, test expansion) until unblocked.
6. **Within a team, work in parallel too.** Team members (Conductor, Technologist, Design Scholar, Verification Scholar) divide unblocked tickets among themselves and work concurrently. The Conductor tracks which member owns which ticket and aggregates results.
7. **Early Phase Advance — Commander ท่านผู้บัญชาการ gate (MANDATORY).** A team that completes all their Phase N tickets may NOT advance to Phase N+1 on their own initiative. They must: (a) file their Phase N OverseerReport marking all tickets complete, (b) enter a wait state and notify AM, and (c) wait for the Commander ท่านผู้บัญชาการ to explicitly tell them they may advance. Only a direct message from the Commander ท่านผู้บัญชาการ authorises the early advance. AM does not have authority to grant this — only the Commander ท่านผู้บัญชาการ does.

**Dependency signal format (OverseerReport entry):**
When a ticket that other teams depend on completes, the completing team's OverseerReport entry MUST include:
```
### Dependency Signal
Ticket [ID] is COMPLETE. Teams waiting on this ticket may now proceed:
- [TeamName]: [ticket IDs now unblocked]
```

---

## Ticket Ownership Rules (MANDATORY — applies when creating any new ticket)

These rules prevent cross-team blocking at phase open. AM must apply them when writing every Briefing.

1. **The team that consumes a deliverable owns its foundation tickets.** If Syndicate's enforcement logic needs a database schema, Syndicate writes and owns that schema — not Monolith. The consumer team owns the full vertical (data layer → logic → API). There are NO exceptions to this rule.
2. **Zero Cross-Team Block (ZCB) Guarantee — HARD RULE.** No team may have a ticket that is blocked waiting on another team's output within the same phase. Before dispatching any phase briefing, AM runs the ZCB check: for every team assigned tickets, confirm that ALL their tickets can be executed using only their own team's output and prior-phase foundations already completed. Any remaining cross-team block is a design error — reassign ownership before dispatch. The ZCB check must be documented in the Briefing's "Parallel Execution" section.
3. **Every team receiving tickets must be able to execute ALL of them independently.** A team is never assigned a ticket whose prerequisite sits in another team's column. If it does, either: (a) move the prerequisite ticket to the consuming team's ownership, or (b) split the work into a prior-phase ticket so it is complete before this phase opens.
4. **Arcade Mock-First Exception (only exception to ZCB).** Arcade is the sole team allowed to have live-API wiring blocked on backend delivery — because Arcade scaffolds all UI with mock/stub data first and never sits idle. Arcade starts immediately with mocks; wires live APIs only after backend signals complete in OverseerReport. This is the only permitted cross-team dependency pattern.
5. **Overseer must resolve all OVR-XX architecture decisions during the preceding phase.** Overseer does not open a phase that requires an architecture decision that hasn't been made yet. OVR-XX evaluation work runs concurrently with the preceding phase — so when the phase gate opens, teams can begin immediately.
6. **Infrastructure tickets are Monolith's domain only when shared across teams.** If an infrastructure piece (e.g., Redis, cluster mode) is used by multiple teams, Monolith owns it. If it is used exclusively by one team, that team owns it. **Priority over Rule §1:** When a resource is shared by two or more teams, Rule §6 takes precedence — Monolith owns it regardless of which team first raised a consuming ticket.
7. **Cross-team dependency chains must not exceed one hop.** Team A → Team B is acceptable. Team A → Team B → Team C is a design smell. Restructure ticket ownership to break the chain.

---

## ZCB Pre-Dispatch Checklist (AM must run this before every Briefing is dispatched)

```
For each team with tickets in Phase N:
[ ] List all tickets assigned to this team
[ ] For each ticket: does it depend on any ticket from a DIFFERENT team in this phase?
    → If YES: redesign. Either transfer the dependency to this team, or complete it in a prior phase.
[ ] For each ticket: does it depend on a prior-phase ticket that is already COMPLETE?
    → If YES: acceptable. Mark as "prior-phase foundation" in ticket's Depends on field.
[ ] Arcade only: does it depend on a live API from MON/SYN this phase?
    → If YES: scaffold with mocks. Mark as "wires to live after [signal]" in ticket Notes.
[ ] Confirm: no team is left idle with zero startable tickets while other teams are active.
    → If a team genuinely has no work in a phase, that is acceptable — note it explicitly.
```

---

## Commander Sync Gate for Early Phase Advance (NEW — 12-03-2026)

> **Lesson learned:** SyncSpace teams were pre-authorized to chain Phases 3 → 4 automatically. When Phase 3 had critical user-facing bugs, Phase 4 work was already underway — built on a broken foundation. Async advance without Commander's validation wastes effort when the preceding phase has undetected issues.

**Extends Rule 7 (Early Phase Advance).** This gate only applies when the Commander Phase Acceptance Gate (§2) is toggled ON for the current phase. When the gate is OFF, standard Early Phase Advance (Rule 7) applies.

**When Commander Phase Acceptance Gate is ON and teams are async:**
1. **Async advance requires explicit Commander opt-in.** Commander ท่านผู้บัญชาการ must state: "Team [X] may advance to Phase N+1 while Phase N acceptance is pending."
2. **AM presents the Async Advance checklist:**
   ```
   ## Async Advance Request — [TeamName] → Phase [N+1]
   [ ] All Phase N tickets complete (Verification Scholar confirmed)
   [ ] User Journey Walkthrough: PASS
   [ ] Commander Phase Acceptance: PENDING / ACCEPTED
   [ ] If PENDING: Commander acknowledges rework risk
   [ ] Phase N+1 tickets have ZERO dependencies on other teams' Phase N work
   [ ] Commander grants provisional advance: YES / NO
   ```
3. **Provisional advances do not stack.** A team on provisional Phase N+1 may NOT advance to N+2 until Phase N is Commander-ACCEPTED.

---

*Updated: 13-03-2026*
