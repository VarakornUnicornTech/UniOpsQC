# §4 — Development Structure, Project Organization & Planning Workflow

> **Policy reference file.** Loaded on-demand from `.claude/TeamDocument/1. Policies/`. Core rules live in CLAUDE.md.

---

## Project Organization

```
├── .claude/
│   ├── CLAUDE.md                        # Core policy file
│   ├── ProjectEnvironment.md            # Project path config, mode, source registry — fill on setup
│   ├── TeamDocument/
│   │   ├── 1. Policies/                 # Detailed policy reference files (loaded on-demand)
│   │   ├── 2. TeamChat/                 # Inter/intra team logs
│   │   │   ├── 1. Monolith/
│   │   │   │   ├── DD-MM-YYYY_Monolith.md
│   │   │   │   └── HandOver/
│   │   │   ├── 2. Syndicate/
│   │   │   │   ├── DD-MM-YYYY_Syndicate.md
│   │   │   │   └── HandOver/
│   │   │   ├── 3. Arcade/
│   │   │   │   ├── DD-MM-YYYY_Arcade.md
│   │   │   │   └── HandOver/
│   │   │   └── 4. OverseerReport/
│   │   │       └── DD-MM-YYYY_OverseerReport.md
│   │   └── Diagnostic Log/             # Cipher engagement records
│   │       └── [NUMBER]. [TASK]_DD_MM_YYYY.md
├── RoundTable/
│   ├── _Index.md                        # Volume navigation index
│   └── DD-MM-YYYY_RoundTable.md         # Daily session logs (with Volume system)
└── [ProjectName]/                       # Project workspaces
    ├── Development/                     # Planning & documentation
    └── Projects/                       # Source code (if multi-component)
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

Planning and source code share the same project root. Use for greenfield projects or projects you own end-to-end.

**Development folder shape — no pre-existing codebase:**
```
Development/
├── 01_Implementation Logs/
├── 02_FeatureDescription/
├── 03_SubFeatures Implementation/
├── 04_Modification Logs/
├── 05_BugFixesLog/
├── 06_InstallationGuide/
├── 07_TechnicalDebt/
├── 08_AuditReport/
├── Current TechStack.md
├── Main Implementation Plan.md
└── Main TechStack Logic.md
```

**Development folder shape — WITH pre-existing codebase:**
```
Development/
└── [ProjectName]/
    ├── 01_Implementation Logs/
    ├── 02_FeatureDescription/
    ├── 03_SubFeatures Implementation/
    ├── 04_Modification Logs/
    ├── 05_BugFixesLog/
    ├── 06_InstallationGuide/
    ├── 07_TechnicalDebt/
    ├── 08_AuditReport/
    ├── Current TechStack.md
    ├── Main Implementation Plan.md
    ├── Main TechStack Logic.md
    └── PreExisting TechStack/
        └── [ProjectName].md
```

Source code location (Centralized):
```
├── .claude/
├── Development/
├── RoundTable/
└── [src-folder]/                         # Source code lives here, inside the same root
```

### Decentralized Mode

Planning hub and source code are fully separated. Use for pre-existing codebases, client repos, multi-repo projects, or any codebase you cannot restructure.

**Development folder shape (always named subfolder):**
```
Development/
└── [ProjectName]/
    ├── 01_Implementation Logs/
    ├── 02_FeatureDescription/
    ├── 03_SubFeatures Implementation/
    ├── 04_Modification Logs/
    ├── 05_BugFixesLog/
    ├── 06_InstallationGuide/
    ├── 07_TechnicalDebt/
    ├── 08_AuditReport/
    ├── Current TechStack.md
    ├── Main Implementation Plan.md
    ├── Main TechStack Logic.md
    └── PreExisting TechStack/
        └── [ProjectName].md
```

Source code location (Decentralized):
```
[Project Root]/          ← Planning hub root
[EXTERNAL_PATH]\         ← Source code lives here, outside the root entirely
                           Record this path in ProjectEnvironment.md → SOURCE_ROOT
```

### Mode Decision Table

| Situation | Mode |
|-----------|------|
| Greenfield project, you own the repo end-to-end | Centralized |
| Pre-existing codebase you cannot restructure | Decentralized |
| Client repo or external repo | Decentralized |
| Multiple repos under one planning hub | Decentralized |
| Source code has sensitive history (no planning docs in git) | Decentralized |
| Simple solo project | Centralized |

### Pre-Existing Codebase Rule (applies to BOTH modes)

**Whenever a pre-existing codebase is involved — regardless of mode — use the named project subfolder shape.** The `Development/[ProjectName]/` layer is mandatory when a PreExisting TechStack scan file exists or will be created.

### PreExisting TechStack Path Formula

```
Development/[ProjectName]/PreExisting TechStack/[ProjectName].md
```

This formula applies in both Centralized (with pre-existing codebase) and Decentralized mode. There is no flat `Development/PreExisting TechStack/` path — the named project subfolder is always required.

---

## Planning-First Workflow (Development Folder Policy)

### CRITICAL RULE: Plan Before Implementation

When Commander requests ANY implementation work (fix a bug, add a feature, modify existing code), you MUST:

1. **Create a plan document FIRST** in the appropriate Development folder
2. **Wait for explicit Commander confirmation** ("approved", "proceed", "go ahead", "yes") before implementing
3. **Never implement without approval** — no matter how simple the task appears

### Development Folder Structure (Standard)

This is the **canonical template** for the contents of a project subfolder. The shape of `Development/` itself depends on the active mode — see **Project Structure Mode** section above.

```
[ProjectName]/
├── 01_Implementation Logs/           # Tickets, briefings, and completed implementation logs
│   └── [VERSION]/                    # e.g. INDEV v1.0.0 — one folder per release version
│       ├── Phase 0/
│       │   ├── Monolith_Phase0_Briefing.md   # Briefing at Phase root
│       │   ├── Syndicate_Phase0_Briefing.md
│       │   ├── Arcade_Phase0_Briefing.md
│       │   ├── 1. Overseer/          # OVR-XX tickets only
│       │   ├── 2. Monolith/          # MON-XX tickets only
│       │   ├── 3. Syndicate/         # SYN-XX tickets only
│       │   └── 4. Arcade/            # ARC-XX tickets only
│       ├── Phase 1/
│       │   └── (same structure: briefings at root, tickets in team subfolders)
│       └── Phase N/
├── 02_FeatureDescription/
│   └── [FeatureName]/
│       └── [ComponentName].md
├── 03_SubFeatures Implementation/
│   └── [FeatureName]/
│       ├── [ORDER]. [STATUS]_[Name]_DD-MM-YYYY.md
│       └── [STATUS]_[Name]_DD-MM-YYYY/
│           ├── 1. Overseer/
│           ├── 2. Monolith/
│           ├── 3. Syndicate/
│           └── 4. Arcade/
├── 04_Modification Logs/
│   └── [FeatureName]/
│       ├── [ORDER]. [STATUS]_[Name]_DD-MM-YYYY.md
│       └── [STATUS]_[Name]_DD-MM-YYYY/
│           └── (same team subfolder structure)
├── 05_BugFixesLog/
│   └── [FeatureName]/
│       ├── [ORDER]. [STATUS]_[Name]_DD-MM-YYYY.md
│       └── [STATUS]_[Name]_DD-MM-YYYY/
│           └── (same team subfolder structure)
├── 06_InstallationGuide/             # Setup guides, installation docs
├── 07_TechnicalDebt/                 # Temporary or hacky code fixes
├── 08_AuditReport/                   # Audit reports from /audit runs (MANDATORY)
├── Current TechStack.md              # Living doc: all classes, methods, functions
├── Main Implementation Plan.md       # READ-ONLY core roadmap
├── Main TechStack Logic.md           # READ-ONLY tech documentation
└── PreExisting TechStack/            # (Pre-existing projects only)
    └── [ProjectName].md
```

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

**If changes needed:** Create `Indev Implementation Plan.md` or `Indev TechStack.md` with proposed changes and get Commander's approval before merging.

**Current TechStack.md** is a **living document** — document all Classes, Methods, and Functions created in code with explanation here.

### Workflow Steps

1. Identify request type and destination folder
2. Determine next ORDER number in target folder
3. Create **main overview file** with `PLANNED` status (brief description + ticket list)
4. Create **tickets folder** (`PLANNED_[Name]_DD-MM-YYYY/`) with team subfolders
5. Create **individual tickets** in team subfolders (detailed specs + acceptance criteria)
6. Present plan location to Commander and ask for approval
7. **WAIT** for Commander to approve
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

### 06_InstallationGuide Contents

Store setup and installation documentation:
- Environment setup instructions
- Dependency installation guides
- Configuration procedures
- Deployment documentation

### 07_TechnicalDebt

Store all temporary or hacky code fixes that need future cleanup.

### 08_AuditReport (MANDATORY)

Store all audit reports generated by the `/audit` skill. **This folder is mandatory for every project.**

- Each audit report follows naming: `Audit[N]-[Description]_[DD-MM-YYYY].md`
- Audit reports document **what was found** — the bug catalogue, severity breakdown, and priority fix order
- Bug fix tracking stays in `05_BugFixesLog/` — that folder tracks **what was fixed**
- The `/audit` skill files reports here automatically
- If a project does not yet have this folder, create it before running or filing any audit

---

*Adopted from ClaudeTemplate — 11-03-2026. New additions: Project Structure Mode (Centralized/Decentralized), ProjectEnvironment.md standard, 08_AuditReport mandatory folder (COO directive 11-03-2026). Adapted for RoundTable: AM naming, relative paths.*
