# Bug Reflection Index

**Location:** `.claude/reflection/`
**Purpose:** Searchable knowledge base of resolved bugs and their root causes. Prevents the same mistake from recurring across sessions and projects.

---

## How to Use

### Search

All reflection files use YAML frontmatter — search by any field:

```bash
# Find all TypeScript errors
grep -rl "language: TypeScript" .claude/reflection/

# Find Critical severity bugs
grep -rl "severity: Critical" .claude/reflection/

# Find bugs from a specific project
grep -rl "project: SyncSpace" .claude/reflection/

# Find a specific error type
grep -rl "error_type: TypeError" .claude/reflection/
```

### When to Create an Entry

**Team Monolith** creates a reflection entry whenever a bug ticket reaches `[x] Complete`. The resolved ticket file is the primary source — use its root cause analysis, fix description, and acceptance criteria.

Do not create entries for:
- Bugs that are still open (`[~]` or `[!]` status)
- Feature work (reflection is for bugs only)
- Hypothetical or speculative issues

### When to Read Entries

**Before starting any bug fix:** Search reflection for the error type and language. A cache hit means a known solution and prevention checklist are available — apply them before writing new code. A cache miss means you are dealing with a new class of bug — document it when resolved.

---

## File Naming Convention

```
[Lang]_[ErrorType]_[Name]_DD_MM_YYYY.md
```

| Part | Description | Examples |
|------|-------------|---------|
| `[Lang]` | Programming language | `TypeScript`, `Python`, `Go`, `SQL`, `Bash`, `CSharp` |
| `[ErrorType]` | Category of error | `TypeError`, `ReferenceError`, `NetworkError`, `MigrationError`, `AuthError`, `NullPointerException`, `RaceCondition` |
| `[Name]` | Short descriptive slug (PascalCase) | `UndefinedProperty`, `PortConflict`, `MissingColumn`, `CircularDependency` |
| `DD_MM_YYYY` | Date resolved (underscores, not hyphens) | `16_03_2026` |

**Examples:**
- `TypeScript_TypeError_UndefinedProperty_16_03_2026.md`
- `SQL_MigrationError_MissingColumn_14_03_2026.md`
- `Python_ImportError_CircularDependency_12_03_2026.md`
- `Go_RaceCondition_ConcurrentMapWrite_10_03_2026.md`

---

## YAML Frontmatter Fields

Every reflection file MUST begin with this frontmatter block (no exceptions):

```yaml
---
language: TypeScript           # Programming language (matches [Lang] in filename)
error_type: TypeError          # Error category (matches [ErrorType] in filename)
project: ProjectName           # Project where this bug was found and fixed
severity: Critical | High | Medium | Low
status: Resolved               # Always "Resolved" — entries are only created for completed bugs
ticket: MON-05                 # Ticket ID of the bug fix that resolved this
---
```

---

## Document Format

Every reflection file MUST include all 6 sections:

| Section | Content |
|---------|---------|
| **What Happened** | Error message verbatim + observable symptoms |
| **Root Cause** | Technical explanation of why the bug occurred |
| **Why Missed** | How it got through without earlier detection |
| **Fix Applied** | The exact change that resolved it (code before/after) |
| **Prevention Checklist** | Actionable steps to avoid this class of bug in future |
| **Lesson Learned** | One-sentence takeaway |

---

## Index

| File | Language | Error Type | Project | Severity | Date Resolved |
|------|----------|-----------|---------|----------|---------------|
| [TypeScript_TypeError_UndefinedProperty_16_03_2026.md](TypeScript_TypeError_UndefinedProperty_16_03_2026.md) | TypeScript | TypeError | Example | Medium | 16-03-2026 |

---

*Created: 16-03-2026*
