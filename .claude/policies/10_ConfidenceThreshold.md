# §10 — Pre-Implementation Confidence Threshold

> **Policy reference file.** Loaded on-demand from `.claude/policies/`. Core rules live in CLAUDE.md.

---

## Purpose

Prevent wrong-direction work before any code is written. Before implementing any ticket, run this 5-check scoring gate. If the score falls below threshold, stop and resolve the unknowns first.

---

## When to Run

| Ticket Complexity | Required |
|------------------|---------|
| Complex | **Mandatory** — must pass ≥90% before any file is written |
| Medium | **Recommended** — run before implementation begins |
| Simple | **Optional** — skip only if the change is truly trivial and self-contained |

---

## Gate: Check 0 — Git Sync (Pre-Gate, Unscored)

Before scoring, run `/git status`. Check:

- [ ] Local branch is up to date with origin
- [ ] Upstream (if tracked) is synced, or divergence is intentional and documented

**Binary gate:** If either check fails → **STOP.** Run `/git sync` to resolve before proceeding. A diverged repo means stale context — your implementation may duplicate or conflict with upstream changes.

This check is **not scored** — it is a prerequisite. Failure blocks all further checks regardless of score.

---

## Scored Checks (4 checks, 100% total weight)

Each check is binary — full credit or zero. No partial marks.

### Check 1 — No Duplicate Implementations (25%)

Search the codebase for existing similar functionality.

- **Tool:** Grep or Glob for function names, class names, endpoint paths, or key terms related to the ticket scope
- **Pass:** No existing implementation that serves the same purpose is found
- **Fail:** A similar implementation already exists → extend or refactor it instead of duplicating

**Evidence required:** Show the Grep/Glob command and its output.

---

### Check 2 — Architecture Compliance (25%)

Verify the planned implementation aligns with the established architecture.

- **Tool:** Re-read CLAUDE.md (already loaded at session start) + check `Current TechStack.md` for the project
- **Pass:** Implementation uses the existing tech stack and follows established patterns (naming, file structure, layer separation)
- **Fail:** Implementation would introduce a new dependency, violate layer boundaries, or require an architectural decision not yet made

**Evidence required:** State which pattern is being followed and where it is established in the codebase.

**Note:** If this check reveals an architectural decision is needed → escalate to MT (Architecture Decision Rule) before proceeding. Do not self-approve architectural choices.

---

### Check 3 — Official Docs Verified (20%)

For any library, API, or framework feature being used: verify expected behavior from official documentation.

- **Tool:** WebFetch the official docs, or read from cached TechStack file if already fetched this session
- **Pass:** Official docs reviewed; behavior confirmed as matching the implementation plan
- **Fail:** Relying on memory or assumptions about API behavior without verified documentation

**Caching rule:** Fetch once per session and cache findings to the relevant TechStack file or a session note. Do not re-fetch on every confidence check — read from cache on subsequent checks in the same session.

**Evidence required:** URL of docs reviewed, or reference to cache location and date last fetched.

---

### Check 4 — Root Cause / Requirement Clarity (30%)

Confirm the problem being solved is fully understood.

- **For bug fixes:** Root cause must be identified from logs, stack traces, or error messages — not inferred from symptoms alone. Use `/audit` to trace expected vs. actual call sequences if needed.
- **For new features:** All requirements must be unambiguous. No critical unknowns about what "done" looks like.
- **Pass:** Root cause is definitive (bug) OR requirements are complete and unambiguous (feature)
- **Fail:** Only symptoms are understood (bug) OR requirements have unresolved ambiguity (feature)

**Evidence required:** State the root cause with evidence, or list all acceptance criteria confirming each is unambiguous.

---

## Scoring Formula

```
Score = Check1 (0 or 0.25) + Check2 (0 or 0.25) + Check3 (0 or 0.20) + Check4 (0 or 0.30)
```

Maximum score: 1.00 (100%)

---

## Decision Tiers

| Score | Tier | Action |
|-------|------|--------|
| ≥ 0.90 (90%) | HIGH confidence | Proceed to implementation |
| 0.70 – 0.89 | MEDIUM confidence | Present alternatives to Commander. Ask clarifying questions. Do not implement until Commander confirms direction. |
| < 0.70 | LOW confidence | **STOP.** Request more context. Do not implement. File a blocker in OverseerReport if blocked on another team's information. |

---

## Output Format

```
## Pre-Implementation Confidence Check
**Ticket:** [ID] — [Title]
**Complexity:** Simple | Medium | Complex

### Gate: Git Sync
[x] Origin up to date
[x] Upstream synced (or: [ ] Diverged — reason: [why intentional])
Gate: PASS

### Check 1 — No Duplicate Implementations (25%)
[PASS] Grep for "[term]": no existing similar function found
Output: (0 matches)
Credit: 0.25

### Check 2 — Architecture Compliance (25%)
[PASS] Follows [pattern name] established in [file/module]
Credit: 0.25

### Check 3 — Official Docs Verified (20%)
[PASS] Docs fetched: [URL] — behavior confirmed
  OR [CACHED — verified DD-MM-YYYY at TechStack.md]
Credit: 0.20

### Check 4 — Root Cause / Requirement Clarity (30%)
[PASS] Root cause: [description with evidence]
  OR Requirements unambiguous: [confirmation]
Credit: 0.30

**Score: 1.00 (100%)**
**Tier: HIGH**
**Decision: Proceed to implementation.**
```

---

*Added: 16-03-2026*
