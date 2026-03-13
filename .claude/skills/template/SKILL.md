# /template

## Purpose
RoundTable Framework version management. Check for upstream updates, inspect what changed, apply safely, or roll back — without losing your local customizations.

## Arguments
`/template [action] [options]`

| Action | Options | Description |
|--------|---------|-------------|
| *(none)* or `status` | — | Show installation state and version |
| `changelog [version]` | optional version string | Display changelog, optionally filtered |
| `check` | — | Compare local vs remote version |
| `diff` | — | 3-way diff: local vs base vs remote |
| `apply [scope]` | `recommended` (default) \| `all` \| `<file-path>` | Apply remote updates safely |
| `rollback` | — | Restore files from last apply backup |

## Dispatch

Parse `$ARGUMENTS`. The first word is the action (default `status` if empty). Route to the relevant section below.

---

## ACTION: status

1. Read `template-version.json` from project root.
   - If missing: "No template-version.json found. This project may not be using RoundTable Framework."
   - Extract: `version`, `released`.

2. Scan `.claude/` structure and count:
   - CLAUDE.md present: YES/NO
   - Policy files in `TeamDocument/1. Policies/` (expect 8)
   - Agent files in `agents/` (expect 5)
   - Skill folders in `skills/` (count subfolders)
   - ProjectEnvironment.md present: YES/NO

3. Check customization state:
   - Read `file_hashes` from `template-version.json`. For each tracked file, compute local SHA-256 using Bash: `sha256sum <file>`. Compare to stored base hash.
   - Files where local hash ≠ base hash → mark as CUSTOMIZED.
   - If `file_hashes` is absent → mark all as UNTRACKED.

4. Present:

```markdown
## RoundTable Framework — Status

| Property | Value |
|----------|-------|
| **Version** | [version] |
| **Released** | [released] |
| **CLAUDE.md** | Present / Missing |
| **Policies** | [N]/8 files |
| **Agents** | [N]/5 files |
| **Skills** | [N] total |
| **ProjectEnvironment** | Present / Missing |

### Customized Files (local changes detected)
- [list files where local hash ≠ base hash, or "None — installation matches baseline"]

### Missing Defaults
- [list any expected files not found, or "None"]
```

---

## ACTION: changelog [version]

1. Read `template-version.json` → extract `version` (current installed).

2. Read `CHANGELOG.md` from project root.
   - If missing: "No CHANGELOG.md found."

3. If version argument provided:
   - Find section `## [version]` in file.
   - Display that section only.
   - If not found: "Version [X] not found. Available: [list headings]"

4. If no version argument: display full file contents.

5. Append footer: `Current installed version: [version]`

---

## ACTION: check

1. Read local `version` from `template-version.json`.
   - If missing: "No template-version.json found — cannot determine current version."

2. Fetch remote `template-version.json`:
   `https://raw.githubusercontent.com/VarakornUnicornTech/unicorn_roundtable_framework_repo/main/template-version.json`
   - If fetch fails: "Could not reach remote repository."

3. Compare versions (semantic versioning):
   - local < remote → UPDATE AVAILABLE
   - local == remote → UP TO DATE
   - local > remote → AHEAD OF REMOTE

4. If UPDATE AVAILABLE: also fetch remote `CHANGELOG.md` and extract sections newer than local version.

5. Present:

```markdown
## RoundTable Framework — Update Check

| Property | Value |
|----------|-------|
| **Local version** | [local] |
| **Remote version** | [remote] |
| **Status** | UP TO DATE / UPDATE AVAILABLE / AHEAD OF REMOTE |

### What's New (since [local version])
[changelog entries for newer versions, or "Nothing — you're up to date."]

### Next Steps
- Run `/template diff` to see exactly what changed
- Run `/template apply` to apply the update
```

---

## ACTION: diff

Performs a 3-way comparison: **local file** vs **base hash** (stored at install time) vs **remote file**.

### Classification logic

| Local hash vs Base | Remote hash vs Base | Classification |
|--------------------|---------------------|---------------|
| Same | Same | UNCHANGED — skip |
| Same | Different | REMOTE ONLY — safe to apply |
| Different | Same | LOCAL ONLY — skip, never overwrite |
| Different | Different | CONFLICT — requires decision |

### Steps

1. Read `template-version.json` → extract `file_hashes` map and `version`.
   - If `file_hashes` absent: "No baseline hashes found. Run `/template apply` once to establish baseline. Falling back to 2-way diff (LOCAL ONLY protection unavailable)."

2. Fetch remote `template-version.json` to get remote version.

3. For each file in `file_hashes`:
   a. Compute local SHA-256 via Bash: `sha256sum "<project-root>/<file-path>"` → extract hex.
   b. Fetch remote file from:
      `https://raw.githubusercontent.com/VarakornUnicornTech/unicorn_roundtable_framework_repo/main/<url-encoded-path>`
      URL-encode spaces as `%20`.
      If remote fetch fails: mark as REMOTE MISSING.
   c. Compute remote SHA-256: `printf '%s' "$remote_content" | sha256sum` → extract hex.
   d. Classify using the table above.

4. Present grouped results:

```markdown
## RoundTable Framework — Diff Report
**Local:** v[local] | **Remote:** v[remote]

### REMOTE ONLY — Safe to Apply ([N] files)
- `.claude/TeamDocument/1. Policies/02_Ticket_and_Briefing.md`

### LOCAL ONLY — Protected ([N] files)
- `.claude/TeamDocument/1. Policies/06_Debugging_Protocol.md`

### CONFLICT — Requires Decision ([N] files)
- `.claude/CLAUDE.md`
  Your change: [description]
  Remote change: [description]
  → Options: keep-mine | keep-remote | skip

### UNCHANGED ([N] files)
No changes on either side.

---
Run `/template apply` to apply REMOTE ONLY changes.
Run `/template apply all` to apply REMOTE ONLY + prompt on CONFLICTs.
```

---

## ACTION: apply [scope]

Scope values:
- `recommended` (default) — apply REMOTE ONLY files only. Never touch LOCAL ONLY or CONFLICT.
- `all` — apply REMOTE ONLY, then prompt for each CONFLICT resolution.
- `<file-path>` — apply a single specific file (explicit override, warns before proceeding).

### Steps

1. Run the full diff logic (same as ACTION: diff) to classify all files.

2. **Back up before touching anything:**
   - For every file that will be modified: copy it to `<file>.backup`
   - Copy `template-version.json` to `template-version.backup.json`

3. **Apply by scope** (see scope rules above).

4. **Update `template-version.json`** after all writes:
   - Set `version` to remote version.
   - Set `released` to remote released date.
   - Recompute SHA-256 for every file that was written.
   - LOCAL ONLY files keep their existing hash (base advances only for updated files).

5. **Present apply report:**

```markdown
## RoundTable Framework — Apply Complete
**Updated to:** v[remote version]

### Applied
| File | Status |
|------|--------|
| [path] | Updated |

### Skipped (LOCAL ONLY — your changes protected)
| File | Reason |
|------|--------|

### Conflicts Remaining
| File | Action needed |
|------|--------------|
| [path] | Run `/template apply <path>` after manual review |

### Backup files created
All .backup files saved. Run `/template rollback` to undo.
```

---

## ACTION: rollback

1. Check for backup files:
   - Look for `template-version.backup.json` at project root.
   - Scan `.claude/` recursively for `*.backup` files.
   - If none found: "No backup files found. Nothing to roll back."

2. List all backup files and confirm:
   ```
   Found [N] backup files from the last update. Rollback will restore:
   - [original-path] ← [backup-path]
   Proceed with rollback? (yes/no)
   ```

3. On confirmation:
   - Copy each `.backup` file over its original.
   - Restore `template-version.backup.json` → `template-version.json`.
   - Remove all `.backup` files after successful restore.

4. Present rollback report.

---

## Notes

- **SHA-256 computation:** `sha256sum "<absolute-path>"` — extract first 64 hex characters.
- **Remote URL pattern:** `https://raw.githubusercontent.com/VarakornUnicornTech/unicorn_roundtable_framework_repo/main/<path>` (spaces → `%20`).
- **Never track:** `RoundTable/` logs, `TeamDocument/2. TeamChat/`, `ProjectEnvironment.md`, `CHANGELOG.md`.
- **This skill ships with the framework** — consumers use it to pull future upstream updates safely.
