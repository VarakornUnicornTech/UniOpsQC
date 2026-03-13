# RoundTable Framework For Claude Code

> **ภาษาไทย / Thai:** [อ่าน README ภาษาไทย](README.th.md)

A structured multi-team AI governance framework for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). RoundTable organizes your Claude Code sessions into specialized teams with defined roles, logging standards, and quality gates — turning a single AI assistant into a coordinated engineering organization.

**By [Unicorn Tech Integration Co., Ltd.](https://www.unicorntechint.com)**

---

## What Is This?

RoundTable Framework is a `.claude/` configuration template that gives Claude Code:

- **Team structure** — 4 specialized teams (Overseer, Monolith, Syndicate, Arcade) + 1 lone operative (Cipher), each with defined roles and domain boundaries
- **Session logging** — Automatic RoundTable session logs that capture every decision, action, and output
- **Quality gates** — Planning-first workflow, verification scholar sign-off, acceptance criteria enforcement
- **Debugging protocol** — Instrument-first rule, debug probe standards, side-effect scans
- **Codebase scanning** — Tiered L1/L2/L3 scan protocol with 5-check completeness verification for pre-existing codebases
- **Parallel execution** — Zero Cross-Team Block (ZCB) guarantee, ticket ownership rules, dependency signaling
- **Skills** — Built-in slash commands for common workflows (`/audit`, `/bug-report`, `/team-start`, etc.)
- **Template management** — Built-in `/template-*` skills for version checking, diffing, updating, and rollback

## Install via Claude Code (Recommended)

Copy one of these prompts and paste it directly into Claude Code:

**English:**
```
Install the RoundTable Framework from https://github.com/VarakornUnicornTech/unicorn_roundtable_framework_repo into my current project. Follow the Getting Started guide at https://github.com/VarakornUnicornTech/unicorn_roundtable_framework_repo/wiki/Getting-Started
```

**Thai / ภาษาไทย:**
```
ติดตั้ง RoundTable Framework จาก https://github.com/VarakornUnicornTech/unicorn_roundtable_framework_repo ลงใน project ปัจจุบัน ตาม Getting Started ที่ https://github.com/VarakornUnicornTech/unicorn_roundtable_framework_repo/wiki/Getting-Started
```

> ### ⚠️ Important Tips / ข้อควรระวัง
>
> **Use the word "install" — not "read", "explain", or "set up the rules".**
> If your prompt mentions `.claude rules` or asks Claude to "understand" the framework first, Claude Code will read every policy file inside `.claude/` before starting installation — this makes the process significantly slower.
>
> **ใช้คำว่า "ติดตั้ง" (install) — ไม่ใช่ "อ่าน", "อธิบาย", หรือ "ศึกษา rules"**
> ถ้า prompt ของคุณพูดถึง `.claude rules` หรือขอให้ Claude "เข้าใจ" framework ก่อน Claude Code จะอ่านไฟล์ policy ทุกไฟล์ในโฟลเดอร์ `.claude/` ก่อนเริ่มติดตั้ง — ทำให้กระบวนการช้าลงมาก
>
> | Prompt | Speed | Why |
> |--------|-------|-----|
> | ✅ *"Install RoundTable Framework from [URL] into my project"* | **Fast** | Claude goes straight to installation |
> | ✅ *"ติดตั้ง RoundTable Framework จาก [URL] ลงใน project ปัจจุบัน"* | **Fast** | Claude ติดตั้งเลย |
> | ❌ *"I'm interested in this .claude rule, can you set it up?"* | **Slow** | Claude reads all .claude/ files first |
> | ❌ *"อยากลองใช้ .claude rule นี้ ช่วย setup ให้หน่อย"* | **Slow** | Claude อ่านไฟล์ทั้งหมดก่อน |

---

## Manual Install (Quick Start)

1. **Clone this repo** into your project:

   **Bash / Git Bash / macOS / Linux:**
   ```bash
   git clone https://github.com/VarakornUnicornTech/unicorn_roundtable_framework_repo.git .claude-template
   cp -r .claude-template/.claude/ your-project/.claude/
   rm -rf .claude-template
   ```

   **PowerShell (Windows):**
   ```powershell
   git clone https://github.com/VarakornUnicornTech/unicorn_roundtable_framework_repo.git .claude-template
   Copy-Item -Recurse .claude-template\.claude\ your-project\.claude\
   Remove-Item -Recurse -Force .claude-template
   ```

   > **Note:** If you install via Claude Code, it runs commands through Git Bash automatically — no need to worry about OS differences.

2. **Edit `.claude/ProjectEnvironment.md`** — add your project details (name, mode, paths). See the field reference and examples inside the file.

3. **Customize your authority name** — The framework uses "Commander ท่านผู้บัญชาการ" as the default authority title. To personalize, find-and-replace `Commander ท่านผู้บัญชาการ` with your preferred title in `.claude/CLAUDE.md`.

4. **Start Claude Code** in your project directory — it will automatically load CLAUDE.md and adopt the team structure

5. **Choose your team** — Claude will load the appropriate agent file (Overseer, Monolith, Syndicate, Arcade, or Cipher)

## Project Structure

```
.claude/
├── CLAUDE.md                    # Core policy file (entry point)
├── ProjectEnvironment.md        # Your project registry
├── settings.json                # Claude Code permissions
├── TeamDocument/
│   ├── 1. Policies/            # 8 modular policy files
│   ├── 2. Team Roster/         # 5 team definitions
│   ├── 3. Team Chat/           # Team communication logs
│   ├── Diagnostic Log/         # Cipher engagement records
└── skills/                     # Custom slash commands
```

## Teams

| Team | Domain | Roles |
|------|--------|-------|
| **Overseer** | Project management, architecture decisions | AM (Conductor), MT (Technologist), AS (Design & Verification Scholar) |
| **Monolith** | Core backend, infrastructure, DB schema, cloud, docs | AT (Conductor), SC (Technologist), EN (Design Scholar), PF (Verification Scholar) |
| **Syndicate** | API integration, query optimization, security | DR (Conductor), AX (Technologist), LX (Design Scholar), WT (Verification Scholar) |
| **Arcade** | Frontend UI, gamification, creative systems | CP (Conductor), GL (Technologist), PX (Design Scholar), HS (Verification Scholar) |
| **Cipher** | Hardware diagnostics, disk forensics, RAID recovery | CI (Lone Operative) |

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
- **Change authority naming** — replace "Commander ท่านผู้บัญชาการ" with your preferred authority title

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
