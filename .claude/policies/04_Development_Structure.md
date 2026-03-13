# §4 — Development Structure, Project Organization & Planning Workflow

> **Policy reference file.** Loaded on-demand from `.claude/TeamDocument/1. Policies/`. Core rules live in CLAUDE.md.

---

## Project Organization

```
[PROJECT_ROOT]/
├── .claude/
│   ├── CLAUDE.md                        # Core policy file (slim)
│   ├── ProjectEnvironment.md            # Active project registry — mode, root paths, source paths
│   ├── policies/                        # Detailed policy reference files (loaded on-demand)
│   ├── Team Roster/                     # Team definitions
│   │   ├── 1. Team_Overseer.md
│   │   ├── 2. Team_Monolith.md
│   │   ├── 3. Team_Syndicate.md
│   │   ├── 4. Team_Arcade.md
│   │   └── 5. Team_Cipher.md
│   ├── Team Chat/                       # Inter/intra team logs
│   │   ├── 1. Monolith/
│   │   │   ├── DD-MM-YYYY_Monolith.md
│   │   │   └── HandOver/
│   │   ├── 2. Syndicate/
│   │   │   ├── DD-MM-YYYY_Syndicate.md
│   │   │   └── HandOver/
│   │   ├── 3. Arcade/
│   │   │   ├── DD-MM-YYYY_Arcade.md
│   │   │   └── HandOver/
│   │   └── 4. OverseerReport/
│   │       └── DD-MM-YYYY_OverseerReport.md
│   ├── Diagnostic Log/                  # Cipher engagement records
│   │   └── [NUMBER]. [TASK]_DD_MM_YYYY.md
│   ├── skills/                          # Custom slash commands
│   ├── agents/                          # Team subagent definitions
│   └── settings.json                    # Permissions and hooks
├── RoundTable/
│   ├── _Index.md                        # Volume navigation index
│   └── DD-MM-YYYY_RoundTable.md         # Daily session logs (with Volume system)
└── [ProjectName]/                       # Project workspaces
    ├── Development/                     # Planning & documentation
    └── Projects/                        # Source code (if multi-component)
```

---

## ProjectEnvironment.md

Every project hub uses a **ProjectEnvironment.md** file at `.claude/ProjectEnvironment.md` to declare the active mode, project root paths, and source code locations.

**Location:** `.claude/ProjectEnvironment.md`

**Format:**

```markdown
# ProjectEnvironment

## Active Projects

### [ProjectName]
**PROJECT_MODE:** Centralized | Decentralized
**PROJECT_ROOT:** [absolute path to planning hub]
**SOURCE_ROOT:** [absolute path to source code — same as PROJECT_ROOT if Centralized]
**ACTIVE:** true | false
**Notes:** [any special path notes]
```

**Rules:**
- Check this file before constructing any Development folder path or PreExisting TechStack path
- If a project is not listed here, add it before beginning work
- `SOURCE_ROOT` and `PROJECT_ROOT` are the same in Centralized mode; different in Decentralized mode
- Set `ACTIVE: false` for projects that are on hold — do not delete entries

---

## Project Structure Mode

Every project operates in one of two modes. The active mode is declared in `.claude/ProjectEnvironment.md → PROJECT_MODE`.

### Centralized Mode

Planning and source code share the same project root. Use for greenfield projects or solo projects.

### Decentralized Mode

Planning hub and source code are fully separated. Use for pre-existing codebases, client repos, multi-repo projects. Source code path recorded in `ProjectEnvironment.md → SOURCE_ROOT`.

### Mode Decision: Centralized = greenfield/solo. Decentralized = pre-existing/client/multi-repo.

### Development Folder Contents (canonical — one tree for all modes)

```
[Development/ or Development/[ProjectName]/]
├── 01_Implementation Logs/       # Tickets, briefings, phase logs
├── 02_FeatureDescription/        # Feature documentation
├── 03_SubFeatures Implementation/
├── 04_Modification Logs/
├── 05_BugFixesLog/
├── 06_InstallationGuide/         # Setup/deploy docs
├── 07_TechnicalDebt/             # Temporary fixes needing cleanup
├── 08_AuditReport/               # /audit reports (MANDATORY)
├── 09_TestCase/                  # Test plans and coverage index (MANDATORY)
├── Current TechStack.md          # Living doc: all classes, methods, functions
├── Main Implementation Plan.md   # READ-ONLY core roadmap
├── Main TechStack Logic.md       # READ-ONLY tech documentation
├── ErrorCatalog.md               # Error code registry (see Error Code Catalog below)
└── PreExisting TechStack/        # (Pre-existing projects only)
    └── [ProjectName].md
```

**Folder nesting rule:** Centralized without pre-existing codebase → flat `Development/`. All other cases (pre-existing, Decentralized) → `Development/[ProjectName]/`. The `[ProjectName]/` layer is mandatory when a PreExisting TechStack exists.

---

## Planning-First Workflow (Development Folder Policy)

### CRITICAL RULE: Plan Before Implementation

When Commander ท่านผู้บัญชาการ requests ANY implementation work (fix a bug, add a feature, modify existing code), you MUST:

1. **Create a plan document FIRST** in the appropriate Development folder
2. **Wait for explicit Commander ท่านผู้บัญชาการ confirmation** ("approved", "proceed", "go ahead", "yes") before implementing
3. **Never implement without approval** — no matter how simple the task appears

### No-Code-Before-Ticket Rule (NEW — 13-03-2026)

> *Origin: Real-world deployment — multiple bug fixes and features implemented without Development folder tickets. Live session momentum caused Conductor to skip paperwork repeatedly. Commander directive: strict compliance, no exceptions.*

**No code change may be made — not a single line — until its ticket exists in the Development folder.**

This applies to ALL scenarios without exception:
1. **Bug discovered during live Commander testing** — file `05_BugFixesLog/` ticket FIRST, then fix
2. **Feature approved in RoundTable discussion** — file `03_SubFeatures/` or `04_Modification/` ticket FIRST, then implement
3. **"Quick fix" or "one-liner"** — file ticket FIRST, then fix
4. **Urgent production issue** — file ticket FIRST, then fix

**Conductor enforcement duty:** The Conductor must halt any implementation attempt that lacks a Development folder ticket and create the ticket before proceeding. "The conversation is moving fast" is not an exception. "It's just one file" is not an exception. There are no exceptions. Only Commander ท่านผู้บัญชาการ can explicitly waive this rule for a specific change.

**Verification:** Before any tool call that creates or modifies source code, the Conductor confirms the ticket exists. If it doesn't, the Conductor stops and creates it.

**Violation consequence:** Any code change without a prior ticket is logged as a §4 violation in the RoundTable session log with root cause and corrective action.

### Implementation Logs Internal Structure

```
01_Implementation Logs/[VERSION]/Phase [N]/
├── [TeamName]_Phase[N]_Briefing.md   # Briefings at Phase root
├── 1. Overseer/                      # OVR-XX tickets
├── 2. Monolith/                      # MON-XX tickets
├── 3. Syndicate/                     # SYN-XX tickets
└── 4. Arcade/                        # ARC-XX tickets
```

SubFeatures/Modification/BugFix folders each contain: `[ORDER]. [STATUS]_[Name]_DD-MM-YYYY.md` (overview) + `[STATUS]_[Name]_DD-MM-YYYY/` (tickets in team subfolders: 1. Overseer/, 2. Monolith/, 3. Syndicate/, 4. Arcade/).

---

### Request Type → Destination Folder

| Commander's Request | Destination Folder |
|-------------------------------|-------------------|
| "Fix bug in X" | `05_BugFixesLog/[FeatureName]/` |
| "Add feature X" | `03_SubFeatures Implementation/` |
| "Modify/expand X" | `04_Modification Logs/[FeatureName]/` |
| "Document X" | `02_FeatureDescription/[FeatureName]/` |

### Naming Conventions

**Implementation Logs & SubFeatures:**
```
[ORDER]. [FeatureName]_DD-MM-YYYY.md
```
Example: `01. RomanceSystem_04-02-2026.md`

**SubFeature, Modification & Bug Fix Logs (Main Overview + Tickets):**

Main overview file:
```
[ORDER]. [STATUS]_[Name]_DD-MM-YYYY.md
```

Tickets folder:
```
[STATUS]_[Name]_DD-MM-YYYY/
├── 1. Overseer/
├── 2. Monolith/
├── 3. Syndicate/
└── 4. Arcade/
```

- STATUS: `PLANNED` or `IMPLEMENTED` (both file AND folder rename on completion)
- Ticket naming: `[TEAM_PREFIX]-[NUMBER]_[ShortName].md` (e.g., `MON-01_ParseOverseerOutput.md`)

### Main Document Rules

**Main Implementation Plan.md** and **Main TechStack Logic.md** are **READ-ONLY**.

**Allowed actions:** Update checkboxes/status only.

**If changes needed:** Create `Indev Implementation Plan.md` or `Indev TechStack.md` with proposed changes and get Commander ท่านผู้บัญชาการ approval before merging.

**Current TechStack.md** is a **living document** — document all Classes, Methods, and Functions created in code with explanation here.

### Workflow Steps

1. Identify request type and destination folder
2. Determine next ORDER number in target folder
3. Create **main overview file** with `PLANNED` status (brief description + ticket list)
4. Create **tickets folder** (`PLANNED_[Name]_DD-MM-YYYY/`) with team subfolders
5. Create **individual tickets** in team subfolders (detailed specs + acceptance criteria)
6. Present plan location to Commander ท่านผู้บัญชาการ and ask for approval
7. **WAIT** for Commander ท่านผู้บัญชาการ to approve
8. After approval: implement and rename `PLANNED` → `IMPLEMENTED` (both file and folder)
9. Log in `01_Implementation Logs/` if major feature
10. Update `Current TechStack.md` with new classes/methods/functions

### Source Code Structure

For projects with multiple sub-projects (e.g., server, extension, dashboard):

```
[ProjectName]/
├── Development/                     # Planning & documentation
├── Projects/                        # Actual source code
│   ├── [component-1]/
│   ├── [component-2]/
│   └── [shared]/
└── .stignore / .gitignore
```

| Project Type | Use Projects/ Folder? |
|--------------|----------------------|
| Single codebase (one language/framework) | No — put source at root |
| Multi-component (server + client + shared) | **Yes** |
| Monorepo with distinct apps | **Yes** |
| Simple scripts or utilities | No |

### Folder-Specific Notes

- **06_InstallationGuide:** Setup, dependency, config, and deployment docs.
- **07_TechnicalDebt:** Temporary/hacky fixes needing future cleanup.
- **08_AuditReport (MANDATORY):** `/audit` reports filed here. Naming: `Audit[N]-[Description]_[DD-MM-YYYY].md`. Audit = what was found; `05_BugFixesLog/` = what was fixed.

---

## State Transparency Rule (NEW — 12-03-2026)

> *Origin: SyncSpace silent no-ops made debugging impossible.*

**Every system component MUST expose its current operational state through at minimum one observable channel.**

1. **Connection/session state must be visible** to both user (status bar) and developer (log on state change).
2. **No silent no-ops.** Skipped operations MUST log the reason. `if (!roomId) return` is a violation — must be `if (!roomId) { console.warn('[WARN] skipped: not in a room'); return }`.
3. **State transitions are always logged.** Join/leave, connect/disconnect, open/close — every transition gets a log line.

---

## Regulated Test Location — 09_TestCase (NEW — 12-03-2026)

> *Origin: SyncSpace tests scattered with no centralized index — coverage gaps invisible.*

**`09_TestCase/` is mandatory** in every project's Development directory. Structure: `[FeatureName]/{unit,integration,e2e}/` + `_regression/[bugId]_[desc].*`.

- Stores test **plans and documentation** (the index). Executable test code lives in the source tree (`__tests__/`, `*.test.ts`).
- Regression tests from hotfixes (§2 Hotfix Regression Gate) indexed in `_regression/`.
- **Verification Scholar owns this folder** — maintains index and flags coverage gaps.

---

## Cross-Package Change Manifest (NEW — 12-03-2026)

> *Origin: SyncSpace fix spanned 3 packages with no cross-package tracking — caused sync breakage.*

**Any change spanning 2+ packages MUST include a `### Cross-Package Change Manifest` section in the ticket/bug fix file.**

The manifest lists: every package touched, files changed, interface contracts affected, data flow direction. Paired with TechStack — new code must be added to Current TechStack in the same commit. Cross-Layer Trace (§6) is the verification step.

**Template columns:** `| Package | Files Changed | What Changed | Interface Impact |` + `Data flow:` line + `TechStack update required: Yes/No`.

---

## Error Code Catalog (NEW — 12-03-2026)

> *Origin: SyncSpace had free-form error strings — no programmatic filtering possible.*

**Every project maintains `ErrorCatalog.md`** in its Development folder. Each error has: negative integer code, constant name (`ERR_[SUBSYSTEM]_[DESC]`), human message, subsystem.

**Prefix ranges:** `-1xxx` Core, `-2xxx` Server, `-3xxx` Extension/client, `-4xxx` Database, `-5xxx` Auth. Projects define additional ranges as needed.

**Rules:** All error responses MUST include the integer code alongside the message. New errors appended to catalog before code is committed. An error without a catalog entry is a policy violation.

---

## Living Documentation Rule (NEW — 12-03-2026)

> *Origin: SyncSpace TechStack not updated after Phase 3 — new methods undocumented.*

**`Current TechStack.md`, `PreExisting TechStack/`, and `ErrorCatalog.md` MUST be updated in the same session that creates or modifies the code they describe.**

1. **Same-session update.** TechStack updated before ticket is marked Complete.
2. **Deletion = removal from docs.** Stale entries are a documentation bug.
3. **Verification Scholar checks TechStack currency** as part of sign-off. Missing entry = ticket not Complete.
4. **Cross-Package Change Manifest** with "TechStack update required: Yes" blocks completion until done.

---

*Updated: 13-03-2026 — Added No-Code-Before-Ticket Rule. Commander directive (strict compliance). Origin: real-world deployment repeated §4 violations during live sessions.*
