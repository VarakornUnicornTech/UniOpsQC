# Pull Request Review Process

This document defines how pull requests are reviewed, who reviews them, and what standards apply.

## Review Tiers

Review requirements are enforced automatically via [CODEOWNERS](../.github/CODEOWNERS) and branch protection rules.

### Tier 1: Owner-Only Zone

Changes to these files require review from the project **Owner (Commander)**.

| Files | Why Protected |
|-------|--------------|
| `.claude/CLAUDE.md` | Core framework brain — affects all AI behavior |
| `.claude/agents/` | Team identity definitions — changes team behavior |
| `.claude/settings.json` | Hook configurations — affects security enforcement |
| `template-version.json` | Version integrity — supply chain protection |
| `LICENSE` | Legal terms |
| `GOVERNANCE.md` | Project governance rules |
| `SECURITY.md` | Security reporting policy |
| `.github/workflows/` | CI/CD pipelines — automation integrity |
| `.github/CODEOWNERS` | Ownership rules — self-referential protection |

**Response SLA:** 7 days

### Tier 2: Maintainer Zone

Changes to these files require review from **any maintainer** (Owner or Maintainer).

| Files | Why Protected |
|-------|--------------|
| `.claude/policies/` | Governance rules that affect workflow |
| `.claude/TeamDocument/` | Team documents and policies |
| `.claude/skills/` | Skill definitions that extend capabilities |
| `CHANGELOG.md` | Release history accuracy |
| `README.md` / `README.th.md` | Public-facing project description |
| `CONTRIBUTING.md` / `CONTRIBUTING.th.md` | Contributor onboarding |
| `GETTING_STARTED.md` / `GETTING_STARTED_TH.md` | User onboarding |
| `docs/` | Extended documentation |

**Response SLA:** 5 days

### Tier 3: Community Zone

Files not listed in CODEOWNERS. Any maintainer can review and merge.

| Files | Examples |
|-------|---------|
| Issue templates | `.github/ISSUE_TEMPLATE/` (except config.yml) |
| Examples | Future `examples/` directory |
| Translations | Non-core translation files |

**Response SLA:** 3 days

## Review Checklist

Every reviewer should verify the following before approving:

### General

- [ ] Changes match the PR description and title
- [ ] PR is appropriately scoped (single concern, not too large)
- [ ] No unrelated changes bundled in
- [ ] Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/) format

### Framework-Specific

- [ ] All file paths are **relative** (no `C:\`, `D:\`, or `/Users/` paths)
- [ ] All file paths use **forward slashes** (not backslashes)
- [ ] No legacy naming contamination (no `KP`, `PM`, `V`, or legacy authority titles)
- [ ] Policy section numbers match filenames (e.g., `§5` in `05_PreExisting_Codebase.md`)
- [ ] No secrets, API keys, credentials, or tokens included
- [ ] No hardcoded usernames or machine-specific references

### Documentation

- [ ] User-facing docs updated if behavior changed
- [ ] Thai translation updated (or flagged for translation in PR)
- [ ] CHANGELOG.md updated for non-trivial changes
- [ ] Links and cross-references are valid

### Breaking Changes

- [ ] Breaking change clearly labeled in PR title or description
- [ ] Migration steps documented
- [ ] Version bump proposed (MAJOR for breaking changes)

### AI-Generated Content

- [ ] AI disclosure completed in PR template
- [ ] Human sponsor identified
- [ ] Content reviewed for accuracy (AI may hallucinate details)
- [ ] No prompt injection risks in framework files

## Automated Checks

The following checks run automatically on every PR via GitHub Actions:

| Check | What It Does | Blocking? |
|-------|-------------|-----------|
| JSON Validation | Validates `template-version.json` is valid JSON | Yes |
| Naming Consistency | Scans for legacy naming contamination | Yes |
| Absolute Path Check | Scans for absolute Windows/Unix paths | Yes |
| Secret Scanning | Checks for potential API keys and credentials | Yes |
| PR Size Label | Labels PR as XS/S/M/L/XL based on changes | No (informational) |
| XL Warning | Posts a comment if PR exceeds 500 changed lines | No (advisory) |

## Merge Blocking Rules

A PR **cannot be merged** if any of the following are true:

| Condition | Resolution |
|-----------|-----------|
| CI check failing | Fix the failing check |
| Required CODEOWNERS review missing | Wait for the designated reviewer |
| "Changes Requested" review pending | Address the feedback and request re-review |
| Merge conflicts | Rebase or merge upstream changes |
| Targeting wrong branch | Retarget the PR (features → `dev`, hotfixes → `staging`) |

## Security Review

PRs that modify files in `.claude/` receive additional scrutiny:

### Prompt Injection Assessment

Framework files are interpreted as AI instructions. Reviewers must check for:

- Instructions that override governance rules
- Hidden directives in markdown comments
- Content designed to manipulate AI behavior in unexpected ways
- Skills or agents that execute unintended actions

### Hook Bypass Analysis

Changes to `.claude/settings.json` or hook-related files must be verified to not:

- Disable existing protections
- Create new bypass paths
- Weaken file protection rules

### Supply Chain Verification

Changes to `template-version.json` must:

- Update hashes only for files that actually changed
- Not remove hashes for existing files without justification
- Use correct SHA-256 hash format

## Review Communication

- **Approve** — "This looks good, ready to merge."
- **Request Changes** — Clearly explain what needs to change and why.
- **Comment** — Advisory feedback, not blocking. Use for suggestions and questions.

Be specific in feedback. Reference line numbers. Suggest concrete alternatives when requesting changes.

---

*See [GOVERNANCE.md](../GOVERNANCE.md) for merge authority and [BRANCH_STRATEGY.md](BRANCH_STRATEGY.md) for the branch flow.*
