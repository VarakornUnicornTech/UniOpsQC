<p align="center">
  <img src="assets/roundtable-banner.png" alt="UniOps Quantum Cycle" width="100%">
</p>

<p align="center">
  <a href="https://github.com/VarakornUnicornTech/UniOpsQC/releases"><img src="https://img.shields.io/badge/version-2.0.0-0d6efd?style=flat-square" alt="Version"></a>
  <img src="https://img.shields.io/github/license/VarakornUnicornTech/UniOpsQC?style=flat-square" alt="License">
  <img src="https://img.shields.io/github/stars/VarakornUnicornTech/UniOpsQC?style=flat-square&color=f0a500" alt="Stars">
  <img src="https://img.shields.io/github/forks/VarakornUnicornTech/UniOpsQC?style=flat-square" alt="Forks">
  <img src="https://img.shields.io/github/last-commit/VarakornUnicornTech/UniOpsQC?style=flat-square" alt="Last Commit">
  <img src="https://img.shields.io/badge/Claude%20Code-compatible-7c3aed?style=flat-square" alt="Claude Code compatible">
  <img src="https://img.shields.io/badge/made%20in-Thailand%20🇹🇭-e63946?style=flat-square" alt="Made in Thailand">
  <a href="https://discord.gg/SwYzZjru"><img src="https://img.shields.io/badge/Discord-Join%20Community-5865F2?style=flat-square&logo=discord&logoColor=white" alt="Discord"></a>
</p>

<p align="center">
  <strong>🇬🇧 English:</strong> <a href="README.md">Read README in English</a>
</p>

---

> [!NOTE]
> **ระบบบริหารจัดการทีม AI สำหรับ Claude Code — ship ด้วยความมั่นใจ ไม่ใช่แค่ความเร็ว**
> เปลี่ยน Claude Code ให้กลายเป็นองค์กรวิศวกรรมที่ทำงานประสานกัน ด้วยทีมเฉพาะทาง approval gate นโยบายที่บังคับใช้อัตโนมัติ และ audit trail ครบถ้วน

**โดย [Unicorn Tech Integration Co., Ltd.](https://www.unicorntechint.com)**

---

## สารบัญ

- [ทำไมต้อง UniOps Quantum Cycle?](#-ทำไมต้อง-uniops-quantum-cycle)
- [เริ่มต้นใช้งาน](#-เริ่มต้นใช้งาน)
- [3 ระดับการใช้งาน](#-3-ระดับการใช้งาน)
- [VSCode Extension](#-vscode-extension-uniopsqc-hub)
- [ทีม](#-ทีม)
- [Skills](#-skills)
- [Rules & Hooks](#-rules-path-scoped)
- [โครงสร้างโปรเจค](#-โครงสร้างโปรเจค)
- [นโยบาย](#-นโยบาย)
- [การปรับแต่ง](#-การปรับแต่ง)
- [ความต้องการของระบบ](#-ความต้องการของระบบ)

---

## 🤔 ทำไมต้อง UniOps Quantum Cycle?

<table>
<tr>
  <td align="center" width="20%">🏗️<br><b>5 ทีม</b><br><sub>16 personas เฉพาะทาง</sub></td>
  <td align="center" width="20%">📋<br><b>Phase Gates</b><br><sub>ขั้นตอนผ่าน ticket</sub></td>
  <td align="center" width="20%">🔍<br><b>Audit Trail ครบถ้วน</b><br><sub>บันทึกทุกการตัดสินใจ</sub></td>
  <td align="center" width="20%">⚡<br><b>21 Skills</b><br><sub>Slash command พร้อมใช้</sub></td>
  <td align="center" width="20%">🛡️<br><b>Policy Engine</b><br><sub>มาตรฐาน 9 ข้อ</sub></td>
</tr>
</table>

| | Claude Code ทั่วไป | **UniOps Quantum Cycle** |
|---|---|---|
| **โครงสร้าง** | Single assistant | ✅ 5 ทีม + 16 personas |
| **การวางแผน** | 🔧 ไม่มีระบบ | ✅ Phase dispatch + ticket gates |
| **Code Review** | 🔧 ตรวจเอง | ✅ 2-pass + cross-layer trace |
| **การ Ship** | 🔧 git manual | ✅ `/git pr` พร้อม governance gates |
| **QA** | 🔧 ตรวจเอง | ✅ Playwright MCP + smoke test gates |
| **Retrospective** | ❌ ไม่มี | ✅ git + session data + decision audit |
| **Governance** | ❌ ไม่มี | ✅ ลำดับชั้นครบ + approval gates |
| **Audit Trail** | ❌ ไม่มี | ✅ บันทึกและตรวจสอบได้ทุกการตัดสินใจ |
| **Multi-Team** | ❌ ไม่ได้ | ✅ 4 ทีม + parallel execution |
| **ติดตั้ง** | — | ⚡ ~30 วินาที |

---

## 🚀 เริ่มต้นใช้งาน

### ติดตั้งผ่าน Claude Code (แนะนำ)

คัดลอก prompt ด้านล่างแล้ววางลงใน Claude Code:

**🇹🇭 ภาษาไทย:**
```
ติดตั้ง UniOps Quantum Cycle จาก https://github.com/VarakornUnicornTech/UniOpsQC ลงใน project ปัจจุบัน ตาม Getting Started ที่ https://github.com/VarakornUnicornTech/UniOpsQC/wiki/Getting-Started
```

**🇬🇧 English:**
```
Install UniOps Quantum Cycle from https://github.com/VarakornUnicornTech/UniOpsQC into my current project. Follow the Getting Started guide at https://github.com/VarakornUnicornTech/UniOpsQC/wiki/Getting-Started
```

> [!TIP]
> ใช้คำว่า **"ติดตั้ง"** หรือ **"install"** — ไม่ใช่ "อ่าน", "อธิบาย" หรือ "ศึกษา rules"
> การพูดถึง ".claude rules" ทำให้ Claude อ่านไฟล์ policy ทุกไฟล์ก่อนเริ่มติดตั้ง — ช้ากว่ามาก

### ติดตั้งด้วยตัวเอง (Manual Install)

> [!NOTE]
> เปลี่ยน `C:/Projects/my-project` ในคำสั่งด้านล่างให้เป็น **path จริงของโฟลเดอร์โปรเจคของคุณ** — โฟลเดอร์ที่ต้องการติดตั้ง UniOps Quantum Cycle

**Bash / Git Bash / macOS / Linux:**
```bash
git clone https://github.com/VarakornUnicornTech/UniOpsQC.git .claude-template
cp -r .claude-template/.claude/ C:/Projects/my-project/.claude/
cp .claude-template/template-version.json C:/Projects/my-project/template-version.json
cp .claude-template/plugin.json C:/Projects/my-project/plugin.json
cp .claude-template/.mcp.json C:/Projects/my-project/.mcp.json
cp -r .claude-template/hooks/ C:/Projects/my-project/hooks/
rm -rf .claude-template
```

**PowerShell (Windows):**
```powershell
git clone https://github.com/VarakornUnicornTech/UniOpsQC.git .claude-template
Copy-Item -Recurse .claude-template\.claude\ C:\Projects\my-project\.claude\
Copy-Item .claude-template\template-version.json C:\Projects\my-project\template-version.json
Copy-Item .claude-template\plugin.json C:\Projects\my-project\plugin.json
Copy-Item .claude-template\.mcp.json C:\Projects\my-project\.mcp.json
Copy-Item -Recurse .claude-template\hooks\ C:\Projects\my-project\hooks\
Remove-Item -Recurse -Force .claude-template
```

> [!TIP]
> หลังติดตั้ง แก้ไข `.claude/ProjectEnvironment.md` ด้วยชื่อโปรเจคและ path ก่อนเปิด Claude Code เป็นครั้งแรก

> [!NOTE]
> **Windows — Hook scripts ต้องใช้ `jq`:** ติดตั้งผ่าน [winget](https://winget.run/pkg/jqlang/jq) (`winget install jqlang.jq`) หรือ [Chocolatey](https://chocolatey.org/) (`choco install jq`) แล้ว restart terminal ถ้าไม่มี `jq` hook scripts จะไม่ทำงาน
>
> **Playwright MCP (optional):** ต้องการเฉพาะเมื่อใช้ browser automation สำหรับ UX smoke tests ติดตั้ง [Node.js](https://nodejs.org/) แล้วรัน `npx playwright install` ในโปรเจค

---

## 🎯 3 ระดับการใช้งาน

> [!TIP]
> แต่ละระดับเป็น opt-in ทั้งหมด เริ่มจาก Level 1 แล้วขยายตามความต้องการ

<table>
<tr>
  <td align="center" width="33%">
    <h3>🚀 Level 1</h3>
    <b>"แค่อยากให้ ship ได้ดีขึ้น"</b><br><br>
    <sub>ใช้ <code>/git commit</code> และ <code>/git pr</code><br>
    ไม่มี governance overhead — แค่ ship ได้ดีขึ้น</sub>
  </td>
  <td align="center" width="33%">
    <h3>🏗️ Level 2</h3>
    <b>"อยากมีโครงสร้างโปรเจค"</b><br><br>
    <sub>ใช้ <code>/team-start</code>, <code>/phase-status</code>, <code>/bug-report</code><br>
    พัฒนาแบบ phase-based โดยไม่ต้องจำลองทีมเต็มรูปแบบ</sub>
  </td>
  <td align="center" width="33%">
    <h3>🏛️ Level 3</h3>
    <b>"อยากได้ governance เต็มรูปแบบ"</b><br><br>
    <sub>เปิด hooks ทั้งหมด ใช้ agent teams บันทึกครบถ้วน<br>
    ระดับ enterprise ออกจากกล่อง</sub>
  </td>
</tr>
</table>

---

## 💻 VSCode Extension (UniOpsQC Hub)

**UniOpsQC Hub** คือ extension ของ VSCode ที่ใช้งานควบคู่กับ Claude Code ให้คุณมี dashboard แบบ visual ขณะทำงาน

**ติดตั้ง:** ค้นหา `UniOpsQC Hub` หรือ `RoundTable Hub` ใน VSCode Marketplace หรือติดตั้งด้วย extension ID `unicorntech.roundhub`

### Extension ทำอะไรได้บ้าง

Extension **ไม่ได้รัน Claude Code** — มันคือ **command launcher และ log viewer** ที่ทำงานควบคู่กับ CLI

| ปุ่ม | ทำอะไร |
|------|--------|
| **Quick Actions** | คัดลอก `/command` ไปยัง clipboard — วางลงใน Claude Code เพื่อรัน |
| **SESSION LOGS** | แสดงไฟล์ RoundTable session log ของโปรเจคที่ active อยู่ |
| **FRAMEWORK STATUS** | แสดง version ของ framework ที่ติดตั้ง (ต้องมี `.git` repository) |
| **Push to Hub** | ซิงค์ RoundTable logs ขึ้น cloud dashboard (ฟีเจอร์สำหรับสมาชิก — ยังไม่เปิดใช้งาน) |
| **Update Preview** | คัดลอกคำสั่ง `/template preview` ไปยัง clipboard — วางลงใน Claude Code เพื่อรัน |
| **Refresh** | โหลดหน้า panel ใหม่เพื่อดูไฟล์ล่าสุด |

### 2 Version — แต่ละอันคืออะไร

panel ของ extension แสดงตัวเลข version 2 ตัว:

| Version | คืออะไร | มาจากไหน |
|---------|---------|----------|
| **Framework version** (เช่น `v2.0.0`) | Version ของ template UniOpsQC | อ่านจาก `.git` tags หรือ `template-version.json` ในโปรเจค |
| **Extension version** (เช่น `v1.6.0`) | Version ของ VSCode extension เอง | Release version ของ extension ใน Marketplace |

> [!TIP]
> Framework และ Extension ใช้ version แยกกัน — Extension ใหม่กว่าไม่ได้แปลว่า Framework ใหม่กว่า และในทางกลับกัน

### Centralized vs. Decentralized Project

เมื่อเพิ่มโปรเจคใน extension จะถามหา **Project Name** และ **Project Root** UniOpsQC รองรับ 2 โหมด (กำหนดใน `.claude/ProjectEnvironment.md`):

| โหมด | ใช้เมื่อ | Project Root ชี้ไปที่ |
|------|---------|----------------------|
| **Centralized** | โปรเจคใหม่หรือทำคนเดียว | โฟลเดอร์ที่มีทั้ง `.claude/` และ source code |
| **Decentralized** | codebase ที่มีอยู่แล้ว | โฟลเดอร์ planning hub (ที่มี `.claude/`) แยกจาก source code |

---

## 👥 ทีม

```mermaid
graph TD
    Commander["👑 Commander<br/>(คุณ)"]
    AM["🎯 Overseer<br/>AM · MT · AS"]
    MON["🏗️ Monolith<br/>Backend · DB · Cloud"]
    SYN["⚡ Syndicate<br/>API · Security"]
    ARC["🎨 Arcade<br/>Frontend · UI"]
    CI["🔬 Cipher<br/>Forensics · Recovery"]

    Commander --> AM
    Commander --> CI
    AM --> MON
    AM --> SYN
    AM --> ARC

    style Commander fill:#f0a500,color:#000,stroke:#f0a500
    style AM fill:#1e6fb5,color:#fff,stroke:#1e6fb5
    style MON fill:#1a7a4a,color:#fff,stroke:#1a7a4a
    style SYN fill:#b52020,color:#fff,stroke:#b52020
    style ARC fill:#7c3aed,color:#fff,stroke:#7c3aed
    style CI fill:#444,color:#fff,stroke:#666
```

| ทีม | ขอบเขต | สไตล์ |
|-----|--------|-------|
| **Overseer** | บริหารโปรเจค, ตัดสินใจด้านสถาปัตยกรรม | สมดุล, รอบคอบ, ปฏิบัติตามมาตรฐาน |
| **Monolith** | Backend หลัก, Infrastructure, DB schema, Cloud, เอกสาร | Verbose, type-safe, bulletproof |
| **Syndicate** | API integration, Query optimization, Security | Pragmatic, กระชับ, มุ่งประสิทธิภาพ |
| **Arcade** | Frontend UI, Gamification, ระบบสร้างสรรค์ | ชาญฉลาด, ทันสมัย, สร้างสรรค์ |
| **Cipher** | วินิจฉัยฮาร์ดแวร์, Disk forensics, กู้คืน RAID | ผ่าตัดแม่นยำ, zero-write, ตรวจสอบก่อนลงมือ |

---

## ⚡ Skills

| Category | Command | ความสามารถ |
|----------|---------|-----------|
| 🔄 **Workflow** | `/team-start [Team] [Project] [Phase] [free\|hold]` | เริ่มต้นทีมอย่างเป็นทางการ |
| 🔄 **Workflow** | `/phase-status [Project]` | รายงาน phase + สถานะ ticket ทั้งหมด |
| 🔄 **Workflow** | `/compact-resume` | กลับเข้า session หลัง compact |
| 🔄 **Workflow** | `/overseer-report [ID]` | บันทึก OverseerReport |
| 📋 **Planning** | `/bug-report [Project] [desc]` | สร้าง bug fix ticket + โฟลเดอร์ |
| 📋 **Planning** | `/mod-log [Project] [name]` | สร้าง modification ticket + โฟลเดอร์ |
| 📋 **Planning** | `/sub-feature [Project] [name]` | สร้าง sub-feature ticket + โฟลเดอร์ |
| ✅ **Quality** | `/audit [Project] [scope?]` | Audit แบบ end-to-end — หา gap bugs |
| ✅ **Quality** | `/git status` | Quick git state overview — branch, divergence, working tree |
| ✅ **Quality** | `/git commit [branch?]` | Governed commit — safety gates, 2-pass review, ticket gate |
| ✅ **Quality** | `/git pr [branch?]` | Governed PR — safety gates, review, test, push, pull request |
| ✅ **Quality** | `/git sync [remote?] [branch?]` | Governed sync — fetch upstream/origin, compare, merge/rebase |
| ✅ **Quality** | `/git lookback [period?]` | Retrospective — git + session data + decision audit |
| 🎭 **Persona** | `/Overseer` `/Monolith` `/Syndicate` `/Arcade` `/Cipher` | สลับ persona ของทีม |
| 🔧 **Framework** | `/template [action]` | Version check, diff, update, rollback |

---

## 📐 Rules (Path-Scoped)

ไฟล์ rule ใน `.claude/rules/` โหลดอัตโนมัติตาม context ของไฟล์:

| Rule | เมื่อโหลด | บังคับใช้ |
|------|----------|----------|
| `governance.md` | ทุกไฟล์ | Plan-before-code, no-code-before-ticket, ticket/briefing standards, phase gates |
| `logging.md` | ทุกไฟล์ | Session logging, rotation, handover, OverseerReport, TeamChat |
| `debugging.md` | Code files (`.ts`, `.js`, `.py` ฯลฯ) | Instrument-first, probe standards, cross-layer trace |
| `testing.md` | Test files (`*.test.*`, `*.spec.*`) | Unit tests, regression gates, living docs |
| `codebase-scanning.md` | ทุกไฟล์ | L1/L2/L3 tiered scan protocol, completeness checks |
| `parallel-execution.md` | ทุกไฟล์ | ZCB guarantee, ticket ownership, multi-session |
| `skills-and-subagents.md` | ทุกไฟล์ | Skill format, orchestration modes, subagent triggers |

## 🪝 Hooks (Automated Enforcement)

Hooks กำหนดใน `.claude/settings.json` ภายใต้ key `"hooks"` Scripts อยู่ใน `hooks/scripts/`

| Hook | Event | ทำอะไร |
|------|-------|--------|
| `SessionStart` | เริ่ม session | ยืนยันว่า RoundTable governance framework ทำงานอยู่ |
| `check-ticket-exists` | PreToolUse (Edit/Write) | เตือนถ้าไม่มี ticket ก่อนแก้ไขโค้ด |
| `log-file-change` | PostToolUse (Edit/Write) | บันทึกการเปลี่ยนแปลงไฟล์ลง audit trail |
| Protected files | PreToolUse (Edit/Write) | Prompt hook — บล็อกการแก้ไข CLAUDE.md, policies, agents โดยไม่ได้รับอนุญาต |

> [!WARNING]
> **Windows:** Hook scripts ต้องใช้ Git Bash หรือ WSL ตรวจสอบให้แน่ใจว่า `bash` และ `jq` อยู่ใน PATH Scripts ใช้ shebangs `#!/usr/bin/env bash` และ Unix path separators

---

## 🎭 Playwright MCP (Browser Automation)

Verification Scholars ใช้ Playwright สำหรับ UX Smoke Test Gates และ User Journey Walkthroughs
Configuration: `.mcp.json` ที่ root ของโปรเจค

---

## 📁 โครงสร้างโปรเจค

```
your-project/
├── .claude/
│   ├── CLAUDE.md                # นโยบายหลัก (จุดเริ่มต้น)
│   ├── ProjectEnvironment.md    # ทะเบียนโปรเจค
│   ├── settings.json            # Permissions + hooks + protected file rules
│   ├── agents/                  # นิยามทีม 5 ทีม
│   ├── rules/                   # 7 ไฟล์กฎตามเส้นทาง
│   ├── skills/                  # Slash command 21 รายการ
│   │   ├── git/                 # VCS รวม: status, commit, pr, sync, lookback
│   │   │   └── checklists/      # Critical, informational, suppressions
│   │   ├── audit/               # Multi-domain gap bug finder
│   │   └── ...
│   ├── policies/                # ไฟล์นโยบาย 9 ฉบับ (§1–§9)
│   └── team_chat/               # บันทึกการสื่อสารระหว่างทีม + Cipher
├── hooks/                       # Hook scripts (config ใน .claude/settings.json)
│   └── scripts/                 # check-git-workflow.sh, check-ticket-exists.sh, log-file-change.sh
├── .mcp.json                    # Playwright browser automation
├── plugin.json                  # Plugin manifest
└── RoundTable/                  # Session logs (สร้างตอน runtime)
```

---

## 📋 นโยบาย

<details>
<summary>📋 ดูนโยบายทั้ง 9 ข้อ (§1–§9)</summary>

| นโยบาย | ครอบคลุมเรื่อง |
|--------|--------------|
| §1 Logging & RoundTable | การบันทึก session, รูปแบบ log, นโยบายหมุนเวียนไฟล์ |
| §2 Tickets & Briefings | การ dispatch phase, briefing mail, มาตรฐาน ticket, UX smoke test |
| §3 Team Chat & Handover | โปรโตคอลข้ามทีม, OverseerReport, ไฟล์ส่งต่องาน |
| §4 Development Structure | การจัดระเบียบโปรเจค, planning-first workflow, error catalog |
| §5 Pre-Existing Codebase | Tiered Scan Protocol (L1/L2/L3), การตรวจสอบความสมบูรณ์ |
| §6 Debugging Protocol | กฎ Instrument-First, มาตรฐาน probe, สแกนผลกระทบข้างเคียง |
| §7 Parallel Execution | ZCB guarantee, ความเป็นเจ้าของ ticket, สัญญาณ dependency |
| §8 Skills & Subagents | รายการ skill, โหมดการ orchestrate, มาตรฐาน subagent |
| §9 Multi-Session | One-session-per-project, project-prefixed logging |

</details>

---

## 🔧 การปรับแต่ง

<details>
<summary>🔧 วิธีปรับแต่ง UniOps Quantum Cycle สำหรับโปรเจคของคุณ</summary>

UniOps Quantum Cycle ออกแบบมาให้ fork และปรับแต่งได้:

- **เปลี่ยนชื่อสมาชิกทีม** — แก้ไขไฟล์ agent ให้ตรงกับชื่อรหัสที่คุณต้องการ
- **เพิ่ม/ลบทีม** — สร้างไฟล์ agent ใหม่หรือลบที่ไม่ใช้
- **ปรับนโยบาย** — แก้ไขไฟล์นโยบายใน `policies/` ให้เหมาะกับโปรเจค
- **เพิ่ม skill** — สร้างไฟล์ `.claude/skills/[name]/SKILL.md` ใหม่
- **ปรับระดับ enforcement** — แก้ไขไฟล์ใน `.claude/rules/`
- **เปลี่ยนชื่อผู้มีอำนาจ** — แทนที่ "Commander" ด้วยตำแหน่งที่คุณต้องการ
- **Toggle hooks** — สลับระหว่าง warning กับ blocking mode ใน hook scripts

</details>

---

## 📦 ความต้องการของระบบ

- ติดตั้ง [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- มี Claude API access (Anthropic API key)

## 👤 ผู้พัฒนา

**Unicorn Tech Integration Co., Ltd.**
- เว็บไซต์: [unicorntechint.com](https://www.unicorntechint.com)
- GitHub: [@VarakornUnicornTech](https://github.com/VarakornUnicornTech)
- Discord: [เข้าร่วม community](https://discord.gg/SwYzZjru)
- สถานที่: กรุงเทพมหานคร, ประเทศไทย

## ⚖️ สัญญาอนุญาต

MIT License — ดูรายละเอียดที่ [LICENSE](LICENSE)

---

<p align="center">
  <img src="assets/roundtable-icon.png" alt="UniOps Quantum Cycle" width="72">
</p>
<p align="center">
  <b>UniOps Quantum Cycle v2.0.0</b><br>
  สร้างด้วย ❤️ โดย <a href="https://www.unicorntechint.com">Unicorn Tech Integration Co., Ltd.</a>
  · กรุงเทพมหานคร, ประเทศไทย 🇹🇭
</p>
<p align="center">
  <a href="GETTING_STARTED.md">Getting Started</a> ·
  <a href="CONTRIBUTING.md">Contributing</a> ·
  <a href="CHANGELOG.md">Changelog</a> ·
  <a href="https://discord.gg/SwYzZjru">Discord</a> ·
  <a href="LICENSE">License</a>
</p>
