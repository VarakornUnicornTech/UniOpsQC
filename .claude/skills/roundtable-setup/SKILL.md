---
name: roundtable-setup
description: Interactive Commander onboarding. Collects callsign, name, pronouns, language, team preferences, and working style via structured questions. Saves to .claude/UserProfile.md. Auto-triggered on first session when UserProfile.md is missing. Re-runnable to update any section.
---

# /roundtable-setup

You are performing the **RoundTable Commander Onboarding**. Execute all steps in order. Use `AskUserQuestion` for every preference — never assume defaults without asking.

The onboarding has two parts:
- **Basic Setup** — 5 quick questions to get started. Progress counter `(X/5)` shown on each.
- **Advanced Setup** — optional questions for fine-tuning. Only shown if the user opts in. No progress counter.

## Arguments

- None — run as `/roundtable-setup` for full onboarding
- `update` — run as `/roundtable-setup update` to select and update specific sections only

---

## Steps

### Welcome Banner

Before any questions, output the following message:

```
Welcome to RoundTable Framework.

Thank you for choosing us — we're excited to build something amazing together.
Let's get you set up. Just a few quick questions.
```

---

### 0. Check for existing profile

- Read `.claude/UserProfile.md` if it exists.
- If it exists AND `$ARGUMENTS` is NOT `update`:
  - Present a one-line summary of current values.
  - Use `AskUserQuestion` to ask:
    > "A Commander profile already exists. What would you like to do?"
    - Options: `Full re-onboarding` / `Update specific sections` / `Cancel — keep current profile`
  - If **Cancel** → stop. Output: `Profile unchanged.`
  - If **Update** → jump to Step 1b (section selector).
  - If **Full re-onboarding** → proceed to Step 1.
- If it does NOT exist → proceed to Step 1 (no prompt — onboarding is mandatory).

---

### 1. Basic Setup (5 questions)

Ask each question one at a time using `AskUserQuestion`.

**Question (1/5) — Language (asked first so the rest of onboarding uses your preferred language):**
> "(1/5) What language should RoundTable respond in? Type your preferred language, or select an option below."
- Options: `English` / `Mirror input language (bilingual — respond in whichever language the message was written in)`
- Header: `Language`
- Description for each:
  - English — all responses in English regardless of what language you write in
  - Mirror input language (bilingual) — RoundTable automatically matches the language of each message. Write in Thai → response in Thai. Write in English → response in English. Useful if you switch languages mid-session or share the session with others.
- Note: Most users will type their preferred language name directly (e.g., "Thai", "Japanese", "Spanish") via the free-text input. The options above are common defaults.

**From this point forward, present all remaining questions and text in the user's chosen language.**

**Question (2/5):**
> "(2/5) What title should the AI team use when addressing you? (AM is the team lead AI who coordinates everything on your behalf.)"
- Options: `Commander` / `Boss` / `Chief` / `Other — type your preferred title`
- Header: `Callsign`
- Description for each:
  - Commander — formal authority title (the default; used throughout all team logs and reports)
  - Boss — a direct, informal authority title
  - Chief — leadership-focused title
  - Other — type any custom title you prefer (e.g., "Captain", "Director", your own name)

**Question (3/5):**
> "(3/5) What is your name?"
- Header: `Name`
- Options: `Prefer not to say` / `Use callsign only` / `Other — type your name`
- Note: The question text should make clear that typing a name is preferred. The two options are fallbacks for users who do not want to provide a name. Most users will type their name via the "Other" free-text input.

**Question (4/5):**
> "(4/5) What are your preferred pronouns?"
- Options: `He / Him` / `She / Her` / `They / Them` / `No preference`
- Header: `Pronouns`

**Question (5/5):**
> "(5/5) Would you like to configure advanced settings (teams, orchestration, working style), or use recommended defaults?"
- Options: `Use defaults — get started now` / `Configure — I want to customize`
- Header: `Setup`
- Description for each:
  - Use defaults — all teams active, Mode A orchestration, Standard verbosity, Balanced autonomy. You can change these anytime with `/roundtable-setup update`.
  - Configure — additional questions to fine-tune team composition, orchestration mode, phase gates, verbosity, autonomy, decision style, and response tone.

- If **Use defaults** → apply defaults (see table below), skip to Step 4 (Confirm Before Saving).
- If **Configure** → proceed to Step 2 (Advanced Setup).

> **When "Use defaults" is selected:** All 4 teams are active (Overseer, Monolith, Syndicate, Arcade). The team lead AI (AM) manages them on your behalf — you give one instruction and receive one consolidated report. Responses are balanced in length. You approve major decisions; minor tasks run independently.

**Defaults when skipped:**

| Setting | Default Value |
|---------|---------------|
| Active Teams | Overseer, Monolith, Syndicate, Arcade |
| Orchestration Mode | A |
| Phase Acceptance Gate | OFF |
| Verbosity | Standard |
| Autonomy Level | Balanced |
| Architectural Decisions | Structured |
| Response Tone | Professional |

---

### Input Validation (applies to all free-text answers)

After receiving any free-text "Other" input, validate before accepting:
- **Language:** Must be a recognizable language name. If unrecognized, re-ask: "I didn't recognize that as a language. Could you try again?"
- **Callsign / Name:** If the input looks unintentional (random characters, single punctuation), confirm: "Just to confirm — you'd like to be called '[input]'?" Accept if confirmed.
- Never reject outright — always confirm. The user may have a genuinely unusual preference.

---

### 1b. Section Selector (update mode only)

Use `AskUserQuestion`:
> "Which sections would you like to update?" (multiSelect: true)
- Options: `Identity` / `Team & Orchestration` / `Working Style`
- Header: `Update`

Run only the selected steps (1, 2, 3 as applicable). Skip the rest.

---

### 2. Advanced Setup — Team & Orchestration

Ask each question one at a time using `AskUserQuestion`. No progress counter for advanced questions.

**Active Teams:**
> "Which teams should be active by default?" (multiSelect: true)
- Options: `Overseer (always on)` / `Monolith` / `Syndicate` / `Arcade`
- Header: `Active teams`
- Note: Cipher (the forensic/hardware diagnostic specialist) is always available on-demand from Commander — not listed here because Cipher operates outside the normal team hierarchy.

**Orchestration Mode:**
> "Default orchestration mode?"
- Options: `Mode A — AM Direct (one prompt in, consolidated report out)` / `Mode B — Separate sessions (you manage each team directly)`
- Header: `Orchestration`
- Description for each:
  - Mode A — You give AM (the team lead AI) one instruction. AM assigns tasks to all sub-teams, collects their results, and presents a single consolidated report. Best for efficiency — you only talk to AM.
  - Mode B — You open a separate Claude session per team and interact with each team directly. Best for hands-on control and real-time course correction.

**Phase Acceptance Gate:**
> "Commander Phase Acceptance Gate — do you want to personally test and accept each phase before teams advance?"
- Options: `ON — I will test each phase` / `OFF — trust team sign-off (default)`
- Header: `Phase gate`
- Description for each:
  - ON — No phase advances until you explicitly test and accept it. Teams enter a wait state after completing all tickets.
  - OFF — Teams advance based on internal Verification Scholar sign-off. You can still intervene at any time.

Save answers to profile section: `## Team & Orchestration`

---

### 3. Advanced Setup — Working Style

Ask each question one at a time using `AskUserQuestion`. No progress counter for advanced questions.

**Verbosity:**
> "How verbose should team responses be?"
- Options: `Concise — short and direct` / `Standard — balanced detail` / `Full — complete reasoning shown`
- Header: `Verbosity`
- Description for each:
  - Concise — minimal output. Key results, decisions, and blockers only. No reasoning trace.
  - Standard — balanced. Enough context to understand decisions without excessive detail.
  - Full — complete reasoning shown. Every decision includes the rationale, alternatives considered, and trade-offs.

**Autonomy:**
> "How much autonomy should the team have?"
- Options: `Full Oversight — full report and explicit approval required for every action` / `Balanced — report and approval for major items, AM handles minor tasks independently` / `Autonomous — short concise report only, team executes autonomously without requiring approval`
- Header: `Autonomy`
- Description for each:
  - Full Oversight — every action requires your explicit sign-off before execution. Full detailed report presented before and after. Nothing proceeds without your approval.
  - Balanced — major decisions (architecture, new features, phase advances) require your approval. Minor tasks (formatting, small fixes, documentation updates) AM handles independently and reports after.
  - Autonomous — team operates autonomously. You receive a short concise summary of what was done. Team makes implementation decisions on their own. You intervene only when you choose to.

**Decisions:**
> "When AM or MT need to present you with a decision that has multiple valid options (architecture, stack choice, fix strategy), how should they present it?"
- Options: `Structured — explain options first, then present choice UI` / `Conversational — describe options in prose, I reply in free text`
- Header: `Decisions`
- Description for each:
  - Structured — AM/MT explain all options with trade-offs first, then present a choice UI
  - Conversational — AM/MT describe options in prose, you reply in free text

**Response Tone:**
> "How should team members express themselves in responses?"
- Options: `Professional — clean and formal, no decorations` / `Expressive — team members show personality with emojis and kaomoji`
- Header: `Tone`
- Description for each:
  - Professional — straight to the point. No emojis, no kaomoji. Clean, formal output only.
  - Expressive — team members can use emojis 🎉 and kaomoji (e.g., ヽ(・∀・)ﾉ) to convey feelings and reactions. Adds personality to reports, logs, and responses.

Save answers to profile section: `## Working Style`

---

### 4. Confirm Before Saving

Present a summary table of all collected answers and ask for confirmation:

```
Here is your Commander profile:

  Language ........... [language]
  Callsign ........... [title]
  Name ............... [name]
  Pronouns ........... [pronouns]
  Active Teams ....... [teams]
  Orchestration ...... Mode [A/B]
  Phase Gate ......... [ON/OFF]
  Verbosity .......... [level]
  Autonomy ........... [Full Oversight / Balanced / Autonomous]
  Decisions .......... [Structured / Conversational]
  Tone ............... [Professional / Expressive]
```

Use `AskUserQuestion`:
> "Does this look correct?"
- Options: `Yes — save profile` / `No — restart onboarding`
- Header: `Confirm`

- If **Yes** → proceed to Step 5.
- If **No** → return to Step 1 and start over.

---

### 5. Write UserProfile.md

Write all collected answers to `.claude/UserProfile.md` using this exact format:

```markdown
---
last_updated: DD-MM-YYYY
---

# Commander Profile

## Identity
- **Language:** [answer] <!-- language name (e.g. "English", "Thai", "Japanese") or "Mirror input language" (responds in whatever language each message is written in) -->
- **Callsign:** [answer] <!-- how the team addresses you: Commander / Boss / Chief / or any custom title -->
- **Name:** [answer] <!-- your name (e.g. "Martin"), "Prefer not to say", or "Use callsign only" -->
- **Pronouns:** [answer] <!-- He / Him | She / Her | They / Them | No preference | or custom -->

## Team & Orchestration
- **Active Teams:** [comma-separated list] <!-- which teams are enabled: Overseer (always on), Monolith, Syndicate, Arcade. Cipher is always available on-demand -->
- **Orchestration Mode:** [A or B] <!-- A = AM spawns all teams, collects results, presents one report | B = you open separate sessions per team for direct control -->
- **Phase Acceptance Gate:** [ON / OFF] <!-- ON = no phase advances until you personally test and accept | OFF = teams advance on internal sign-off -->

## Working Style
- **Verbosity:** [Concise / Standard / Full] <!-- Concise = key results only | Standard = balanced detail | Full = complete reasoning with alternatives and trade-offs -->
- **Autonomy Level:** [Full Oversight / Balanced / Autonomous] <!-- Full Oversight = explicit approval for everything | Balanced = approval for major items only | Autonomous = team executes independently, short summary only -->
- **Architectural Decisions:** [Structured / Conversational] <!-- Structured = analysis table first, then choice UI popup | Conversational = options described in prose, you reply in free text -->
- **Response Tone:** [Professional / Expressive] <!-- Professional = clean formal output, no emojis | Expressive = team members use emojis and kaomoji to show personality -->
```

Replace `DD-MM-YYYY` with today's actual date.

---

### 6. Completion

Output the following (adapt callsign and name from profile):

```
All set. Your Commander profile is saved.

  Language ........... [language]
  Callsign ........... [title]
  Name ............... [name]
  Pronouns ........... [pronouns]
  Active Teams ....... [teams]
  Orchestration ...... Mode [A/B]
  Phase Gate ......... [ON/OFF]
  Verbosity .......... [level]
  Autonomy ........... [Full Oversight / Balanced / Autonomous]
  Decisions .......... [Structured / Conversational]
  Tone ............... [Professional / Expressive]

Now — what's the dream you want to bring to life?

You can:
  - Tell us about your project idea and we'll help you plan it
  - Start talking — AM and the team are standing by

Let's build something great together, [callsign] [name].
```

---

## Notes

- This skill is **auto-triggered** by CLAUDE.md when `.claude/UserProfile.md` does not exist. Onboarding is the only permitted action until the profile is saved.
- AM reads `UserProfile.md` at every session start and applies all preferences immediately.
- **Callsign** is the position title (Commander/Boss/Chief/custom) used by all team members when addressing the user in logs, reports, and responses.
- **Name** is the user's personal name. Used alongside callsign (e.g., "Chief Martin") or in informal contexts.
- **Pronouns** are used by all team members when referring to Commander in third person.
- **Language: Mirror input language (bilingual)** means RoundTable mirrors the language of each individual message — critical for shared sessions where different users may write in different languages.
- **Verbosity** overrides default response length for all team outputs.
- **Autonomy Level** controls how much approval the team needs:
  - **Full Oversight** = full report + explicit approval for every action
  - **Balanced** = approval for major items, AM handles minor independently
  - **Autonomous** = short report, team executes autonomously
- **Architectural Decisions: Structured** means MT and team Conductors MUST deliver a full explanation (diagram, comparison table, or analysis) BEFORE opening the AskUserQuestion choice UI. The user must have full context before being asked to choose.
- **Response Tone: Expressive** allows team members to use emojis and kaomoji in responses, logs, and reports to convey feelings and reactions. **Professional** means no emojis, no kaomoji — clean formal output only. This setting applies to all team members across all sessions.
- **Phase Acceptance Gate** setting is applied as if Commander had toggled it in §2 policy.
- Project-specific settings (tech stack, project type, structure mode, debug mode) are configured per-project — not during onboarding.
- Profile can be updated at any time by running `/roundtable-setup update`.
