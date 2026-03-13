# PR #21 — Apology & Lessons Learned

**Date:** 14-03-2026
**From:** xMartin14091x (RoundTable Framework — Fork Maintainer)
**To:** VarakornUnicornTech (Upstream Maintainer)
**Regarding:** PR #21 — `feat(v2.0.0): Plugin layer + unified /git skill + rules + hooks + MCP`

---

## Apology

We sincerely apologize for the state of PR #21. The submission was premature, poorly structured, and did not meet the quality standards that this project — or any professional open-source collaboration — demands.

Specifically, we take responsibility for the following mistakes:

### 1. Wrong PR Flow (dev -> dev)
We submitted a pull request directly from our `dev` branch to upstream's `dev` branch. This is incorrect. The proper workflow is to create a dedicated **feature branch** on our fork, then PR that feature branch into upstream's `dev`. This made it impossible to iterate cleanly on review feedback without polluting the branch.

### 2. Non-Functional Hooks
The governance hooks (`check-ticket-exists`, `log-file-change`) were placed in `hooks/hooks.json` — a location that Claude Code **never reads**. The correct location is inside `.claude/settings.json` under the `"hooks"` key. This means the entire hook enforcement layer shipped broken. We advertised governance automation that did not work.

### 3. Severe Policy Loss in Rule Files
When compressing 9 policy files (~1,871 lines) into path-scoped rule files, we lost approximately **40% of operational procedures**. A formal audit identified 32 specific items: 20 completely dropped, 12 weakened to the point of being ineffective. Critical standards like the Output Delivered block, Ticket File template, OverseerReport format, HandOver standard, and all L3 completeness check details were silently omitted.

### 4. Stale File Hashes
The `template-version.json` file shipped with SHA-256 hashes that did not match the actual file contents. This means `/template diff` and `/template check` — key upgrade tools — would produce incorrect results for every user.

### 5. CHANGELOG Quality Issues
A duplicate `---` separator between version entries, and version descriptions that did not match actual shipped content.

### 6. Missing Platform Considerations
No mention of Windows compatibility concerns for hook scripts (bash shebang lines, path separators), despite the framework being used on Windows.

### 7. Script Bugs
- `check-ticket-exists.sh` — treated `$TOOL_INPUT` as a file path when Claude Code passes it as a full JSON object
- `log-file-change.sh` — potential race condition on concurrent writes to the audit log

---

## What We Have Done

1. **Rule files fully expanded** — All 7 rule files now contain ~100% of policy content (859 lines total, up from ~300). New `skills-and-subagents.md` added for previously uncovered section 8.
2. **Competitor references removed** — All mentions scrubbed from README.
3. **Feature branch created** — `feat/expand-rules-full-policy` with clean commit history.
4. **Documentation updated** — CLAUDE.md and README.md reflect accurate file counts and descriptions.
5. **CHANGELOG fixed** — Duplicate separator removed, rule count corrected.
6. **GitHubReference created** — Upstream PR process documented to prevent repeat mistakes.

## What Remains (In Progress)

1. Move hooks into `.claude/settings.json` (correct location)
2. Fix `$TOOL_INPUT` JSON parsing in hook scripts
3. Fix race condition in `log-file-change.sh`
4. Regenerate `template-version.json` file hashes
5. Add Windows compatibility notes
6. Close PR #21, open clean PR from feature branch

---

## Lessons Learned

1. **Never PR from `dev` directly.** Always create a feature branch — even for large changes.
2. **Test hooks in a real Claude Code session** before claiming they work.
3. **Policy compression requires formal audit.** Compressing detailed standards into summaries loses critical operational detail. When in doubt, keep the full content.
4. **File hashes must be regenerated** after any file modification — never ship stale hashes.
5. **Review your own PR** before submitting — read every changed file as if you were the reviewer.
6. **Platform testing matters.** If the framework claims cross-platform support, verify on each platform.

---

## Commitment

We will not submit the replacement PR until every item in the "What Remains" list is resolved, verified, and tested. We respect the maintainer's time and will ensure the next submission meets the standard.

We appreciate the thorough review and the patience shown in providing detailed feedback. The review made our framework significantly better.
