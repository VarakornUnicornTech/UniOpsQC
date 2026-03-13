# RoundTable Framework For Claude Code

> **ภาษาไทย / Thai:** [อ่าน README ภาษาไทย](README.th.md)

Governance for Claude Code — ship with confidence, not just speed.

A structured multi-team AI governance framework that turns Claude Code into a coordinated engineering organization with specialized teams, approval gates, automated policy enforcement, and full audit trail.

**By [Unicorn Tech Integration Co., Ltd.](https://www.unicorntechint.com)**

---

## Why RoundTable?

| | Vanilla Claude Code | **RoundTable** |
|---|---|---|
| **Structure** | Single assistant | 5 teams + 16 personas |
| **Planning** | Ad hoc | Phase dispatch + ticket gates |
| **Code Review** | Manual | 2-pass + cross-layer trace |
| **Shipping** | Manual git | `/git pr` with rebase + governance gates |
| **QA** | Manual | Playwright MCP + smoke test gates |
| **Retrospective** | None | `/git lookback` — git + session data + decision audit |
| **Governance** | None | Full hierarchy + approval gates |
| **Audit Trail** | None | Every decision logged + traceable |
| **Multi-Team** | No | 4 teams + parallel execution |
| **Setup** | N/A | ~30 seconds |

---

## Quick Start

### Install via Claude Code (Recommended)

Copy and paste into Claude Code:

**English:**
```
Install the RoundTable Framework from https://github.com/VarakornUnicornTech/unicorn_roundtable_framework_repo into my current project. Follow the Getting Started guide at https://github.com/VarakornUnicornTech/unicorn_roundtable_framework_repo/wiki/Getting-Started
```

**Thai / ภาษาไทย:**
```
ติดตั้ง RoundTable Framework จาก https://github.com/VarakornUnicornTech/unicorn_roundtable_framework_repo ลงใน project ปัจจุบัน ตาม Getting Started ที่ https://github.com/VarakornUnicornTech/unicorn_roundtable_framework_repo/wiki/Getting-Started
```

> **Tip:** Use "install" — not "read" or "explain". Saying "install" makes Claude go straight to setup without reading every policy file first.

### Manual Install

**Bash / Git Bash / macOS / Linux:**
```bash
git clone https://github.com/VarakornUnicornTech/unicorn_roundtable_framework_repo.git .claude-template
cp -r .claude-template/.claude/ your-project/.claude/
cp .claude-template/plugin.json your-project/plugin.json
cp .claude-template/.mcp.json your-project/.mcp.json
cp -r .claude-template/hooks/ your-project/hooks/
rm -rf .claude-template
```

**PowerShell (Windows):**
```powershell
git clone https://github.com/VarakornUnicornTech/unicorn_roundtable_framework_repo.git .claude-template
Copy-Item -Recurse .claude-template\.claude\ your-project\.claude\
Copy-Item .claude-template\plugin.json your-project\plugin.json
Copy-Item .claude-template\.mcp.json your-project\.mcp.json
Copy-Item -Recurse .claude-template\hooks\ your-project\hooks\
Remove-Item -Recurse -Force .claude-template
```

Then edit `.claude/ProjectEnvironment.md` with your project details and start Claude Code.

---

## Three Ways to Use RoundTable

### Level 1 — "I just want better shipping"
Use `/git commit` and `/git pr`. No governance overhead — just better shipping.

### Level 2 — "I want project structure"
Use `/team-start`, `/phase-status`, `/bug-report`. Phase-based development without full team simulation.

### Level 3 — "I want full governance"
Enable all hooks, use agent teams, full logging. Enterprise-grade traceability.

Each level is opt-in. Use only what you need.

---

## Teams

| Team | Domain | Style |
|------|--------|-------|
| **Overseer** | Project management, architecture decisions | Balanced, cautious, standards-compliant |
| **Monolith** | Core backend, infrastructure, DB schema, cloud, docs | Verbose, type-safe, bulletproof |
| **Syndicate** | API integration, query optimization, security | Pragmatic, terse, performance-focused |
| **Arcade** | Frontend UI, gamification, creative systems | Clever, modern, innovative |
| **Cipher** | Hardware diagnostics, disk forensics, RAID recovery | Surgical, zero-write, verify-before-acting |

## Skills

### Workflow Skills
| Command | Purpose |
|---------|---------|
| `/team-start [Team] [Project] [Phase] [free\|hold]` | Formal team kickoff |
| `/phase-status [Project]` | Full project phase + ticket status |
| `/compact-resume` | Post-compact re-orientation |
| `/overseer-report [ID]` | File OverseerReport entry |

### Planning Skills
| Command | Purpose |
|---------|---------|
| `/bug-report [Project] [desc]` | Create bug fix ticket + folders |
| `/mod-log [Project] [name]` | Create modification ticket + folders |
| `/sub-feature [Project] [name]` | Create sub-feature ticket + folders |

### Quality Skills
| Command | Purpose |
|---------|---------|
| `/audit [Project] [scope?]` | End-to-end multi-domain audit — finds gap bugs |
| `/git commit [branch?]` | Governed commit — rebase, 2-pass review, ticket gate |
| `/git pr [branch?]` | Governed pull request — rebase, review, test, PR with governance gates |
| `/git lookback [period?]` | Retrospective — rebase-aware git + session data + decision audit |

### Persona Skills
| Command | Purpose |
|---------|---------|
| `/Overseer` `/Monolith` `/Syndicate` `/Arcade` `/Cipher` | Switch active team persona |

### Framework Management
| Command | Purpose |
|---------|---------|
| `/template [action]` | Version check, diff, update, rollback |

## Rules (Path-Scoped)

Policy rules in `.claude/rules/` load automatically based on file context:

| Rule | When It Loads | Key Rules |
|------|--------------|-----------|
| `governance.md` | Always | Plan-before-code, no-code-before-ticket, ticket/briefing standards, phase gates |
| `logging.md` | Always | Session logging, rotation, handover, OverseerReport, TeamChat |
| `debugging.md` | Code files (`.ts`, `.js`, `.py`, etc.) | Instrument-first, probe standards, cross-layer trace, gap bugs |
| `testing.md` | Test files (`*.test.*`, `*.spec.*`) | Unit tests, regression gates, living docs |
| `codebase-scanning.md` | Always | L1/L2/L3 tiered scan protocol, completeness checks |
| `parallel-execution.md` | Always | ZCB guarantee, ticket ownership, multi-session |
| `skills-and-subagents.md` | Always | Skill format, orchestration modes, subagent triggers |

## Hooks (Automated Enforcement)

Hooks are defined in `.claude/settings.json` under the `"hooks"` key. Scripts live in `hooks/scripts/`.

| Hook | Event | What It Does |
|------|-------|-------------|
| `SessionStart` | Session start | Confirms RoundTable governance framework is active |
| `check-ticket-exists` | PreToolUse (Edit/Write) | Warns if no ticket exists before code edits |
| `log-file-change` | PostToolUse (Edit/Write) | Logs file changes to session audit trail |
| Protected files | PreToolUse (Edit/Write) | Prompt hook — blocks edits to CLAUDE.md, policies, agents without authorization |

> **Windows note:** Hook scripts require Git Bash or WSL. Ensure `bash` and `jq` are available in your PATH. Scripts use `#!/usr/bin/env bash` shebangs and Unix path separators.

## Playwright MCP (Browser Automation)

Verification Scholars can use Playwright for UX Smoke Test Gates and User Journey Walkthroughs.
Configuration: `.mcp.json` at project root.

---

## Project Structure

```
your-project/
├── .claude/
│   ├── CLAUDE.md                # Core policy (entry point)
│   ├── ProjectEnvironment.md    # Project registry
│   ├── settings.json            # Permissions + hooks + protected file rules
│   ├── agents/                  # 5 team agent definitions
│   ├── rules/                   # 7 path-scoped rule files
│   ├── skills/                  # 21 slash command skills
│   │   ├── git/                 # Unified VCS: commit, pr, lookback
│   │   │   └── checklists/      # Critical, informational, suppressions
│   │   ├── audit/               # Multi-domain gap bug finder
│   │   └── ...
│   └── TeamDocument/
│       ├── 1. Policies/         # 9 detailed policy files
│       └── 2. TeamChat/         # Team communication logs
├── hooks/                       # Hook scripts (config in .claude/settings.json)
│   └── scripts/                 # check-ticket-exists.sh, log-file-change.sh
├── .mcp.json                    # Playwright browser automation
├── plugin.json                  # Plugin manifest
└── RoundTable/                  # Session logs (created at runtime)
```

## Policy Reference

| Policy | What It Covers |
|--------|---------------|
| §1 Logging & RoundTable | Session logging, RoundTable format, rotation policy |
| §2 Tickets & Briefings | Phase dispatch, briefing mail, ticket standards, UX smoke test |
| §3 Team Chat & Handover | Cross-team protocol, OverseerReport, handoff files |
| §4 Development Structure | Project organization, planning-first workflow, error catalog |
| §5 Pre-Existing Codebase | Tiered scan protocol (L1/L2/L3), completeness verification |
| §6 Debugging Protocol | Instrument-first rule, probe standards, gap bug detection |
| §7 Parallel Execution | ZCB guarantee, ticket ownership, dependency signals |
| §8 Skills & Subagents | Skill catalogue, orchestration modes, subagent standards |
| §9 Multi-Session | One-session-per-project, project-prefixed logging |

## Customization

RoundTable is designed to be forked and customized:

- **Rename team members** — edit agent files to match your preferred code names
- **Add/remove teams** — create new agent files or remove unused ones
- **Adjust policies** — modify policy files in `TeamDocument/1. Policies/`
- **Add skills** — create new `.claude/skills/[name]/SKILL.md` files
- **Tune rules** — edit `.claude/rules/` files to adjust enforcement level
- **Change authority naming** — replace "Commander" with your preferred title
- **Toggle hooks** — switch from warning to blocking mode in hook scripts

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI installed
- Claude API access (Anthropic API key)

## Author

**Unicorn Tech Integration Co., Ltd.**
- Website: [unicorntechint.com](https://www.unicorntechint.com)
- GitHub: [@VarakornUnicornTech](https://github.com/VarakornUnicornTech)
- Location: Bangkok, Thailand

## License

MIT License — see [LICENSE](LICENSE) for details.

---

*RoundTable Framework v2.0.0 — Built by Unicorn Tech Integration Co., Ltd.*
