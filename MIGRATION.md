# Migration Guide — v2.0.0 → v2.1.0

This document covers upgrading an existing v2.0.0 install to v2.1.0.

**v2.1.0 is a non-breaking additive release.** No existing files are moved, renamed, or removed. All new content is purely additive.

---

## 1. New Policy Files

Two new policies added to `.claude/policies/`:

| New File | § | Purpose |
|----------|---|---------|
| `.claude/policies/10_ConfidenceThreshold.md` | §10 | Pre-Implementation Confidence Threshold — 5-check gate (Git Sync binary + 4 scored checks). Required before any Complex ticket starts. |
| `.claude/policies/11_SelfCheckProtocol.md` | §11 | Self-Check Protocol — 4-question post-implementation evidence checklist, 7 hallucination red flags, complexity-scaled depth. Assigned to Verification Scholar. |

**Action:** Copy both files from the updated framework into your `.claude/policies/` directory.

---

## 2. Updated Policy Files (Additive Only)

### `.claude/policies/02_Ticket_and_Briefing.md`

Added a mandatory `**Complexity:**` field to the ticket standard. Also added a new `## Ticket Complexity Values` section.

**New ticket section (after Status, before Depends on):**
```
**Complexity:** `Simple` | `Medium` | `Complex`
```

**Routing table — Complexity values:**

| Value | Scope | Min Testing | Docs Update | Other Gates |
|-------|-------|-------------|-------------|-------------|
| `Simple` | One-file change, no new interfaces | One unit test | Optional | Self-Check Q1 + Q4 minimum |
| `Medium` | Multi-file, touches existing interfaces | Unit + integration | Required | Full Self-Check (all 4 questions) |
| `Complex` | Architectural change, new integrations, cross-team impact | Full test suite | Required + design doc | Confidence Threshold mandatory; MT sign-off; Full Self-Check |

**Action:** Update your local `.claude/policies/02_Ticket_and_Briefing.md` by adding the `**Complexity:**` field and `## Ticket Complexity Values` section. Alternatively, run `/template apply policies` to sync automatically.

### `.claude/rules/governance.md`

Added `**Complexity:** Simple | Medium | Complex` to the Ticket File Standard template block.

**Action:** Update your local `.claude/rules/governance.md` ticket template section. Run `/template apply rules` to sync automatically.

---

## 3. New Skills

Three new skills added to `.claude/skills/`:

| New Skill | Path | Purpose |
|-----------|------|---------|
| `/plan` | `.claude/skills/plan/SKILL.md` | Unified planning — brainstorm → design → spec review → workflow → plan doc. Awaits Commander approval before any implementation. |
| `/document` | `.claude/skills/document/SKILL.md` | Generate or update feature description docs from source code (L1/L2 scan, no hallucination, living doc). |
| `/commands` | `.claude/skills/commands/SKILL.md` | Command discovery — `list` mode shows all commands, `recommend [intent]` matches intent to best command. |

**Action:** Create the corresponding directories and copy the `SKILL.md` files into your `.claude/skills/` directory.

---

## 4. New Bug Reflection System

Added `.claude/reflection/` — a flat-file searchable knowledge base of resolved bugs.

| New File | Purpose |
|----------|---------|
| `.claude/reflection/_INDEX.md` | Index explaining format, naming convention, YAML frontmatter spec, and search instructions |

**Naming convention:** `[Lang]_[ErrorType]_[Name]_DD_MM_YYYY.md`
**YAML frontmatter fields:** `language`, `error_type`, `project`, `severity`, `status`, `ticket`

**Workflow:** Monolith creates a reflection entry whenever a bug ticket reaches Complete.

**Action:** Create the `.claude/reflection/` directory and copy `_INDEX.md` into it.

---

## 5. CLAUDE.md Updates

The framework `CLAUDE.md` has two additive changes:

- **Policy Reference Index:** Two new rows for §10 and §11
- **Available Skills table:** Three new rows for `/plan`, `/document`, `/commands`

**Action:** Update your local `CLAUDE.md` with the new rows, or run `/template apply` to sync automatically.

---

## 6. Quick Migration Checklist

```
[ ] Copy .claude/policies/10_ConfidenceThreshold.md (new)
[ ] Copy .claude/policies/11_SelfCheckProtocol.md (new)
[ ] Add Complexity field + section to .claude/policies/02_Ticket_and_Briefing.md
[ ] Add Complexity field to .claude/rules/governance.md ticket template
[ ] Create .claude/skills/plan/SKILL.md (new)
[ ] Create .claude/skills/document/SKILL.md (new)
[ ] Create .claude/skills/commands/SKILL.md (new)
[ ] Create .claude/reflection/ directory
[ ] Copy .claude/reflection/_INDEX.md (new)
[ ] Update CLAUDE.md — add §10/§11 to policy index + 3 skills to table
[ ] Update template-version.json to v2.1.0
[ ] Run /template check to verify — all new files should show as PRESENT
```

---

## 7. Post-Migration Verification

Run `/template check` to verify your local instance matches the v2.1.0 baseline. New files should show `PRESENT`. Modified files (CLAUDE.md, 02_Ticket_and_Briefing.md, governance.md) will show `CUSTOMIZED` if you have local modifications — this is expected.

---

*Migration guide for RoundTable Framework v2.1.0 — created 16-03-2026*

---

# Migration Guide — v1.x → v1.3.0

This document provides step-by-step instructions for existing RoundTable Framework users to update their local instances to v1.3.0.

**v1.3.0 is a breaking release.** Path structures, identity sources, and skills have changed significantly. Follow the steps below carefully.

---

## 1. Directory Structure Changes

### Policies

| Old Path | New Path |
|----------|----------|
| `.claude/policies/01_Logging_and_RoundTable.md` | `.claude/TeamDocument/1. Policies/01_Logging_and_RoundTable.md` |
| `.claude/policies/02_Ticket_and_Briefing.md` | `.claude/TeamDocument/1. Policies/02_Ticket_and_Briefing.md` |
| `.claude/policies/03_TeamChat_and_Handover.md` | `.claude/TeamDocument/1. Policies/03_TeamChat_and_Handover.md` |
| `.claude/policies/04_Development_Structure.md` | `.claude/TeamDocument/1. Policies/04_Development_Structure.md` |
| `.claude/policies/05_PreExisting_Codebase.md` | `.claude/TeamDocument/1. Policies/05_PreExisting_Codebase.md` |
| `.claude/policies/06_Debugging_Protocol.md` | `.claude/TeamDocument/1. Policies/06_Debugging_Protocol.md` |
| `.claude/policies/07_Parallel_Execution.md` | `.claude/TeamDocument/1. Policies/07_Parallel_Execution.md` |
| *(new)* | `.claude/TeamDocument/1. Policies/08_Skills_and_Subagents.md` |

**Action:** Move all files from `.claude/policies/` into `.claude/TeamDocument/1. Policies/`. Delete the old `.claude/policies/` directory after migration.

### Team Identity Source

| Old Path | New Path |
|----------|----------|
| `.claude/Team Roster/Team_Overseer.md` | `.claude/agents/overseer.md` |
| `.claude/Team Roster/Team_Monolith.md` | `.claude/agents/monolith.md` |
| `.claude/Team Roster/Team_Syndicate.md` | `.claude/agents/syndicate.md` |
| `.claude/Team Roster/Team_Arcade.md` | `.claude/agents/arcade.md` |
| `.claude/Team Roster/Team_Cipher.md` | `.claude/agents/cipher.md` |
| `.claude/Team Roster/Team_Medica.md` | *(removed — domain-specific, not part of base framework)* |

**Action:** The `.claude/agents/` directory is now the **sole identity source**. Delete `.claude/Team Roster/` after confirming your agent files are in place. If you had customized Team Roster files, port your customizations into the corresponding `agents/*.md` file.

### Team Chat

| Old Path | New Path |
|----------|----------|
| `.claude/Team Chat/` | `.claude/TeamDocument/2. TeamChat/` |

**Action:** Move your Team Chat logs into the new path. Subfolder structure remains the same:
- `1. Monolith/`
- `2. Syndicate/`
- `3. Arcade/`
- `4. OverseerReport/`

Each subfolder includes a `HandOver/` directory.

### Diagnostic Log

| Old Path | New Path |
|----------|----------|
| `.claude/Diagnostic Log/` | `.claude/TeamDocument/Diagnostic Log/` |

**Action:** Move existing diagnostic logs into the new path.

---

## 2. Skills Changes

### Removed Skills (5)

| Removed Skill | Replacement |
|---------------|-------------|
| `/roundtable-open` | `/compact-resume` (handles post-compact re-orientation) |
| `/ticket-create` | `/bug-report`, `/mod-log`, `/sub-feature` (type-specific scaffolding) |
| `/briefing-create` | Integrated into CLAUDE.md rules and `/team-start` |
| `/l3-scan` | Integrated into `/template` command |
| `/zcb-check` | Integrated into Conductor coordination workflow |

**Action:** Delete the following skill directories if present:
- `.claude/skills/roundtable-open/`
- `.claude/skills/ticket-create/`
- `.claude/skills/briefing-create/`
- `.claude/skills/l3-scan/`
- `.claude/skills/zcb-check/`

### New Skills (9)

| New Skill | Purpose |
|-----------|---------|
| `/compact-resume` | Post-compact re-orientation workflow |
| `/team-start` | Formal team kickoff with Early Advance authorization |
| `/phase-status` | Full project phase + ticket status report |
| `/bug-report` | Scaffold bug fix file + ticket folders |
| `/mod-log` | Scaffold modification log + ticket folders |
| `/sub-feature` | Scaffold sub-feature + ticket folders |
| `/template` | Unified framework management (replaces 6 split `/template-*` commands) |
| `/Overseer` `/Monolith` `/Syndicate` `/Arcade` `/Cipher` | Persona switch commands |

**Action:** These are included in v1.3.0. No manual action needed — they will be present after updating.

### Consolidated Skills

The 6 split template commands (`/template-status`, `/template-changelog`, `/template-check`, `/template-diff`, `/template-apply`, `/template-rollback`) are consolidated into a single `/template` command with subcommands:
```
/template status
/template changelog [version]
/template check
/template diff
/template apply [scope]
/template rollback
```

**Action:** Update any documentation or workflows that reference the old split commands.

---

## 3. Naming Changes

| Old | New |
|-----|-----|
| Team Roster files | Agent files (`agents/*.md`) |
| Legacy default authority title | Commander ท่านผู้บัญชาการ |
| KP (Khunpol) — Conductor | AM (AstonMartin) — Conductor |
| PM (Palmy) — Design Scholar | AS (AidenStarfall) — Design & Verification Scholar |
| V (View) — Verification Scholar | *(merged into AS role)* |
| 4-member Overseer | 3-member Overseer (AM, MT, AS) |

**Action:** If you have local customizations that reference the old names (KP, PM, V, or the legacy authority title), update them to the new names. If you use custom names in your local instance, ensure your `agents/overseer.md` file reflects your naming.

---

## 4. Medica Removal

The Medica team/agent has been removed from the base framework. It was domain-specific to the AeroMedica project.

**Action:** If you use Medica in your local instance:
- Keep your `Team_Medica.md` or create `agents/medica.md` locally
- Keep your `/Medica` skill locally
- These will be treated as local customizations and won't conflict with framework updates

If you don't use Medica:
- Delete `.claude/Team Roster/Team_Medica.md` (if present)
- Delete `.claude/skills/Medica/` (if present)
- Delete `.claude/TeamDocument/Medical Reference/` (if present)

---

## 5. Quick Migration Checklist

```
[ ] Back up your .claude/ directory
[ ] Move .claude/policies/ → .claude/TeamDocument/1. Policies/
[ ] Move Team Roster files → .claude/agents/ (rename to lowercase)
[ ] Move .claude/Team Chat/ → .claude/TeamDocument/2. TeamChat/
[ ] Move .claude/Diagnostic Log/ → .claude/TeamDocument/Diagnostic Log/
[ ] Delete removed skill directories (5 skills)
[ ] Update any local references from old names (KP→AM, PM/V→AS)
[ ] Update template-version.json to v1.3.0
[ ] Update CLAUDE.md from the new template
[ ] Verify settings.json protects agents/ and TeamDocument/1. Policies/
[ ] Test: run /compact-resume to verify framework loads correctly
```

---

## 6. Post-Migration Verification

After completing the migration, run `/template check` to verify your local instance matches the framework baseline. Any files showing as `CUSTOMIZED` are expected if you have local modifications. Files showing as `MISSING` indicate incomplete migration.

---

*Migration guide for RoundTable Framework v1.3.0 — created 13-03-2026*
