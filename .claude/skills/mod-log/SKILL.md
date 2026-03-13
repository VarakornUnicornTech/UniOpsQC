# /mod-log

## Purpose
Create a `PLANNED` modification log file and ticket folder structure in the correct project's `04_Modification Logs/` path.

## Arguments
`$ARGUMENTS` = `[ProjectName] [name]`
- **ProjectName** — must match an entry in `.claude/ProjectEnvironment.md`
- **name** — short name for the modification (becomes part of the file/folder name)

## Help
If `$ARGUMENTS` is `help` (i.e., invoked as `/mod-log help`), print the following and STOP — do NOT execute any steps.

```
/mod-log — Create a PLANNED modification log file and ticket folder structure

SYNTAX:
  /mod-log [ProjectName] [name]

ARGUMENTS:
  ProjectName   Required. Must match an entry in ProjectEnvironment.md
  name          Required. Short modification name (becomes part of the file/folder name)

EXAMPLES:
  /mod-log VSCodeRealtimeExtension AddRoomTimeout    Create modification log for AddRoomTimeout
  /mod-log AeroMedica RefactorAssessFlow             Create modification log for RefactorAssessFlow
  /mod-log help                                      Show this help text
```

---

## Steps

1. Read `.claude/ProjectEnvironment.md` and locate the `PROJECT_ROOT` for the given ProjectName.

2. Navigate to `[PROJECT_ROOT]/Development/[ProjectName]/04_Modification Logs/` (Decentralized or pre-existing layout) or `[PROJECT_ROOT]/Development/04_Modification Logs/` (Centralized, no pre-existing). Check which layout exists.

3. Scan the target folder to determine the next ORDER number (count existing entries, add 1).

4. Get today's date in DD-MM-YYYY format.

5. Create the main overview file:
   ```
   [ORDER]. PLANNED_[name]_[DD-MM-YYYY].md
   ```
   Content must include: what is being modified, why (brief rationale), scope of change, ticket list (MON/SYN/ARC as applicable).

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
