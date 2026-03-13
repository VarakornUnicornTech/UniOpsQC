# Upstream PR Process — Reference Guide

**Upstream repo:** `VarakornUnicornTech/unicorn_roundtable_framework_repo`
**Our fork:** `xMartin14091x/unicorn_roundtable_framework_repo`

---

## Branch Workflow

```
upstream/dev <- feat/[feature-name] (on our fork)
```

**NEVER** PR `dev -> dev` or `dev -> main`. Always use a dedicated feature branch.

### Steps

1. **Sync fork** — `git fetch upstream && git rebase upstream/dev`
2. **Create feature branch** — `git checkout -b feat/[descriptive-name]`
3. **Develop on feature branch** — commit granularly, test thoroughly
4. **Rebase before PR** — `git fetch upstream && git rebase upstream/dev`
5. **Push feature branch** — `git push -u origin feat/[descriptive-name]`
6. **Open PR** — target `upstream/dev`, NOT `upstream/main`
7. **Respond to review** — fix on same branch, force-push if needed
8. **After merge** — delete feature branch, sync `dev`

---

## PR Requirements (from maintainer feedback on PR #21)

### Must Include
| Requirement | Details |
|-------------|---------|
| **MIGRATION.md** | Step-by-step upgrade guide for existing users — required for any breaking change |
| **Version tag** | `template-version.json` must have correct version, date, and SHA-256 hashes |
| **Complete routing tables** | CLAUDE.md Team Assignment Routing must include ALL rows — never drop rows during edits |
| **Functional hooks** | Hooks must be in `.claude/settings.json` under `"hooks"` key — NOT in `hooks/hooks.json` |
| **Accurate CHANGELOG** | Every change documented, no duplicate separators, descriptions match reality |

### Must Verify Before Submitting
- [ ] All file hashes in `template-version.json` match actual file contents
- [ ] Hook scripts work in a real Claude Code session
- [ ] Rule files contain complete policy coverage (not lossy compression)
- [ ] README file counts match actual file counts
- [ ] No competitor mentions anywhere in codebase
- [ ] CHANGELOG entries are accurate and well-formatted
- [ ] Cross-platform concerns documented (Windows shell compatibility)

### Hook Script Standards
- `$TOOL_INPUT` is a **full JSON object**, not a file path — parse with `jq` or equivalent
- Scripts must handle concurrent execution (use atomic writes or file locking)
- Shebang `#!/bin/bash` — note Windows requires Git Bash or WSL
- Test scripts manually before shipping

---

## PR History

| PR | Date | Status | Notes |
|----|------|--------|-------|
| #21 | 14-03-2026 | Changes Requested | dev->dev (wrong flow), 9 issues flagged by maintainer, hooks non-functional, 40% policy loss in rules |
| — | 14-03-2026 | In Progress | Replacement PR from `feat/expand-rules-full-policy` — fixing all 9 issues |
