---
name: commands
description: Command discovery tool. 'list' shows all available commands. 'recommend [intent]' suggests the best command for what you want to do. Self-contained — no external file reads needed.
---

# /commands

## Purpose

Help Commander and teams discover and select the right skill for any task. Two modes: list all available commands, or get a recommendation based on your stated intent.

## Arguments

`[mode] [intent?]`

- **mode** — `list` (default) or `recommend`. Omit for default `list` behavior.
- **intent** — (recommend mode only) a short description of what you want to do

## Help

If `[mode]` is `help` (i.e., `/commands help`), print this usage reference and STOP:

```
/commands — Command discovery tool

SYNTAX:
  /commands                              Show all available commands (default)
  /commands list                         Show all available commands
  /commands recommend [intent]           Suggest best command for your intent

EXAMPLES:
  /commands                              Show all commands
  /commands list                         Show all commands
  /commands recommend "fix a bug"        → suggests /bug-report
  /commands recommend "start a phase"    → suggests /team-start
  /commands help                         Show this help text
```

---

## Steps

### Mode: list (default — no argument, or `list`)

Output the command reference table below exactly as written:

---

## Available Commands — UniOpsQC Framework

### Session & Persona

| Command | Purpose |
|---------|---------|
| `/roundtable-setup` | First-time setup — collect callsign, preferences, project context |
| `/compact-resume` | Post-compact re-orientation: re-read policy, log session resume, confirm persona |
| `/Overseer` | Persona switch — adopt Overseer team voice (AM/MT/AS) |
| `/Monolith` | Persona switch — adopt Monolith team voice |
| `/Syndicate` | Persona switch — adopt Syndicate team voice |
| `/Arcade` | Persona switch — adopt Arcade team voice |
| `/Cipher` | Persona switch — adopt Cipher operative voice |

### Planning & Documentation

| Command | Purpose |
|---------|---------|
| `/plan [Project] [description]` | Unified planning — brainstorm → design → spec → tickets. Awaits Commander approval before implementation. |
| `/document [Project] [FeatureName]` | Generate or update a feature description doc from source code (L1/L2 scan) |

### Project & Phase Management

| Command | Purpose |
|---------|---------|
| `/phase-status [Project]` | Full project phase + ticket status report |
| `/team-start [Team] [Project] [Phase] [free\|hold]` | Formal team kickoff with Early Advance authorization |
| `/audit [Project] [scope?]` | End-to-end user flow audit — finds UX-breaking gap bugs, files a bug report per gap |

### Ticket Workflow

| Command | Purpose |
|---------|---------|
| `/bug-report [Project] [desc]` | Create a PLANNED bug fix file + ticket folder structure |
| `/mod-log [Project] [name]` | Create a PLANNED modification log + ticket folders |
| `/sub-feature [Project] [name]` | Create a PLANNED sub-feature + ticket folders |
| `/overseer-report [ID]` | File a report entry for AM review |

### Version Control

| Command | Action |
|---------|--------|
| `/git status` | Quick git state overview — branch, divergence, working tree |
| `/git commit [branch?]` | Governed commit — safety gates, 2-pass review, ticket gate |
| `/git pr [branch?]` | Governed PR — safety gates, review, test, push, PR creation |
| `/git sync [remote?] [branch?]` | Governed sync — fetch upstream/origin, compare, merge/rebase |
| `/git lookback [period?]` | Retrospective — git metrics + RoundTable session review |

### Framework Management

| Command | Action |
|---------|--------|
| `/template status` | Show framework version and installation state |
| `/template check` | Compare local version against remote repository |
| `/template diff` | 3-way diff — classifies each file as UNCHANGED / REMOTE ONLY / LOCAL ONLY / CONFLICT |
| `/template apply [scope]` | Apply remote updates: `recommended` (safe) · `all` (prompts on conflicts) · `<file>` |
| `/template rollback` | Restore backup files from the last apply |

### Discovery

| Command | Purpose |
|---------|---------|
| `/commands list` | Show this command reference (you're looking at it) |
| `/commands recommend [intent]` | Suggest the best command for what you want to do |

---

### Mode: recommend [intent]

Read the user's stated intent. Match it to the best command using the decision table below. Output: the recommended command name, one sentence explaining why it fits, and the syntax with context filled in.

| If the user wants to... | Recommend |
|------------------------|-----------|
| Fix a specific bug | `/bug-report [Project] [desc]` |
| Plan a new feature or change | `/plan [Project] [description]` |
| Add a sub-feature or capability | `/sub-feature [Project] [name]` |
| Log a modification or expansion | `/mod-log [Project] [name]` |
| Start a team on a phase | `/team-start [Team] [Project] [Phase] [free\|hold]` |
| Check project or phase progress | `/phase-status [Project]` |
| Find UX or flow bugs | `/audit [Project] [scope?]` |
| Document a feature from code | `/document [Project] [FeatureName]` |
| Commit changes | `/git commit` |
| Create a pull request | `/git pr` |
| Update the framework | `/template apply` |
| Check for framework updates | `/template check` |
| Resume after /compact | `/compact-resume` |
| Set up for the first time | `/roundtable-setup` |
| Know what commands exist | `/commands list` |
| Switch to a team persona | `/[TeamName]` |

If the intent does not match clearly, name the two most likely commands and explain the difference so Commander can choose.

---

## Output

- **list mode:** Full command reference table as shown above
- **recommend mode:** Single recommended command with one-sentence rationale and filled-in syntax example
