# /audit

## Purpose
End-to-end multi-domain audit. Finds bugs that static file-level analysis misses by tracing
user-facing actions through every system layer and scanning for known bug patterns across
6 audit domains. Files a bug report for every issue found.

---

## Arguments
`$ARGUMENTS` = `[ProjectName] [scope?]`
- **ProjectName** — must match an entry in `.claude/ProjectEnvironment.md`
- **scope** (optional) — audit domain to run, OR a quoted symptom description for targeted bug-finding. Default: `*` (all domains).
  - `*` — run all 6 domains
  - `ux-flow` — UX gap bugs and silent failures at layer handoffs
  - `data` — database/state consistency, transactions, race conditions
  - `logic` — business logic, state machines, validation, concurrency
  - `security` — auth checks, IDOR, injection, exposed data, rate limiting
  - `resources` — memory leaks, listener leaks, timer leaks, unbounded growth
  - `errors` — unhandled promises, swallowed exceptions, missing error propagation
  - `"symptom description"` — **Symptom Trace Mode**: quoted text triggers a targeted deep trace of the feature area described. All 6 domain checklists are applied to that feature only. Use this to investigate a specific reported bug.

---

## Help
If `$ARGUMENTS` is `help` (i.e., the command was invoked as `/audit help`), print the
following block and STOP — do NOT execute any steps.

```
/audit — Multi-Domain Code Audit

SYNTAX:
  /audit [ProjectName] [scope?]

ARGUMENTS:
  ProjectName   Required. Must match a project in ProjectEnvironment.md
  scope         Optional. Which audit domain to run (default: * = all)

SCOPE VALUES:
  *             All 6 domains (default)
  ux-flow       UX gap bugs — missing handlers, silent failures at layer handoffs
  data          Data layer — missing transactions, race conditions, N+1 queries, schema mismatches
  logic         Logic layer — off-by-one, wrong state transitions, missing validation
  security      Security — missing auth checks, IDOR, injection, exposed data, rate limiting
  resources     Resource layer — listener/timer leaks, unbounded Maps, unclosed connections
  errors        Error layer — unhandled promises, swallowed catch blocks, missing propagation

EXAMPLES:
  /audit VSCodeRealtimeExtension                                    Run full audit (all 6 domains)
  /audit VSCodeRealtimeExtension ux-flow                            Trace only UX flows and gap bugs
  /audit VSCodeRealtimeExtension security                           Run only the security domain pass
  /audit VSCodeRealtimeExtension data                               Check DB/state consistency only
  /audit VSCodeRealtimeExtension "user can't access Virtual Workspace"   Targeted trace for that symptom
  /audit help                                                       Show this help text
```

---

## Core Methodology

### Why this exists
File-level audits find bugs *within* a file. They miss **gap bugs** — missing code at the
handoff between two systems — and **cross-domain bugs** that only appear when you look at
the system from a different angle. This skill applies 6 distinct lenses, each catching a
different class of defect.

### The Rule
**Every feature visible to the user must have a verified, complete data path through every
layer. Every bug class must be checked by its own domain pass.** If a step is missing or a
pattern fires, that is a bug.

---

## Steps

### 1. Orient

Read `.claude/ProjectEnvironment.md` and locate:
- `PROJECT_ROOT` for the given ProjectName
- `SOURCE_ROOT` (where the actual source code lives)

**Large-codebase check:** If SOURCE_ROOT contains more than ~50 files, activate
**Manifest-First mode** (see Large Codebase Strategy section below) before reading any
implementation files.

---

### 2. Enumerate User Actions

Identify every user-facing action. Do NOT start with files — start with **what users do**.

Sources to read (adapt to project type):
- VS Code extension → `extension/src/commands/index.ts`, `package.json` contributes.commands, all tree view providers
- Web app → route files, page components, API endpoint index
- CLI tool → command registry, help text
- Mobile app → screen list, navigation graph

Output a numbered list:
```
USER ACTIONS:
1. Create room
2. Join room
3. Leave room
4. Create file (while in room)
5. Edit file
6. Delete file
7. Create snapshot
8. Restore snapshot
9. Switch to Virtual Workspace
10. Create branch
... (complete list)
```

If scope is a non-UX domain (`data`, `logic`, `security`, `resources`, `errors`), skip
enumeration and jump directly to the relevant domain pass in Step 3.

**Symptom Trace Mode** (scope is a quoted string):
Skip full enumeration. Instead:
1. Identify the feature area from the symptom text (e.g. "can't access Virtual Workspace" → workspace switch + file sync feature)
2. Read only the files related to that feature — commands, handlers, services, and their call chains
3. Trace the complete data path for that feature across all 8 layers
4. Apply all 6 domain checklists to the traced path only
5. Report findings using the same format as a full audit

This is a **targeted bug-finding pass** — narrower than a full audit but deeper on one feature. Use it when a specific user-reported symptom needs root cause analysis.

---

### 3. Domain Passes

Run only the domain(s) matching the `scope` argument. For `*`, run all 6 in order.

---

#### DOMAIN 1 — UX Flow (scope: `ux-flow` or `*`)

For each user action, trace the **complete data path** across ALL system layers.

**Lifecycle Boundary Check (run before tracing every feature):**
Before starting the 8-layer trace, ask: does any step in this feature trigger a
**state-destructive event** — a process restart, context switch, window reload, workspace
folder change, service deactivation, or session teardown?

If YES, split the trace into two phases:
- **Phase A (before the event):** trace normally. At the end of Phase A, verify that any
  in-flight data has reached a persistence layer (server state, DB, disk) BEFORE the event
  fires. In-memory state that exists only on the client is wiped at the boundary.
- **Phase B (after re-activation):** trace from a clean slate — treat all client-side
  in-memory state as empty. Verify that state is re-hydrated from persistence before
  dependent features are used.

A state-destructive event that fires while unsynced data sits only in memory is a **CRITICAL gap**.

**The 8-Layer Stack (adapt layer names to the project):**

| Layer | Question to answer |
|-------|-------------------|
| **L1 — User Trigger** | What event starts this? (button click, command, keyboard shortcut, WS event received) |
| **L2 — Extension Handler** | What function in the extension/client handles it? Where is it registered? |
| **L3 — Outbound Message** | What message/request is sent outbound? (WS send, HTTP request, IPC) |
| **L4 — Server Handler** | What function on the server receives and processes it? |
| **L5 — State Mutation** | What server-side state changes? (DB write, in-memory map update) |
| **L6 — Broadcast/Response** | What events/responses are sent back to connected clients? |
| **L7 — Extension Response** | What does the extension/client do when it receives the response? |
| **L8 — User Feedback** | What does the user see, hear, or experience as a result? |

**Handoff Checklist (apply at every L→L transition):**
```
[ ] EXISTS        — Does the receiving code for this handoff exist?
[ ] REACHABLE     — Is it actually called/triggered from the previous layer?
[ ] COMPLETE      — Does it handle the full payload (not just the happy-path fields)?
[ ] ERROR PATH    — If this step fails, is the error surfaced to the user?
[ ] SILENT FAIL   — Can this step fail with no visible feedback to the user?
[ ] PRECONDITIONS — If this step calls an existing helper, verify the helper's inputs are
                    guaranteed non-empty at call time. Presence of a helper is NOT a passing
                    check — verify what state it reads and whether that state is populated
                    at the exact moment of the call.
```

**A FAILED checklist item = a bug. Document it immediately.**

**Silent Failure Indicators to look for:**
```typescript
if (!condition) return;                    // guard with no error sent
catch (e) { console.error(...); }         // swallowed exception, no user feedback
if (files.length === 0) { /* nothing */ } // empty result accepted silently
const result = fn(); // result unused     // return value ignored
```

---

#### DOMAIN 2 — Data Layer (scope: `data` or `*`)

**Pattern-First:** Before reading implementations, grep for:
```
grep -rn "await.*\.(save|update|delete|insert|create)\("   // DB writes
grep -rn "\.set(\|\.delete(\|\.clear("                      // in-memory map mutations
grep -rn "for.*of.*await"                                   // potential N+1
```
Read only files that match. Then apply:

```
DATA LAYER CHECKLIST (per DB operation / in-memory state write):
[ ] TRANSACTION   — Multi-step writes wrapped in a transaction (no partial commits possible)
[ ] CONSTRAINT    — Required uniqueness / FK constraints defined in schema
[ ] RACE CONDITION — Concurrent writes to same key handled (mutex, optimistic lock, or similar)
[ ] N+1 QUERY     — Loops that issue per-item DB queries flagged for batching
[ ] NULL HANDLING — Code handles null/empty result from every DB read
[ ] CASCADE       — Deletes cascade correctly — no orphaned child records left behind
[ ] SYNC PATHS    — Every write to server state is reflected on the client after completion
```

---

#### DOMAIN 3 — Logic Layer (scope: `logic` or `*`)

**Pattern-First:** Grep for:
```
grep -rn "\.length - 1\|i <= \|i >= "    // boundary conditions
grep -rn "switch.*case\|if.*===.*state"  // state machines
grep -rn "req\.body\.\|req\.params\."    // unvalidated user input reaching logic
```

```
LOGIC LAYER CHECKLIST:
[ ] BOUNDARY      — Off-by-one on loops, index access, pagination, slice/splice
[ ] STATE MACHINE — Every valid state transition handled; invalid transitions rejected with error
[ ] VALIDATION    — All user-supplied inputs validated before processing (type, range, length)
[ ] CONCURRENCY   — Shared mutable state protected from concurrent access
[ ] IDEMPOTENCY   — Repeated operations (retries, double-clicks) don't double-apply effects
[ ] INVERSION     — Negation logic correct (! vs !== undefined vs falsy vs null)
```

---

#### DOMAIN 4 — Security Layer (scope: `security` or `*`)

**Pattern-First:** Grep for:
```
grep -rn "router\.\(get\|post\|put\|delete\|patch\)"  // all endpoints
grep -rn "eval(\|exec(\|shell\|spawn"                  // injection risk
grep -rn "console\.log\|res\.json"                     // potential data exposure
```

```
SECURITY CHECKLIST:
[ ] AUTH CHECK    — Every endpoint/handler verifies caller has permission before processing
[ ] IDOR          — Object IDs in requests validated against caller's ownership (not just existence)
[ ] INJECTION     — No user input reaches SQL / shell / eval / file path without sanitization
[ ] EXPOSURE      — No secrets, tokens, stack traces, or PII in logs, errors, or API responses
[ ] RATE LIMIT    — High-risk endpoints (auth, snapshot, bulk ops) have rate limiting
[ ] ORIGIN CHECK  — WebSocket / HTTP origin validated to prevent unauthorized connections
[ ] PRIVILEGE     — No operation allows a lower-privilege user to affect a higher-privilege resource
```

---

#### DOMAIN 5 — Resource Layer (scope: `resources` or `*`)

**Pattern-First:** Grep for and compare counts:
```
grep -rn "addEventListener\|\.on("             // listeners added
grep -rn "removeEventListener\|\.off("         // listeners removed
grep -rn "setInterval\|setTimeout"             // timers started
grep -rn "clearInterval\|clearTimeout"         // timers cleared
grep -rn "new Map(\|new Set("                  // collections that may grow unbounded
```

```
RESOURCE LAYER CHECKLIST:
[ ] LISTENER LEAK — Every .on() / addEventListener() has a matching .off() on cleanup/dispose
[ ] TIMER LEAK    — Every setInterval() has a matching clearInterval() on disconnect/dispose
[ ] MAP GROWTH    — Unbounded Maps/Sets have eviction, size caps, or cleared on lifecycle events
[ ] CONNECTION    — DB/WS/socket connections are closed on BOTH error paths AND disconnect paths
[ ] DISPOSE       — VS Code Disposables pushed to context.subscriptions (not fire-and-forget)
[ ] MEMORY REF    — No circular references preventing garbage collection
```

---

#### DOMAIN 6 — Error Layer (scope: `errors` or `*`)

**Pattern-First:** Grep for:
```
grep -rn "catch.*{"                  // all catch blocks — check each for swallowing
grep -rn "\.then("                   // promise chains — check each for paired .catch()
grep -rn "async.*=>\|async function" // async functions — check each for try/catch
```

```
ERROR LAYER CHECKLIST:
[ ] PROMISE       — Every async function / Promise chain has .catch() or try/catch
[ ] SWALLOWED     — catch blocks do NOT silently succeed (log-only catches that return normally = bug)
[ ] PROPAGATION   — Errors from deep layers surface through each layer to the user layer
[ ] TYPED         — Error types specific enough to distinguish failure modes
[ ] FEEDBACK      — Every caught error either retries, surfaces to user, or re-throws — never disappears
[ ] REJECTION     — No unhandled Promise rejections anywhere in the codebase
```

---

### 4. State Consistency Check (included in `*` and `data` runs)

For each piece of server-side state (each Map, each DB table, each in-memory object), verify:

```
STATE CONSISTENCY CHECKLIST:
[ ] WRITE PATHS — List every code path that writes to this state. Is each one reachable?
[ ] READ PATHS  — List every code path that reads from this state. Does it handle empty/null?
[ ] CLEAR PATHS — When is this state cleared? Is it cleared correctly on disconnect/delete?
[ ] SYNC PATHS  — Is this state reflected on the client after every write?
```

---

### 5. Compile Findings

Group all found bugs by the user action or domain they affect. For each bug write:

```
BUG-XX — [Short title]
Action affected: [user action from Step 2, or "N/A — domain bug"]
Domain: [ux-flow / data / logic / security / resources / errors]
Layer broken: L[N] → L[N+1] (UX handoff) OR [file:line] (domain bug)
Root cause: [one sentence]
Silent failure: YES/NO
User impact: CRITICAL / HIGH / MEDIUM / LOW
Fix direction: [one sentence on what needs to be added/changed]
Files: [list of files to change]
```

**Bug Classification by User Impact:**

| Class | Definition | Example |
|-------|-----------|---------|
| **CRITICAL** | User loses data or cannot use a core feature at all | Snapshot captures 0 files |
| **HIGH** | Feature is broken in a common scenario | New files not synced to room |
| **MEDIUM** | Feature works but degrades under certain conditions | Reconnect loop dies silently |
| **LOW** | Edge case, no data loss, workaround exists | Error message not descriptive |

Deduplicate: if two findings affect the same code change, merge them.

---

### 6. File the Bug Report

Once findings are compiled:

1. Count the bugs found. If ≥ 1 bug found, invoke `/bug-report [ProjectName] [AuditRound-Description]`
   to create the PLANNED file and ticket folders.

2. Populate the bug report file with:
   - All bugs in priority order (CRITICAL first)
   - Priority fix order table
   - Scope statement (which teams are affected)
   - Ticket list with team assignments (MON/SYN/ARC)

3. Present the full findings to Commander:
   - Summary: X bugs found, Y CRITICAL, Z HIGH
   - The user actions or systems that are currently broken
   - Which bug to fix first and why

4. **Update the project TechStack.** If the audit discovered new architectural facts — how a
   lifecycle event works, where state lives, what a helper actually does, call ordering between
   handlers — append those findings to the project's `Current TechStack.md`. Audits are also
   discovery passes. Findings that belong in TechStack: data flow patterns, event ordering,
   persistence behavior, state lifecycle. Do NOT duplicate what is already documented.

---

## Large Codebase Strategy

### Manifest-First Mode (auto-triggered when SOURCE_ROOT > ~50 files)

Do NOT read implementation files first. Instead:

1. **Read only index/registry files** — command registries, route files, service index exports.
   Build a complete feature map WITHOUT reading implementations.
2. **Score each feature by risk** — User-visible + multi-layer + high-frequency = HIGH risk.
   Internal utilities = LOW risk.
3. **Deep trace only high-risk features** — Full 8-layer trace for HIGH. Spot-check MEDIUM.
   Skip LOW unless a Pattern-First grep fires on it.
4. **Use Pattern-First for all domain passes** — Run grep patterns across the entire codebase
   first. Only read files that produce matches. Collapses a 200-file codebase to a 10–20 file
   reading list per domain.

### Pattern-First Principle (all codebase sizes)

Never read a file to look for bugs. Instead: **prove a bug class is present before spending
context reading the file.** The grep patterns in each domain pass are the mechanism.
Run greps first, read only matching files.

### Absent-Code Rule

**Pattern-First finds code that IS present. It cannot find code that is absent.**

For every critical state sync, flush, or persist operation, explicitly ask:
*"What call should exist here but doesn't?"* Specifically check:
- Before any state-destructive event: is there a call that commits in-flight data to persistence?
- Before any context switch: is in-flight data flushed to a layer that survives the switch?
- After any reconnect or re-activation: is there a call to re-hydrate state from persistence?

If the answer to any of these is "no call exists," that is a gap bug — even if no grep fires.

### Skepticism Rule

**Never trust that an existing helper is correct without reading it.**

When the trace finds an existing function that supposedly covers a case, do NOT mark that
case as handled. Read the function body. Verify:
1. What inputs does it read? (e.g. `textDocuments`, an in-memory Map, a DB query)
2. Are those inputs guaranteed to be populated at the moment of the call?
3. Does the call happen before or after any state-destructive events?
4. Does the function actually reach the intended persistence/broadcast layer?

Presence of a helper ≠ correctness. A helper that is called with empty inputs is the same
as no helper at all.

---

## Output Format

```
## /audit Results — [ProjectName] — [scope or "Full Audit (*)"]

### User Actions Traced: N
### Domains Run: [list]
### Bugs Found: N (X CRITICAL, Y HIGH, Z MEDIUM, W LOW)

#### Broken User Actions:
- [Action] → [Bug title] — [CRITICAL/HIGH/MEDIUM/LOW]

#### Domain Bug Summary:
- ux-flow:  N bugs
- data:     N bugs
- logic:    N bugs
- security: N bugs
- resources: N bugs
- errors:   N bugs

#### Silent Failures Found: N
- [Description]

#### Bug Report Filed: [file path]
#### Next Step: [recommended first fix]
```

---

## Rules

- **Never start with files.** Always start with user actions (Step 2) before opening any source file.
- **Trace before you judge.** Read the actual code path before classifying a bug. Do not assume.
- **Pattern-First for domain passes.** Grep for the anti-pattern before reading any file.
- **Absent-code is also a bug.** Pattern-First cannot find missing calls. For every critical sync or persist point, ask what call should exist but doesn't.
- **Check lifecycle boundaries.** Before tracing any feature, ask if any step causes a state-destructive event. If yes, trace pre- and post-event separately.
- **Be skeptical of existing helpers.** Read the helper body. Verify its inputs are populated at call time. Presence ≠ correctness.
- **Every gap is a bug.** A missing handler, missing broadcast, missing error message — all bugs.
- **Silent failures are HIGH severity minimum.** A user who gets no feedback on failure will blame the product.
- **Merge duplicates.** Two bugs with the same fix location should be one ticket.
- **File even partial findings.** If time or context runs short, file what was found rather than discarding.
- **Audits are discovery passes.** New architectural facts found during tracing belong in TechStack, not just in the bug report.
