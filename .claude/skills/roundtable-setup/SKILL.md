---
name: roundtable-setup
description: Interactive Commander onboarding. Collects callsign, name, pronouns, language, team preferences, and working style via structured questions. Saves to .claude/UserProfile.md. Auto-triggered on first session when UserProfile.md is missing. Re-runnable to update any section.
---

# /roundtable-setup

You are performing the **RoundTable Commander Onboarding** (10 questions total). Execute all steps in order. Use `AskUserQuestion` for every preference — never assume defaults without asking. Include the progress counter `(X of 10)` in every question so the user knows how far along they are.

## Arguments

- None — run as `/roundtable-setup` for full onboarding
- `update` — run as `/roundtable-setup update` to select and update specific sections only

---

## Steps

### 0. Check for existing profile

- Read `.claude/UserProfile.md` if it exists.
- If it exists AND `$ARGUMENTS` is NOT `update`:
  - Present a one-line summary of current values.
  - Use `AskUserQuestion` to ask:
    > "A Commander profile already exists. What would you like to do?"
    - Options: `Full re-onboarding` / `Update specific sections` / `Cancel — keep current profile`
  - If **Cancel** → stop. Output: `Profile unchanged.`
  - If **Update** → jump to Step 1b (section selector).
  - If **Full re-onboarding** → proceed to Step 1a.
- If it does NOT exist → proceed to Step 1a (no prompt — onboarding is mandatory).

---

### 1a. Commander Identity

Ask each question one at a time using `AskUserQuestion`.

**Question 1 of 10 (Language — asked first so the rest of onboarding uses your preferred language):**
> "(1/10) What language should RoundTable respond in? Type your preferred language, or select an option below."
- Options: `English` / `Mirror input language (bilingual — respond in whichever language the message was written in)`
- Header: `Language`
- Description for each:
  - English — all responses in English regardless of input language
  - Mirror input language (bilingual) — RoundTable mirrors the language of each individual message. If you write in English, the response is in English. If you write in another language, the response matches. Recommended for multilingual sessions.
- Note: Most users will type their preferred language (e.g., "Thai", "Japanese", "Spanish") via the free-text input. The options above are common defaults.

**From this point forward, present all remaining questions and text in the user’s chosen language.**

**Question 2 of 10:**
> "(2/10) What position title should AM and the teams use when addressing you?"
- Options: `Commander` / `Boss` / `Chief` / `Other — type your preferred title`
- Header: `Callsign`
- Description for each:
  - Commander — formal military-style rank
  - Boss — direct authority title
  - Chief — leadership-focused title
  - Other — enter any custom title you prefer

**Question 3 of 10:**
> "(3/10) What is your name?"
- Header: `Name`
- Options: `Prefer not to say` / `Use callsign only`
- Note: The question text should make clear that typing a name is preferred. The two options are fallbacks for users who do not want to provide a name. Most users will type their name via the "Other" free-text input.

**Question 4 of 10:**
> "(4/10) What are your preferred pronouns?"
- Options: `He / Him` / `She / Her` / `They / Them` / `No preference`
- Header: `Pronouns`

Save answers to profile section: `## Identity`

---

### 1b. Section Selector (update mode only)

Use `AskUserQuestion`:
> "Which sections would you like to update?" (multiSelect: true)
- Options: `Identity` / `Team & Orchestration` / `Working Style`
- Header: `Update`

Run only the selected steps (1a, 2, 3 as applicable). Skip the rest.

---

### 2. Team & Orchestration

Ask each question one at a time using `AskUserQuestion`.

**Question 5 of 10:**
> "(5/10) Which teams should be active by default?" (multiSelect: true)
- Options: `Overseer (always on)` / `Monolith` / `Syndicate` / `Arcade`
- Header: `Active teams`
- Note: Cipher is always available on-demand — not listed here.

**Question 6 of 10:**
> "(6/10) Default orchestration mode?"
- Options: `Mode A — AM Direct (one prompt in, consolidated report out)` / `Mode B — Separate sessions (you manage each team directly)`
- Header: `Orchestration`
- Description for each:
  - Mode A — You give AM one instruction. AM spawns all sub-teams, collects results, and presents a single consolidated report. Best for efficiency.
  - Mode B — You open a separate Claude session per team and interact with each directly. Best for hands-on control and real-time course correction.

**Question 7 of 10:**
> "(7/10) Commander Phase Acceptance Gate — do you want to personally test and accept each phase before teams advance?"
- Options: `ON — I will test each phase` / `OFF — trust team sign-off (default)`
- Header: `Phase gate`
- Description for each:
  - ON — No phase advances until you explicitly test and accept it. Teams enter a wait state after completing all tickets.
  - OFF — Teams advance based on internal Verification Scholar sign-off. You can still intervene at any time.

Save answers to profile section: `## Team & Orchestration`

---

### 3. Working Style

Ask each question one at a time using `AskUserQuestion`.

**Question 8 of 10:**
> "(8/10) How verbose should team responses be?"
- Options: `Concise — short and direct` / `Standard — balanced detail` / `Full — complete reasoning shown`
- Header: `Verbosity`
- Description for each:
  - Concise — minimal output. Key results, decisions, and blockers only. No reasoning trace.
  - Standard — balanced. Enough context to understand decisions without excessive detail.
  - Full — complete reasoning shown. Every decision includes the rationale, alternatives considered, and trade-offs.

**Question 9 of 10:**
> "(9/10) How much autonomy should the team have?"
- Options: `Full Oversight — full report and explicit approval required for every action` / `Balanced — report and approval for major items, AM handles minor tasks independently` / `Autonomous — short concise report only, team executes autonomously without requiring approval`
- Header: `Autonomy`
- Description for each:
  - Full Oversight — every action requires your explicit sign-off before execution. Full detailed report presented before and after. Nothing proceeds without your approval.
  - Balanced — major decisions (architecture, new features, phase advances) require your approval. Minor tasks (formatting, small fixes, documentation updates) AM handles independently and reports after.
  - Autonomous — team operates autonomously. You receive a short concise summary of what was done. Team makes implementation decisions on their own. You intervene only when you choose to.

**Question 10 of 10:**
> "(10/10) When AM or MT need to present you with a decision that has multiple valid options (architecture, stack choice, fix strategy), how should they present it?"
- Options: `Structured — explain options first, then present choice UI` / `Conversational — describe options in prose, I reply in free text`
- Header: `Decisions`
- Description for each:
  - Structured — AM/MT explain all options with trade-offs first, then present a choice UI
  - Conversational — AM/MT describe options in prose, you reply in free text

Save answers to profile section: `## Working Style`

---

### 3.5. Confirm Before Saving

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
```

Use `AskUserQuestion`:
> "Does this look correct?"
- Options: `Yes — save profile` / `No — restart onboarding`
- Header: `Confirm`

- If **Yes** → proceed to Step 4.
- If **No** → return to Step 1a and start over.

---

### 4. Write UserProfile.md

Write all collected answers to `.claude/UserProfile.md` using this exact format:

```markdown
---
last_updated: DD-MM-YYYY
---

# Commander Profile

## Identity
- **Language:** [answer]
- **Callsign:** [answer]
- **Name:** [answer]
- **Pronouns:** [answer]

## Team & Orchestration
- **Active Teams:** [comma-separated list]
- **Orchestration Mode:** [A or B]
- **Phase Acceptance Gate:** [ON / OFF]

## Working Style
- **Verbosity:** [Concise / Standard / Full]
- **Autonomy Level:** [Full Oversight / Balanced / Autonomous]
- **Architectural Decisions:** [Structured / Conversational]
```

Replace `DD-MM-YYYY` with today's actual date.

---

### 5. Confirm

Output the following (adapt callsign and name from profile):

```
Commander profile saved to .claude/UserProfile.md

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

RoundTable is ready. Welcome, [callsign] [name].
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
- **Phase Acceptance Gate** setting is applied as if Commander had toggled it in §2 policy.
- Project-specific settings (tech stack, project type, structure mode, debug mode) are configured per-project — not during onboarding.
- Profile can be updated at any time by running `/roundtable-setup update`.
