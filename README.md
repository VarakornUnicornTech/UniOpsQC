# RoundTable Framework For Claude Code

A structured multi-team AI governance framework for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). RoundTable organizes your Claude Code sessions into specialized teams with defined roles, logging standards, and quality gates — turning a single AI assistant into a coordinated engineering organization.

**By [Unicorn Tech Integration Co., Ltd.](https://www.unicorntechint.com)**

---

## What Is This?

RoundTable Framework is a `.claude/` configuration template that gives Claude Code:

- **Team structure** — 4 specialized teams (Overseer, Monolith, Syndicate, Arcade) + 2 lone operatives (Cipher, Medica), each with defined roles and domain boundaries
- **Session logging** — Automatic RoundTable session logs that capture every decision, action, and output
- **Quality gates** — Planning-first workflow, verification scholar sign-off, acceptance criteria enforcement
- **Debugging protocol** — Instrument-first rule, debug probe standards, side-effect scans
- **Codebase scanning** — Tiered L1/L2/L3 scan protocol with 5-check completeness verification for pre-existing codebases
- **Parallel execution** — Zero Cross-Team Block (ZCB) guarantee, ticket ownership rules, dependency signaling
- **Skills** — Built-in slash commands for common workflows (`/audit`, `/bug-report`, `/team-start`, etc.)
- **Template management** — Built-in `/template-*` skills for version checking, diffing, updating, and rollback

## Quick Start

1. **Clone this repo** into your project:
   ```bash
   git clone https://github.com/VarakornUnicornTech/unicorn_roundtable_framework_repo.git .claude-template
   cp -r .claude-template/.claude/ your-project/.claude/
   ```

2. **Edit `.claude/ProjectEnvironment.md`** — add your project details (name, mode, paths)

3. **Start Claude Code** in your project directory — it will automatically load CLAUDE.md and adopt the team structure

4. **Choose your team** — Claude will prompt you to select a Team Roster (Overseer, Monolith, Syndicate, Arcade, Cipher, or Medica)

## Project Structure

```
.claude/
├── CLAUDE.md                    # Core policy file (entry point)
├── ProjectEnvironment.md        # Your project registry
├── settings.json                # Claude Code permissions
├── TeamDocument/
│   ├── 1. Policies/            # 8 modular policy files
│   ├── 2. Team Roster/         # 6 team definitions
│   ├── 3. Team Chat/           # Team communication logs
│   ├── Diagnostic Log/         # Cipher engagement records
│   └── Medical Reference/      # Medica reference library
└── skills/                     # Custom slash commands
```

## Teams

| Team | Domain | Roles |
|------|--------|-------|
| **Overseer** | Project management, architecture decisions | KP (Conductor), MT (Technologist), PM (Design Scholar), V (Verification Scholar) |
| **Monolith** | Core backend, infrastructure, DB schema, cloud, docs | AT (Conductor), SC (Technologist), EN (Design Scholar), PF (Verification Scholar) |
| **Syndicate** | API integration, query optimization, security | DR (Conductor), AX (Technologist), LX (Design Scholar), WT (Verification Scholar) |
| **Arcade** | Frontend UI, gamification, creative systems | CP (Conductor), GL (Technologist), PX (Design Scholar), HS (Verification Scholar) |
| **Cipher** | Hardware diagnostics, disk forensics, RAID recovery | CI (Lone Operative) |
| **Medica** | Clinical reference, medical knowledge | MD (Lone Operative) |

## Policy Reference

| Policy | What It Covers |
|--------|---------------|
| §1 Logging & RoundTable | Session logging, RoundTable format, rotation policy |
| §2 Tickets & Briefings | Phase dispatch, briefing mail, ticket standards |
| §3 Team Chat & Handover | Cross-team protocol, OverseerReport, handoff files |
| §4 Development Structure | Project organization, planning-first workflow |
| §5 Pre-Existing Codebase | Tiered scan protocol (L1/L2/L3), completeness verification |
| §6 Debugging Protocol | Instrument-first rule, probe standards, side-effect scan |
| §7 Parallel Execution | ZCB guarantee, ticket ownership, dependency signals |
| §8 Skills & Subagents | Skill catalogue, orchestration modes, subagent standards |

## Customization

RoundTable is designed to be forked and customized:

- **Rename team members** — edit Team Roster files to match your preferred code names
- **Add/remove teams** — create new roster files or remove unused ones
- **Adjust policies** — modify policy files to match your project's needs
- **Add skills** — create new `.claude/skills/[name]/SKILL.md` files
- **Change authority naming** — replace "Chief Manager Martin" with your preferred authority title

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

*RoundTable Framework v1.0.0 — Built by Unicorn Tech Integration Co., Ltd.*
