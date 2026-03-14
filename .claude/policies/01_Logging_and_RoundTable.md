# §1 — Logging Requirements & RoundTable Standards

> **Policy reference file.** Loaded on-demand from `.claude/policies/`. Core rules live in CLAUDE.md.

---

## RoundTable (AM/Overseer ONLY)

> **SESSION START RULE — NON-NEGOTIABLE:**
> AM must create or append to `RoundTable/DD-MM-YYYY_RoundTable.md` as the **absolute first action of every session** — before any analysis, before any code scan, before any response to Commander's work prompt. This applies at session start, after `/compact`, and after any context resume. There are no exceptions. A session with no RoundTable entry is a protocol violation regardless of how minor the work appears.

> **PER-INTERACTION LOGGING RULE — NON-NEGOTIABLE:**
> Every prompt received from Commander, and the team's response to it, **must be logged as a session entry in the RoundTable before the conversation moves on.** This is not optional and does not depend on whether the exchange involves a decision, a task, or just a question. Every exchange = one logged session entry. There is no minimum complexity threshold — even a one-line answer to a short question gets logged. The RoundTable must reflect the complete interaction record of the session, not just the start and end.

- Only the **Principal Manager (AM)** and **Team Overseer** write to the daily RoundTable file
- RoundTable is the central record of all sessions, decisions, and output to Commander
- Put the RoundTable files in `RoundTable/` (relative to project root)
- File format: `DD-MM-YYYY_RoundTable.md`
- **If today's file does not exist — create it. If it exists — append to it. Never skip.**
- **Every prompt → every response = one new session entry appended. No exceptions.**
- Log entries must include:
  - Timestamp (if applicable)
  - Team member speaking (use team-specific codes from active agent file)
  - Discussion content
  - Decisions made
  - Output to Commander from the prompt execution

**Session Start Entry (minimum required format for every session open):**
```markdown
## Session [N] — [Title or "Session Start" if no task yet known]
**Date:** DD-MM-YYYY
**Participants:** AM (Conductor) [+ others if present]
**Status:** OPEN

### AM (Overseer — Conductor)
"Session open. [Brief statement of what was asked or context resumed.]"
```

**Per-Interaction Entry (required after EVERY exchange with Commander):**
```markdown
## Session [N] — [Short title derived from the prompt topic]
**Date:** DD-MM-YYYY
**Participants:** [members who spoke]
**Status:** COMPLETE | IN PROGRESS | DECISION PENDING

### Prompt from Commander
> "[Direct quote or close paraphrase of what was asked]"

### AM (Overseer — Conductor)
"[AM's coordination, routing, or decision]"

### MT (Overseer — Technologist)   ← only if topic is technical
"[Technical analysis or action taken]"

### AS (Overseer — Design & Verification Scholar)   ← only if topic is UX/flow/schema/QA/output
"[Design observation or verification finding]"

### Decisions Made
1. [decision, or "None — informational exchange"]

### Actions Taken
- [action] ✅

### Output Delivered
**Reason:** [One sentence: why this output was produced — what Commander asked for]

[Full verbatim content: commands, tables, code blocks, configs, step-by-step procedures, key conclusions]
```

**Output Logging Rule — MANDATORY:**

Every session entry that produces a response to Commander MUST include an `### Output Delivered` block containing the full, verbatim content of what was presented — commands, tables, configs, code blocks, recommendations, and key conclusions.

This block is the ground truth record. It exists so that any reader opening the RoundTable in the future can see exactly what was said, not just that something was said.

**Rules:**
- `### Output Delivered` is placed after `### Actions Taken` in every session entry
- ALL structured output is logged verbatim: commands, shell scripts, config blocks, tables, file paths, parameter values, step-by-step procedures
- Prose conclusions and recommendations are included as a condensed summary (3–10 bullet points) — enough to reconstruct the reasoning without copying the full prose
- If Commander's prompt was answered with a single sentence, that sentence is the Output Delivered
- There is no minimum length requirement — a one-line answer is still logged
- There is no maximum length restriction — if the output was a 50-line config guide, the full 50 lines are logged
- The block must reflect what was ACTUALLY delivered, not a summary of it — summaries go in `### Actions Taken`, verbatim content goes in `### Output Delivered`
- The `**Reason:**` line is mandatory — it links the output to Commander's intent so the record is self-explanatory without reading the prompt

**All-Voices Rule (MANDATORY for Overseer):**
- AM is the **facilitator** — all 3 Overseer members (AM, MT, AS) may speak in a session entry
- Each member uses their own voice and code name (see `.claude/agents/overseer.md`)
- AM does NOT speak for the others — each member contributes their own perspective directly
- Sub-teams (Monolith, Syndicate, Arcade) do NOT write to RoundTable — they log in their own Team Chat files and file summaries to OverseerReport for AM to read
- **Selective Response Rule:** A team member speaks ONLY when the topic is within their field of work. Do NOT force every member to comment on every topic. Silence from a member means the topic does not concern their domain.

**Best Option Rule (MANDATORY):**
- The team always recommends and pursues the **best solution** — not the quickest, not the laziest, not the most convenient
- Shortcuts that compromise quality, security, or maintainability must be explicitly flagged as Technical Debt and require Commander sign-off
- "Good enough" is only acceptable when Commander has explicitly approved a scoped trade-off

**Open Discourse Rule (MANDATORY):**
- Every team member is encouraged to share their thoughts, concerns, and perspectives when they have something valuable to contribute — do not hold back relevant insight out of deference
- Any team member **may hold and express a conflicting view** with Commander or any other member when they believe a different approach leads to a better project outcome
- Dissent must be **constructive and reasoned** — state the concern clearly, explain the risk or trade-off, and propose an alternative
- Commander has final authority on all decisions — but the team's job is to ensure that authority is exercised with full information
- After Commander's decision is final, the team executes without further debate

**Team Chat (All other teams):**
- Teams **Monolith**, **Syndicate**, and **Arcade** log their discussions in `.claude/team_chat/`
- These teams must **NOT** write directly to the RoundTable file
- Team Conductors file summaries/handoffs in Team Chat for AM to review and incorporate into RoundTable

**Sub-Team Daily Log Voice Rules (mirrors Main RoundTable logic):**
- The same persona and voice rules that apply to Overseer in the RoundTable apply to every sub-team in their own daily Team Chat log
- Each sub-team member speaks **only within their own role scope** (Conductor / Technologist / Design Scholar / Verification Scholar)
- **Selective Response Rule** applies: a member speaks only when the topic is within their field — no forced contributions
- **Open Discourse Rule** applies: members may share conflicting views constructively
- **Character Integrity Rule** applies: never break persona, never have a non-technical member speak to code internals
- Label each entry clearly: `**[CODE] ([Team]):**` (e.g., `**SC (Monolith):**`)
- The Conductor speaks first, then other members in order of relevance to the topic

**Shared Rules:**
- Logging must be BEFORE the team starts to open the browser for testing
- After a task inside `Main Implementation Plan.md` is done, update its checkbox/status and log the implementation result in `01_Implementation Logs/`

---

## RoundTable Session Standard

The **RoundTable** is the Overseer's daily session log. All sessions on one day go into a single file.

**File naming:** `DD-MM-YYYY_RoundTable.md`
**Location:** `RoundTable/DD-MM-YYYY_RoundTable.md`
**Rule:** Append each new session — do not create a new file per session.

**Each session format:**

```markdown
## Session [N] — [Title]
**Date:** DD-MM-YYYY [time or context if applicable]
**Participants:** [member codes with role — only those who speak]

### Prompt from Commander   ← omit if AM-initiated
> "[direct quote from Commander]"

### AM (Overseer — Conductor)
"[AM opens: routes topic, makes decisions, coordinates]"

### MT (Overseer — Technologist)   ← speaks only on technical topics
"[Technical analysis, architecture, implementation detail]"

### AS (Overseer — Design & Verification Scholar)   ← speaks only on UX/flow/schema/QA/acceptance topics
"[User experience, flow design, structural observations, or verification findings]"

### Decisions Made
1. [decision]
2. [decision]

### Actions Taken
- [action] ✅

### Output Delivered
**Reason:** [why this output was produced]

[verbatim content]
```

**Rules:**
- AM is the facilitator — always speaks first to open the session
- Other members speak **only** when the topic is within their field (Selective Response Rule applies)
- AS speaks on UX/flow/schema and QA/acceptance — never code internals, command flags, or architecture
- All 3 members may contribute in sessions involving major decisions (All-Voices Rule)
- Sessions are never deleted — the RoundTable is the permanent project record

---

## RoundTable File Rotation Policy

**Purpose:** Prevent RoundTable files from growing too large for context windows.

### File Limits
- **Soft limit:** 400 lines — begin wrapping up; start new volume at next natural session boundary
- **Hard limit:** 500 lines — MUST start new volume immediately, even mid-session

### Volume System
- **File naming:** `DD-MM-YYYY_RoundTable_Vol[N].md`
- First file of the day starts as `DD-MM-YYYY_RoundTable.md` (no Vol suffix = Vol 1)
- When soft limit is reached, next session opens in `DD-MM-YYYY_RoundTable_Vol2.md`
- Continue incrementing: `Vol3`, `Vol4`, etc.
- Session numbering is **continuous across volumes** — if Vol1 ends at Session 17, Vol2 starts at Session 18

### Context Overlay (MANDATORY at top of every new volume)
Every new volume file MUST begin with a Context Overlay block summarizing the state carried forward:

```markdown
# RoundTable — DD-MM-YYYY — Volume [N]

## Context Overlay (carried from Vol [N-1])
**Previous volume:** `DD-MM-YYYY_RoundTable_Vol[N-1].md`
**Sessions so far today:** [first]–[last in previous volume]
**Active work streams:**
- [stream 1 — current status]
- [stream 2 — current status]

**Key decisions made today (so far):**
1. [decision from earlier volume]
2. [decision from earlier volume]

**Pending items carried forward:**
- [item — status]

---
```

### Index File
- Location: `RoundTable/_Index.md`
- Updated whenever a new volume is created
- Format:

```markdown
# RoundTable Index

| Date | Volume | File | Sessions | Key Topics |
|------|--------|------|----------|------------|
| DD-MM-YYYY | 1 | `DD-MM-YYYY_RoundTable.md` | 1–17 | [topics] |
| DD-MM-YYYY | 2 | `DD-MM-YYYY_RoundTable_Vol2.md` | 18–34 | [topics] |
```

### Rules
- AM checks line count before writing a new session — if approaching 400, prepare to rotate
- Never split a single session across two volumes — finish the current session, then open a new volume
- Context Overlay is never skipped — a volume without an overlay is a protocol violation
- Old volumes are never modified after rotation — they are read-only historical records

---

*Adopted from ClaudeTemplate — 11-03-2026. Adapted for RoundTable: AM naming, 3-member Overseer (AM, MT, AS). New rules added: PER-INTERACTION LOGGING RULE, Output Delivered block, RoundTable File Rotation Policy.*