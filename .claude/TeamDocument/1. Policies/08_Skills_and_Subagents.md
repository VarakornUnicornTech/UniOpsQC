# §8 — Skills (Slash Commands) & Subagent Standard

> **Policy reference file.** Loaded on-demand from `.claude/TeamDocument/1. Policies/`. Core rules live in CLAUDE.md.

---

## Skills (Slash Commands)

Skills are reusable prompt templates stored in `.claude/skills/[name]/SKILL.md`. They are invoked with `/command-name [arguments]`. Claude Code loads the SKILL.md file, substitutes `$ARGUMENTS` with whatever the user typed after the command name, and executes the prompt.

**Location:** `.claude/skills/[name]/SKILL.md`

**Directory naming:** Each skill lives in its own subfolder matching the command name exactly (e.g., `skills/audit/SKILL.md` for `/audit`).

### Skill File Format

```markdown
# /[command-name]

## Purpose
[One sentence: what this skill does]

## Arguments
[List each argument, its type, and valid values. Or "None" if no arguments.]

## Steps
[Numbered list of exactly what Claude must do when this skill is invoked]

## Output
[What the skill produces / presents to Commander ท่านผู้บัญชาการ]
```

### Rules
- Skill files describe **procedures** — not policy. Policy lives in `.claude/TeamDocument/1. Policies/`. Skills call on policy as context.
- Every skill must read `.claude/ProjectEnvironment.md` whenever it needs a project path — never hardcode paths.
- Skills that create files must determine the next ORDER number by scanning the target folder before writing.
- Skills must log to the appropriate file (RoundTable for Overseer, Team Chat for sub-teams) as part of their execution.
- Skills never skip the Planning-First Workflow — skills that create plan files still present to Commander ท่านผู้บัญชาการ before implementing anything.

---

## Skill Catalogue

### `/roundtable-open [title]`
**File:** `skills/roundtable-open/SKILL.md`
Create/append today's RoundTable session entry. Creates the file if it doesn't exist.

### `/ticket-create [ID] [Name]`
**File:** `skills/ticket-create/SKILL.md`
Scaffold a ticket file from the standard template.

### `/briefing-create [Team] [Phase]`
**File:** `skills/briefing-create/SKILL.md`
Generate a Phase Briefing Mail for a specific team.

### `/zcb-check [Phase]`
**File:** `skills/zcb-check/SKILL.md`
Validate Zero Cross-Team Block on a phase's tickets.

### `/overseer-report [ID]`
**File:** `skills/overseer-report/SKILL.md`
File a report entry for AM review.

### `/l3-scan [Project]`
**File:** `skills/l3-scan/SKILL.md`
Initiate L3 Full Code Scan with all 5 checks. Requires Commander authorization.

### `/audit [Project] [scope?]`
**File:** `skills/audit/SKILL.md`
End-to-end user flow audit — finds UX-breaking gap bugs, files bug report.

---

## AM Orchestration Mode

AM (Overseer) may orchestrate sub-teams directly as subagents, handling all team coordination internally and presenting a consolidated result to Commander ท่านผู้บัญชาการ.

### Mode A — AM Direct Orchestration (DEFAULT)

Commander ท่านผู้บัญชาการ gives AM the goal. AM reads briefings, spawns each sub-team as a subagent with their roster + ticket scope, receives results, files OverseerReport, presents consolidated report to Commander.

**Commander's experience:** One prompt in, one consolidated report out.

**Best for:** Well-defined tickets with clear acceptance criteria, full phase execution where briefings are written, any work where Commander wants a clean outcome rather than managing live team sessions.

### Mode B — Separate Sessions (opt-in)

Commander opens a separate session per team directly and interacts with each team live.

**Best for:** Exploratory/uncertain work, phases requiring real-time architectural decisions, when Commander wants direct visibility and the ability to course-correct mid-session.

**To activate:** Commander says "I want to work directly with [Team]" or "run this as separate sessions."

---

## Commander Vision Gate — MANDATORY Before Mode A Execution

Before AM spawns ANY subagents for phase execution, AM MUST present an Execution Plan to Commander ท่านผู้บัญชาการ and receive explicit approval. **AM never executes autonomously.**

**Execution Plan format:**

```markdown
## Phase [N] Execution Plan — [ProjectName]
**Mode:** A — AM Direct Orchestration

### Teams & Scope
| Team | Tickets | Scope |
|------|---------|-------|
| Monolith | MON-01–MON-XX | [2-sentence scope] |
| Syndicate | SYN-01–SYN-XX | [2-sentence scope] |
| Arcade | ARC-01–ARC-XX | [2-sentence scope — mock-first if applicable] |

### Dependencies
[Cross-team dependency signals, order of execution if any sequential steps]

### Your Vision / Constraints
Any strategic direction, priorities, or constraints to pass to the teams?
Approve to proceed with orchestration.
```

Commander either adds direction (AM incorporates into kickoff prompts) or approves. "Approve", "proceed", "go ahead", "yes" count as approval.

---

## AM Orchestration Prompt Format

When AM spawns a team subagent in Mode A, the kickoff prompt must include:

```
You are Team [Name].
Roster: .claude/agents/[team].md
Briefing: [PROJECT_ROOT]/Development/[ProjectName]/01_Implementation Logs/INDEV v1.0.0/Phase [N]/[TeamName]_Phase[N]_Briefing.md
Your ticket scope: [specific ticket IDs]
Commander direction: [Commander's input from Vision Gate, or "None — execute per briefing"]
When complete: write your Team Chat session entry to .claude/TeamDocument/2. TeamChat/[N. TeamName]/[DD-MM-YYYY]_[TeamName].md, then return a compact summary of: (1) what you built, (2) files created/modified, (3) any blockers.
Do NOT advance to Phase [N+1] — auth: [free | hold]
```

---

## AM Aggregation Standard

After all subagents return, AM:
1. Logs each team's result in their Team Chat file under `### Subagent Result — [TicketIDs]` if not already written by the subagent
2. Files a consolidated OverseerReport entry covering all teams
3. Presents a single summary to Commander ท่านผู้บัญชาการ: what each team built, any blockers, next steps

---

## Subagent Standard (General — All Conductors)

A **subagent** is a separate Claude session that handles a delegated subtask, returning a compact result to the parent session. Subagents are not a built-in command — they are a **usage pattern** enforced through policy.

### Subagent Trigger Conditions (Mandatory Pre-Flight)

Before executing ANY ticket block, investigation, or multi-step task, the Conductor runs this check:

| Trigger | Threshold | Required Action |
|---------|-----------|----------------|
| Independent tickets in one session | 3 or more | Each ticket → separate subagent session |
| Files to scan (L2/L3) | 10+ files | Scan → subagent, return compact summary |
| AM in planning mode + deep investigation needed | Any | Investigation → subagent, AM continues with result |
| Estimated tool calls for a single task | 20+ | Delegate to subagent |
| Task requires full subsystem read + implementation | Any | Read phase → subagent, implement phase → separate session |

If **none** of these conditions are met → single-session execution is permitted.

### Conductor Pre-Flight Declaration (Mandatory)

Before starting any multi-step task, the Conductor must open their Team Chat session entry with one of these declarations:

**Single-session:**
```
Single-session execution — [reason: e.g., 2 tickets only / scan under 10 files / estimated 8 tool calls]
```

**Subagent delegation:**
```
Delegating to subagent — [task description]
Kickoff message:
> [Exact prompt for the subagent session]
```

No silent execution. The declaration is logged in Team Chat before work begins.

### `[SUBAGENT]` Briefing Tag

When AM writes a phase briefing, tickets that meet trigger conditions are tagged:

```markdown
## Ticket MON-03 — Full Subsystem Scan   [SUBAGENT]
```

`[SUBAGENT]` is a mandatory instruction — the implementing team member **must** delegate this ticket. Conductors confirm delegation before marking the ticket IN PROGRESS.

### Receiving Subagent Results

The parent session (Conductor) receives the subagent's output. The Conductor:
1. Logs the result under `### Subagent Result — [TaskName]` in their Team Chat session
2. Incorporates the result into ongoing work
3. Updates the relevant ticket status if applicable

---

*Created: 13-03-2026*
