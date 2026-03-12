# Getting Started with RoundTable Framework

Welcome to **RoundTable** — a multi-team AI governance framework for Claude Code.

This guide will walk you through your first session in under 5 minutes.

---

## What You Just Installed

RoundTable organizes your Claude Code sessions into **teams with defined roles**, enforced logging, and structured workflows. Think of it as a "virtual dev studio" where each AI team has a specific job:

| Team | Role | Best For |
|------|------|----------|
| **Overseer** | Project management, coordination | Architecture decisions, planning, task routing |
| **Monolith** | Backend, infrastructure, docs | Database, cloud, stability, documentation |
| **Syndicate** | API, optimization, security | Integration, query tuning, security audits |
| **Arcade** | Frontend, creative, UI | User interfaces, gamification, visual design |
| **Cipher** | Forensics (solo operative) | Hardware diagnostics, data recovery, disk analysis |

---

## Your First Session (5 minutes)

### Step 1: Open Claude Code in your project

Make sure you're in the workspace where RoundTable was installed. You should see a `.claude/` folder.

### Step 2: Start talking to Claude Code

Claude Code will automatically read `.claude/CLAUDE.md` and adopt the RoundTable system. Just start a conversation:

```
You: สวัสดีครับ เริ่มงานวันนี้
```

Claude will initialize as **Team Overseer (AM)** by default, open today's RoundTable log, and await your direction.

### Step 3: Configure your project

Tell Claude to set up your project environment:

```
You: ตั้งค่า ProjectEnvironment สำหรับโปรเจค MyApp mode Centralized
```

Or in English:

```
You: Set up ProjectEnvironment for project MyApp in Centralized mode
```

This updates `.claude/ProjectEnvironment.md` — the lookup table all teams use to find your code.

### Step 4: Give your first task

Now just tell Claude what you need:

```
You: วิเคราะห์โครงสร้างโค้ดปัจจุบันให้หน่อย
```

```
You: Analyze the current codebase structure
```

Claude (as Overseer) will route the task to the right team, create a plan, and ask for your approval before implementing.

---

## Key Commands (Slash Commands)

These slash commands automate common workflows:

| Command | What It Does | When to Use |
|---------|-------------|-------------|
| `/roundtable-open` | Start a new session log entry | Beginning of every conversation |
| `/ticket-create MON-01 MyTask` | Create a structured task ticket | When assigning specific work |
| `/briefing-create Monolith 1` | Generate a phase briefing for a team | When kicking off a new phase |
| `/overseer-report MON-01` | File a completion report | When a task is done |
| `/audit MyProject` | Run a multi-domain code audit | When you need a thorough code review |
| `/l3-scan MyProject` | Deep scan of existing codebase | When onboarding a new codebase |

---

## How It Works

### The Planning-First Rule

When you ask Claude to build something, it will:

1. **Create a plan document first** (not jump into code)
2. **Present the plan for your approval**
3. **Only implement after you say "go"**

This prevents wasted work and keeps you in control.

### The Logging System

Every session is logged in `RoundTable/DD-MM-YYYY_RoundTable.md`. This gives you:

- A complete history of decisions made
- Traceability for who did what and why
- Easy handoff between sessions (even after `/compact`)

### Team Routing

You don't need to remember which team does what. Just describe your task and Overseer (AM) will route it:

- *"Fix the login API"* → Syndicate
- *"Redesign the dashboard"* → Arcade
- *"Set up the database schema"* → Monolith
- *"Check why the disk is failing"* → Cipher

---

## Project Modes

| Mode | When to Use |
|------|-------------|
| **Centralized** | Planning docs and source code live in the same repo |
| **Decentralized** | Planning hub is separate from source code (e.g., multiple client repos) |

Most single-project setups should use **Centralized**.

---

## File Structure Reference

```
your-project/
├── .claude/
│   ├── CLAUDE.md              ← Core governance rules (auto-loaded)
│   ├── ProjectEnvironment.md  ← Your project registry
│   ├── settings.json          ← Hook configuration
│   ├── policies/              ← 7 policy files (loaded on-demand)
│   ├── Team Roster/           ← Team identity definitions
│   ├── agents/                ← Subagent definitions
│   ├── skills/                ← Slash command automations
│   └── Team Chat/             ← Team daily logs
├── RoundTable/                ← Master session logs
└── Development/               ← Planning docs & implementation logs
```

---

## Tips for Best Results

1. **Be the Commander** — You are "Commander ท่านผู้บัญชาการ", the highest authority. All teams report to you.
2. **Approve plans before implementation** — Claude will always ask. Say "ทำเลย" or "go ahead" to approve.
3. **Use Thai or English** — RoundTable works in both languages seamlessly.
4. **Don't worry about logging** — Claude handles all RoundTable entries automatically.
5. **Start simple** — You don't need to use all teams on day one. Overseer alone handles most tasks.

---

## Need Help?

- **Framework docs:** Check `.claude/policies/` for detailed standards
- **Team details:** Read `.claude/Team Roster/` for each team's capabilities
- **Issues:** [Report on GitHub](https://github.com/VarakornUnicornTech/unicorn_roundtable_framework_repo/issues)

---

*RoundTable Framework by Unicorn Tech Int Co.,Ltd.*
