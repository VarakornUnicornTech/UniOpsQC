# /bug-report

## Purpose
Create a `PLANNED` bug fix file and ticket folder structure in the correct project's `05_BugFixesLog/` path.

## Arguments
`$ARGUMENTS` = `[ProjectName] [description]`
- **ProjectName** — must match an entry in `.claude/ProjectEnvironment.md`
- **description** — short name for the bug (becomes part of the file/folder name)

## Help
If `$ARGUMENTS` is `help` (i.e., invoked as `/bug-report help`), print the following and STOP — do NOT execute any steps.

```
/bug-report — Create a PLANNED bug fix file and ticket folder structure

SYNTAX:
  /bug-report [ProjectName] [description]

ARGUMENTS:
  ProjectName   Required. Must match an entry in ProjectEnvironment.md
  description   Required. Short bug name (becomes part of the file/folder name)

EXAMPLES:
  /bug-report VSCodeRealtimeExtension SnapshotEmpty    Create bug fix plan for SnapshotEmpty
  /bug-report AeroMedica LoginBroken                   Create bug fix plan for LoginBroken
  /bug-report help                                     Show this help text
```

---

## Steps

1. Read `.claude/ProjectEnvironment.md` and locate the `PROJECT_ROOT` for the given ProjectName.

2. Navigate to `[PROJECT_ROOT]/Development/[ProjectName]/05_BugFixesLog/` (Decentralized or pre-existing layout) or `[PROJECT_ROOT]/Development/05_BugFixesLog/` (Centralized, no pre-existing). Check which layout exists.

3. Scan the target folder to determine the next ORDER number (count existing entries, add 1).

4. Get today's date in DD-MM-YYYY format.

5. Create the main overview file:
   ```
   [ORDER]. PLANNED_[description]_[DD-MM-YYYY].md
   ```
   Content must include: bug description, affected system/file (if known), ticket list (MON/SYN/ARC as applicable), and a brief scope statement.

6. Create the tickets folder:
   ```
   PLANNED_[description]_[DD-MM-YYYY]/
   ├── 1. Overseer/
   ├── 2. Monolith/
   ├── 3. Syndicate/
   └── 4. Arcade/
   ```

7. Present the created file paths to Commander and confirm the plan is ready for ticket population.

## Output
File paths of the created overview file and ticket folder. Ask Commander which teams need tickets written.
