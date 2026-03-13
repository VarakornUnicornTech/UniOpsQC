---
description: "Skills (slash commands) and subagent standard: pre-flight checks, delegation rules, orchestration modes"
---

# Skills & Subagents Rules
> Full standard: `TeamDocument/1. Policies/08_Skills_and_Subagents.md`

## Skills (Slash Commands)
Skills are reusable prompt templates in `.claude/skills/[name]/SKILL.md`.
Invoked with `/command-name [arguments]`.

### Skill File Format
```
# /[command-name]
## Purpose — [one sentence]
## Arguments — [list each, type, valid values]
## Steps — [numbered procedure]
## Output — [what it produces]
```

### Skill Rules
- Skills describe **procedures** — not policy. Policy lives in `TeamDocument/1. Policies/`.
- Every skill reads `.claude/ProjectEnvironment.md` for paths — never hardcode paths.
- Skills that create files determine next ORDER number by scanning target folder first.
- Skills must log to appropriate file (RoundTable for Overseer, Team Chat for sub-teams).
- Skills never skip Planning-First Workflow — plan files still presented to Commander before implementing.

---

## AM Orchestration Modes

### Mode A — AM Direct Orchestration (DEFAULT)
Commander gives AM the goal. AM reads briefings, spawns each sub-team as subagent
with roster + ticket scope, receives results, files OverseerReport, presents consolidated
report to Commander.

**Commander Vision Gate (MANDATORY before Mode A execution):**
Before spawning ANY subagents, AM presents Execution Plan and receives Commander approval:
```
## Phase [N] Execution Plan — [ProjectName]
Mode: A — AM Direct Orchestration
| Team | Tickets | Scope |
|------|---------|-------|
| Monolith | MON-01–MON-XX | [2-sentence scope] |
| Syndicate | SYN-01–SYN-XX | [2-sentence scope] |
| Arcade | ARC-01–ARC-XX | [2-sentence scope, mock-first if applicable] |
### Dependencies — [cross-team signals, sequential steps if any]
### Your Vision / Constraints — [Commander adds direction or approves]
```

### Mode B — Separate Sessions (opt-in)
Commander opens separate session per team directly for live visibility.
Activated by: "I want to work directly with [Team]" or "run as separate sessions."

---

## AM Orchestration Prompt Format (Mode A subagent spawn)
```
You are Team [Name].
Roster: .claude/agents/[team].md
Briefing: [PROJECT_ROOT]/Development/.../Phase [N]/[TeamName]_Phase[N]_Briefing.md
Your ticket scope: [specific ticket IDs]
Commander direction: [input from Vision Gate, or "None — execute per briefing"]
When complete: write Team Chat entry, then return compact summary of:
(1) what you built, (2) files created/modified, (3) any blockers.
Do NOT advance to Phase [N+1] — auth: [free | hold]
```

## AM Aggregation Standard
After all subagents return, AM:
1. Logs each team's result in their Team Chat under `### Subagent Result — [TicketIDs]`
2. Files consolidated OverseerReport covering all teams
3. Presents single summary to Commander: what each team built, blockers, next steps

---

## Subagent Standard (All Conductors)

### Subagent Trigger Conditions (Mandatory Pre-Flight)
Before executing ANY ticket block or multi-step task, Conductor checks:

| Trigger | Threshold | Action |
|---------|-----------|--------|
| Independent tickets in one session | 3+ | Each ticket → separate subagent |
| Files to scan (L2/L3) | 10+ | Scan → subagent, return compact summary |
| AM in planning + deep investigation needed | Any | Investigation → subagent |
| Estimated tool calls for single task | 20+ | Delegate to subagent |
| Full subsystem read + implementation | Any | Read phase → subagent, implement → separate |

If NONE met → single-session execution permitted.

### Conductor Pre-Flight Declaration (Mandatory)
Before starting any multi-step task, Conductor logs in Team Chat:

**Single-session:**
```
Single-session execution — [reason: e.g., 2 tickets only / scan under 10 files]
```

**Subagent delegation:**
```
Delegating to subagent — [task description]
Kickoff message:
> [Exact prompt for subagent session]
```

No silent execution. Declaration logged before work begins.

### `[SUBAGENT]` Briefing Tag
Tickets meeting trigger conditions tagged in briefings:
```
## Ticket MON-03 — Full Subsystem Scan   [SUBAGENT]
```
`[SUBAGENT]` = mandatory delegation. Conductor confirms delegation before marking IN PROGRESS.

### Receiving Subagent Results
Parent session (Conductor) receives output and:
1. Logs result under `### Subagent Result — [TaskName]` in Team Chat
2. Incorporates result into ongoing work
3. Updates ticket status if applicable
