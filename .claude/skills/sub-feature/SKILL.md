# /sub-feature

## Purpose
Create a `PLANNED` sub-feature file and ticket folder structure in the correct project's `03_SubFeatures Implementation/` path.

## Arguments
`$ARGUMENTS` = `[ProjectName] [name]`
- **ProjectName** — must match an entry in `.claude/ProjectEnvironment.md`
- **name** — short name for the sub-feature (becomes part of the file/folder name)

## Help
If `$ARGUMENTS` is `help` (i.e., invoked as `/sub-feature help`), print the following and STOP — do NOT execute any steps.

```
/sub-feature — Create a PLANNED sub-feature file and ticket folder structure

SYNTAX:
  /sub-feature [ProjectName] [name]

ARGUMENTS:
  ProjectName   Required. Must match an entry in ProjectEnvironment.md
  name          Required. Short feature name (becomes part of the file/folder name)

EXAMPLES:
  /sub-feature VSCodeRealtimeExtension BranchDiffViewer    Create sub-feature plan for BranchDiffViewer
  /sub-feature AeroMedica OfflineMode                      Create sub-feature plan for OfflineMode
  /sub-feature help                                        Show this help text
```

---

## Steps

1. Read `.claude/ProjectEnvironment.md` and locate the `PROJECT_ROOT` for the given ProjectName.

2. Navigate to `[PROJECT_ROOT]/Development/[ProjectName]/03_SubFeatures Implementation/` (Decentralized or pre-existing layout) or `[PROJECT_ROOT]/Development/03_SubFeatures Implementation/` (Centralized, no pre-existing). Check which layout exists.

3. Scan the target folder to determine the next ORDER number (count existing entries, add 1).

4. Get today's date in DD-MM-YYYY format.

5. Create the main overview file:
   ```
   [ORDER]. PLANNED_[name]_[DD-MM-YYYY].md
   ```
   Content must include: sub-feature description, what problem it solves or capability it adds, output location(s), ticket list (MON/SYN/ARC as applicable).

6. Create the tickets folder:
   ```
   PLANNED_[name]_[DD-MM-YYYY]/
   ├── 1. Overseer/
   ├── 2. Monolith/
   ├── 3. Syndicate/
   └── 4. Arcade/
   ```

7. Present the created file paths to Commander and confirm the plan is ready for ticket population.

## Output
File paths of the created overview file and ticket folder. Ask Commander which teams need tickets written.
