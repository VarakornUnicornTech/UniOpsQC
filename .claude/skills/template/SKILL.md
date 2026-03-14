# /template

## Purpose
RoundTable Framework version management. Check for updates, preview upgrade benefits and risks, apply safely with AI-assisted merge, or roll back to any previous version.

## Arguments
`/template [action] [options]`

| Action | Options | Description |
|--------|---------|-------------|
| *(none)* or `help` | — | Show all available commands |
| `version` | — | Quick local version + component count |
| `check update` | — | Compare local vs remote, warn if update available |
| `preview` | — | Upgrade impact analysis: benefits, risks, recommendation |
| `changelog [version]` | optional version string | Display changelog, optionally filtered |
| `apply` | — | Upgrade with backup + Smart Merge for conflicts |
| `rollback [version]` | optional version to restore | Restore from versioned backup |

## Dispatch

Parse `$ARGUMENTS`. The first word (or first two words for `check update`) is the action. Default to `help` if empty. Route to the relevant section below.

---

## ACTION: help

**Goal:** Quick reference of all available commands. No computation, no fetch.

Present:

```markdown
## RoundTable Framework — Template Commands

| Command | What it does |
|---------|-------------|
| `/template version` | Your installed version + component count |
| `/template check update` | Check if a newer version is available |
| `/template preview` | Benefits, risks, and upgrade recommendation |
| `/template changelog` | View what changed in each version |
| `/template apply` | Upgrade with backup + AI Smart Merge |
| `/template rollback` | Restore a previous version |

Run any command to get started.
```

---

## ACTION: version

**Goal:** Fast, local-only check. No remote fetch, no hash computation.

1. Read `template-version.json` from project root.
   - If missing: "No template-version.json found. This project may not be using RoundTable Framework."
   - Extract: `version`, `released`.

2. Scan `.claude/` structure and count:
   - CLAUDE.md present: YES/NO
   - Policy files in `TeamDocument/1. Policies/` (count `*.md`)
   - Agent files in `agents/` (count `*.md`)
   - Skill folders in `skills/` (count subfolders containing `SKILL.md`)
   - ProjectEnvironment.md present: YES/NO

3. Present:

```markdown
## RoundTable Framework — Version

| Property | Value |
|----------|-------|
| **Version** | [version] |
| **Released** | [released] |
| **CLAUDE.md** | Present / Missing |
| **Policies** | [N] files |
| **Agents** | [N]/5 files |
| **Skills** | [N] total |
| **ProjectEnvironment** | Present / Missing |
```

No hash computation. No remote fetch. This must be fast.

---

## ACTION: check update

1. Read local `version` from `template-version.json`.
   - If missing: "No template-version.json found — cannot determine current version."

2. Fetch remote `template-version.json`:
   `https://raw.githubusercontent.com/VarakornUnicornTech/roundtable-framework/main/template-version.json`
   - If fetch fails: "Could not reach remote repository."

3. Compare versions (semantic versioning):
   - local < remote → UPDATE AVAILABLE
   - local == remote → UP TO DATE
   - local > remote → AHEAD OF REMOTE

4. If major version jump (e.g., 1.x → 2.x), add breaking change warning.

5. Present:

```markdown
## RoundTable Framework — Update Check

| Property | Value |
|----------|-------|
| **Installed** | v[local] ([released]) |
| **Latest** | v[remote] ([remote-released]) |
| **Status** | UP TO DATE / UPDATE AVAILABLE / AHEAD OF REMOTE |

[If major version jump:]
### Breaking Change Warning
This is a MAJOR version update (v[old] → v[new]).
Some files may have structural changes. Run `/template preview` before upgrading.

### Next Steps
- Run `/template preview` to see benefits, risks, and recommendation
- Run `/template apply` to upgrade
```

---

## ACTION: preview

**Goal:** Help the user decide whether to upgrade. Present benefits, risks, and a clear recommendation — NOT a list of file hashes.

### Steps

1. Read local `template-version.json` → extract `version` and `file_hashes`.
2. Fetch remote `template-version.json` → extract remote `version` and `file_hashes`.
3. If local version == remote version: "You are already up to date. Nothing to preview."
4. Fetch remote `CHANGELOG.md` → extract entries newer than local version.

5. Classify all files using 3-way comparison (local hash vs base hash vs remote hash):

   | Local vs Base | Remote vs Base | Classification |
   |---------------|----------------|---------------|
   | Same | Same | UNCHANGED |
   | Same | Different | SAFE UPDATE — will be applied automatically |
   | Different | Same | LOCAL ONLY — will not be touched |
   | Different | Different | CONFLICT — AI will Smart Merge |
   | *(not in base)* | *(exists in remote)* | NEW — will be added |

6. Analyze the changelog and file changes to generate a user-friendly impact report.

7. Present:

```markdown
## RoundTable Framework — Upgrade Preview
**v[local] → v[remote]** ([release type: Major/Minor/Patch])

### Recommendation
**[Should Upgrade / Can Wait / Not Recommended]** — [one-line reason]

---

### Benefits of Upgrading

**1. [Category — e.g., Faster Workflow]**
- [specific benefit with context from changelog]

**2. [Category — e.g., Better Security]**
- [specific benefit]

**3. [Category — e.g., New Commands]**
- [specific benefit]

**4. [Category — e.g., New Integrations]**
- [specific benefit]

---

### Risks

| Risk | Level | Detail |
|------|-------|--------|
| [description] | High/Medium/Low | [explanation + what happens] |

### Post-Upgrade Tasks

| Task | Estimated Time |
|------|---------------|
| [what the user needs to do after upgrade] | [time] |
| **Total** | **[total time]** |

### What Will NOT Be Touched (Safe)
- [categories of files that are protected, e.g., "All your source code", "Your 5 agent customizations"]

---
*Run `/template apply` to proceed with upgrade*
*Run `/template changelog` to see full changelog*
```

**Key rules for this action:**
- Write from the user's perspective — "you get X", "your project gains Y"
- Group benefits by impact category, not by file name
- Risks must include severity level and concrete consequence
- Always include a clear recommendation with reasoning
- Estimate post-upgrade work time so the user can plan
- Never list raw file hashes or file-level diffs — that's not what users care about

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

## ACTION: apply

Upgrades the framework with automatic backup and AI-assisted Smart Merge for conflicts.

### Phase 1: Backup

1. Read local `template-version.json` → extract current `version`.
2. Create backup directory: `.claude/.backups/v[version]_[YYYY-MM-DD]/`
3. Copy ALL tracked files (from `file_hashes`) into the backup directory, preserving folder structure.
4. Copy `template-version.json` into the backup directory.
5. Write `manifest.json` in `.claude/.backups/` listing all backup snapshots:
   ```json
   {
     "backups": [
       {
         "version": "1.3.0",
         "date": "2026-03-14",
         "path": "v1.3.0_2026-03-14",
         "file_count": 28
       }
     ]
   }
   ```

### Phase 2: Safe Apply

1. Fetch remote `template-version.json`.
2. Classify all files (same logic as `preview`).
3. For **NEW** files (exist in remote, not in local baseline):
   - Fetch from remote and write to local. If file already exists locally, back it up first.
4. For **SAFE UPDATE** files (local unchanged, remote changed):
   - Fetch from remote and overwrite local.
5. For **LOCAL ONLY** files (local changed, remote unchanged):
   - Skip entirely. Do not touch.
6. Report progress as each file is processed.

### Phase 3: Smart Merge (for CONFLICT files)

For each file where both local and remote have changed:

1. Read the local file (user's current version with customizations).
2. Fetch the remote file (new framework version).
3. Analyze both versions:
   - Identify what the user customized (compared to base hash version).
   - Identify what the framework added/changed in the new version.
4. Create a **merged FINAL version** that:
   - Preserves the user's customizations.
   - Incorporates new framework features/changes.
   - Resolves structural conflicts intelligently.
5. Write the merged file to `.claude/.merge-preview/[filename].final.md`
6. If a file cannot be merged automatically:
   - Write a comparison file to `.claude/.merge-preview/[filename].comparison.md` explaining both versions and what differs.
   - Mark as MANUAL REVIEW NEEDED.

### Phase 4: Confirmation

After all phases complete, present:

```markdown
## RoundTable Framework — Upgrade Complete
**v[old] → v[new]**

### Applied Automatically
| Category | Files |
|----------|-------|
| New files added | [N] |
| Safe updates applied | [N] |
| Skipped (your customizations protected) | [N] |

### Smart Merge Results
AI has merged [N] conflict files, preserving your customizations while adding new framework features.

Preview merged files at: `.claude/.merge-preview/`

| File | Status |
|------|--------|
| [filename] | Merged — preview ready |
| [filename] | Merged — preview ready |
| [filename] | Could not auto-merge — comparison file created |

**Choose how to proceed:**
1. **Use merged versions** (recommended) — Apply all `.final.md` files
2. **Use merged versions selectively** — Specify which files to apply
3. **Use remote versions as-is** — Overwrite with new framework version (your customizations lost)
4. **Skip for now** — Keep your current files, review later

### Backup Location
`.claude/.backups/v[old]_[date]/`
Run `/template rollback` to undo this upgrade at any time.
```

Wait for user's choice before applying merge results.

### Post-Confirmation

Based on user's choice:
- **Option 1:** Copy all `.final.md` files to their actual locations (remove `.final.md` suffix).
- **Option 2:** Ask which files, then copy only those.
- **Option 3:** Copy remote versions directly (overwrite local).
- **Option 4:** Leave conflict files as-is (still on old version for those files).

After applying, update `template-version.json`:
- Set `version` and `released` to remote values.
- Recompute SHA-256 for all files and update `file_hashes`.

Clean up `.claude/.merge-preview/` directory after successful apply.

---

## ACTION: rollback [version]

1. Read `.claude/.backups/manifest.json`.
   - If missing or no backups: "No backups found. Nothing to roll back."

2. If version argument provided:
   - Find matching backup in manifest.
   - If not found: "No backup for version [X]. Available: [list versions]"

3. If no version argument, list available backups and ask:
   ```markdown
   ## Available Backups

   | # | Version | Date | Files |
   |---|---------|------|-------|
   | 1 | v1.4.0 | 2026-03-14 | 30 |
   | 2 | v1.3.0 | 2026-03-13 | 28 |

   Which version to restore? (enter number or version)
   ```

4. On selection, confirm before proceeding:
   ```
   Restore v[version] from [date]? This will overwrite [N] current files.
   Current version v[current] will be backed up first.
   Proceed? (yes/no)
   ```

5. On confirmation:
   - Back up current state first (create new backup entry).
   - Copy all files from selected backup to their original locations.
   - Restore `template-version.json` from backup.
   - Update `manifest.json`.

6. Present rollback report:
   ```markdown
   ## Rollback Complete
   **Restored to:** v[version] ([date])
   **Previous state backed up as:** v[current]_[today]

   [N] files restored successfully.
   ```

---

## Notes

- **SHA-256 computation:** `sha256sum "<absolute-path>"` — extract first 64 hex characters.
- **Remote URL pattern:** `https://raw.githubusercontent.com/VarakornUnicornTech/roundtable-framework/main/<path>` (spaces → `%20`).
- **Never track:** `RoundTable/` logs, `TeamDocument/2. TeamChat/`, `ProjectEnvironment.md`, `CHANGELOG.md`.
- **Backup location:** `.claude/.backups/` — versioned directories with manifest.
- **Merge preview location:** `.claude/.merge-preview/` — temporary, cleaned up after apply.
- **This skill ships with the framework** — consumers use it to pull future upstream updates safely.
