# Changelog

All notable changes to RoundTable Framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.1] — 2026-03-12

### Fixed
- GETTING_STARTED_TH.md — restored all code blocks, backtick references, and file structure section that were corrupted during initial creation

### Added
- §2b Language Policy — per-project language configuration (CONVERSATION_LANGUAGE, LOG_LANGUAGE, DOC_LANGUAGE) in ProjectEnvironment.md and CLAUDE.md

## [1.2.0] — 2026-03-12

### Added
- GETTING_STARTED.md — English getting started guide for new users (first session walkthrough, slash commands, project modes, file structure, tips)
- GETTING_STARTED_TH.md — Thai getting started guide
- Post-install welcome dialog in VS Code extension offers Getting Started guide options (EN/TH)

### Changed
- README.md — removed Medica references, changed "Team Roster" to "agent file", updated team count from 6 to 5
- README.th.md — same Medica/terminology fixes as English version
- Development structure policy (04) — fixed backslash paths to forward slashes

## [1.1.0] — 2026-03-12

### Added
- `/audit` skill — end-to-end multi-domain code audit with 6 domain passes (ux-flow, data, logic, security, resources, errors), symptom trace mode, and large codebase strategy

### Changed
- Reverted to ClaudeDemo base template structure
- Folder structure: flat `policies/`, `Team Roster/`, `Team Chat/`, `agents/` (removed nested `TeamDocument/` wrapper)
- Overseer team: 3 members (AM, MT, AS) — Design & Verification Scholar combined role
- Authority naming: Commander ท่านผู้บัญชาการ (original)
- Restored `settings.json` with PreToolUse hooks for policy file protection
- Restored 4 agent definitions (monolith, syndicate, arcade, cipher)
- Restored original 6 skills (roundtable-open, ticket-create, briefing-create, zcb-check, overseer-report, l3-scan)
- README.md: added Quick Install Prompt (copy-paste) and usage warnings for both EN and TH
- ProjectEnvironment.md: added field reference table and commented examples

### Removed
- `TeamDocument/` nested folder structure
- `08_Skills_and_Subagents.md` policy (§8)
- Medica (Team_Medica.md, Medical Reference/)
- 4-member Overseer split (PM + V) — reverted to combined AS role
- KP/Chief Manager Martin naming — reverted to AM/Commander ท่านผู้บัญชาการ
- 6 persona switch skills (Overseer, Monolith, Syndicate, Arcade, Cipher, Medica)
- 6 template management skills (template-status, template-changelog, template-check, template-diff, template-apply, template-rollback)
- 7 workflow skills not in base (bug-report, mod-log, sub-feature, compact-resume, phase-status, team-start)
- KP Orchestration Mode A/B
- HandOver subfolders

## [1.0.0] — 2026-03-12

### Added
- Initial release (subsequently found to have diverged from ClaudeDemo base — see v1.1.0 for corrections)
