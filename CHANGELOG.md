# Changelog

All notable changes to RoundTable Framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.0] — 2026-03-13

### Added
- `MIGRATION.md` — Step-by-step migration guide for existing users upgrading from v1.x
- Restored Team Assignment Routing rows: Cloud infrastructure, Database schema/migrations, Database query optimization

### Changed
- Version bumped to 1.3.0 (breaking path changes — see MIGRATION.md)
- `template-version.json` updated with v1.3.0 metadata and release date

---

## [1.2.1] — 2026-03-12

### Fixed
- GETTING_STARTED_TH.md — restored all code blocks, backtick references, and file structure section that were corrupted during initial creation

### Added
- §2b Language Policy — per-project language configuration (CONVERSATION_LANGUAGE, LOG_LANGUAGE, DOC_LANGUAGE) in ProjectEnvironment.md and CLAUDE.md

## [1.2.0] — 2026-03-12

### Added
- `agents/overseer.md` — Overseer team agent definition (was missing from initial release)
- `TeamDocument/1. Policies/05_PreExisting_Codebase.md` — Tiered Scan Protocol, L3 Completeness Verification (5 checks)
- `TeamDocument/1. Policies/06_Debugging_Protocol.md` — Instrument-First Rule, regression gate, side-effect scan
- `TeamDocument/1. Policies/08_Skills_and_Subagents.md` — Skills granularity rule, Mode A/B standard, COO Vision Gate template, subagent pre-flight declaration
- `/template` skill — unified framework version management (status · changelog · check · diff · apply · rollback) with 3-way base-hash diff for safe downstream updates
- `/team-start`, `/compact-resume`, `/phase-status` workflow skills
- Persona switch skills: `/Overseer`, `/Monolith`, `/Syndicate`, `/Arcade`, `/Cipher`
- `TeamDocument/2. TeamChat/` directory scaffolded with `.gitkeep` placeholders for all 4 team folders
- `template-version.json` — SHA-256 baseline hashes for all 27 tracked framework files (enables `/template diff` and `/template apply`)
- SESSION START RULE upgraded — mandatory on every session interaction, not just post-compact
- AM Mode A/B + COO Vision Gate documented in `CLAUDE.md` and `agents/overseer.md`
- Architecture Decision Rule — MT owns all architectural decisions org-wide
- Open Discourse Rule + Best Option Rule added to governance standards
- GETTING_STARTED.md — English getting started guide for new users (first session walkthrough, slash commands, project modes, file structure, tips)
- GETTING_STARTED_TH.md — Thai getting started guide

### Changed
- `agents/` is now the sole identity source — all agent files updated with correct relative paths and TeamChat locations
- All policy paths updated to relative paths throughout all 8 policy files and all skill files
- `TeamDocument/1. Policies/` replaces `policies/` as the canonical policy location
- Skills table in `CLAUDE.md` consolidated — removed duplicate entries and old `/template-*` split commands
- `settings.json` hooks updated to protect `TeamDocument/1. Policies/` and `agents/`
- README.md — removed Medica references, changed "Team Roster" to "agent file", updated team count from 6 to 5
- README.th.md — same Medica/terminology fixes as English version
- Development structure policy (04) — fixed backslash paths to forward slashes

### Removed
- `TeamDocument/2. Team Roster/` folder — agents/ is sole identity source (no duplicates)
- `/roundtable-open`, `/ticket-create`, `/briefing-create` micro-skills — redundant with CLAUDE.md rules
- `/template-status`, `/template-changelog`, `/template-check`, `/template-diff`, `/template-apply`, `/template-rollback` split skills — consolidated into single `/template` command
- Medica — domain-specific to AeroMedica project; not part of base framework

---

## [1.1.0] — 2026-03-12

### Added
- `/audit` skill — end-to-end user flow audit that finds UX-breaking gap bugs and files a bug report
- Quick Install Prompt in README (EN + TH) — copy-paste block for onboarding new projects
- Usage warnings and install guidance based on customer feedback
- GitHub issue templates: Bug Report, Feature Request, Question

### Changed
- Improved onboarding experience and README clarity (EN + TH editions)

---

## [1.0.0] — 2026-03-12

### Added
- Core policy file (CLAUDE.md) with team initialization sequence and character integrity rules
- 7 modular policy files covering logging, tickets, team chat, development structure, codebase scanning, debugging, and parallel execution
- 5 team agent definitions: Overseer (partial), Monolith, Syndicate, Arcade, Cipher
- Team Chat directory structure with HandOver folders and OverseerReport
- Diagnostic Log directory for Cipher engagements
- ProjectEnvironment.md template for project registry
- Workflow skills: `/audit`, `/bug-report`, `/mod-log`, `/sub-feature`, `/overseer-report`
- Template management skills: `/template-status`, `/template-changelog`, `/template-check`, `/template-diff`, `/template-apply`, `/template-rollback`
- RoundTable session logging system with file rotation policy (400/500 line limits)
- Tiered codebase scan protocol (L1/L2/L3) with 5-check completeness verification
- Zero Cross-Team Block (ZCB) guarantee for parallel execution
- Planning-first workflow enforcement
- Instrument-first debugging protocol
- TeamDocument/ nested folder structure for all team-facing documents
- settings.json with sensible default permissions
- README.md, LICENSE (MIT), template-version.json
