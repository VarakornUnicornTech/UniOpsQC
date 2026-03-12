# §6 — Debugging Protocol

> **Policy reference file.** Loaded on-demand from `.claude/TeamDocument/1. Policies/`. Core rules live in CLAUDE.md.

**Applies to:** Any bug investigation in a pre-existing or complex subsystem where the root cause is not immediately obvious.

---

## The Instrument-First Rule

> **Never attempt a fix before you can see the system.** Add observability first. Fix second.

The correct order is always:
1. **Instrument** — add debug probes to the affected subsystem
2. **Observe** — reproduce the bug and read the output
3. **Hypothesize** — form a root cause theory from real data
4. **Fix** — implement the fix
5. **Verify** — confirm the fix with probes still in place, then remove them

Attempting Fix 1, Fix 2 blind (without observability) and only adding probes when stuck wastes investigation cycles. The probes must be the first code written, not the last resort.

---

## Debug Probe Standard

### Production Projects (RELEASE) — Remove-on-Fix

- Probes use the simplest available in-band mechanism (e.g., `print("[DBG] ...")` for GDScript, `console.error("[DBG] ...")` for server-side JS/TS, `chatLog.addSystem("[DBG] ...")` for TUI).
- All probe lines must be prefixed with `[DBG]` so they are trivially greppable.
- Probes are **temporary** — they are removed in the same commit that delivers the fix. Never ship `[DBG]` lines to production.
- The probe pattern and findings are documented in the BugFixes log under a `### Debug Instrumentation Session` heading before the ticket is closed.
- If the same subsystem is debugged again in the future, re-apply the same probe points (documented in the PreExisting TechStack file → Known Quirks / in the BugFixes log).

### INDEV Projects — Persistent Toggleable Probes (NEW — 12-03-2026)

> **Lesson learned:** SyncSpace v2 E2E testing required repeated probe insertion and removal across 5+ hotfixes in a single session. Each removal left the system blind for the next bug. INDEV code needs permanent observability.

**During INDEV, debug probes are PERSISTENT — they are NOT removed per-fix.** They remain in the codebase throughout the entire INDEV lifecycle and are stripped only when the project transitions to RELEASE.

**Rules:**
1. **All INDEV probes are gated behind a runtime toggle.** Extension: `[project].debugMode` setting. Server: `DEBUG_MODE` environment variable. The toggle defaults to OFF in production but can be flipped at any time during development.
2. **Probes use the `[DBG]` prefix** and are trivially greppable for the eventual RELEASE cleanup.
3. **Mandatory probe coverage for INDEV projects:**
   - All message handlers (inbound + outbound)
   - All route handlers (request + response)
   - All state transitions (join/leave, open/close, auth state changes)
   - All event listeners (document events, WS events, timer callbacks)
   - All error paths (catch blocks, validation failures, silent returns)
4. **Probes are NOT removed when a fix is committed.** They stay. The next bug investigation starts with full visibility instead of from scratch.
5. **RELEASE cleanup ticket:** When transitioning from INDEV to RELEASE, a dedicated cleanup ticket is created to strip all `[DBG]` lines and remove the toggle infrastructure. This is a single, auditable removal — not scattered across dozens of fix commits.
6. **Toggle implementation pattern:**
   ```typescript
   // Extension (setting)
   const debugMode = getConfiguration('[project]').get<boolean>('debugMode', false)
   if (debugMode) console.log('[DBG] ...')

   // Server (environment variable)
   const DEBUG = process.env.DEBUG_MODE === 'true'
   if (DEBUG) console.log('[DBG] ...')
   ```

**Standard probe points to instrument first (adjust per subsystem):**
1. The entry filter (e.g., session key check, run ID check) — log what is being dropped and why
2. The branching decision (e.g., which code path is taken) — log the condition value
3. The async operation result (e.g., what a deferred call or HTTP response returned)

---

## Cross-Layer Trace Rule (NEW — 12-03-2026)

> **Lesson learned:** SyncSpace hardened server auth but broke the extension because the fix was applied to one layer without tracing through all consumers.

**When any interface contract changes (API signature, message payload, auth requirement, expected state):**
1. **Trace all consumers.** Grep for every caller/sender/handler of that interface across ALL components (server, extension, dashboard, shared types).
2. **Verify each consumer.** For each consumer, confirm it still works with the new contract. If not, update it in the same change.
3. **No partial hardening.** A security fix that hardens the server without updating the client is not a fix — it's a new bug. Both sides of any interface change must ship together.

This rule applies to:
- Message payload changes (server handler + client sender)
- REST API contract changes (server route + client caller)
- Auth requirement additions (server middleware + client auth flow)
- Database schema changes (all code that reads/writes the affected table)

**Violation = CRITICAL bug.** A consumer that breaks silently because its interface changed is worse than the original vulnerability.

---

## Environment Verification Gate (NEW — 12-03-2026)

> **Lesson learned:** Debugging wasted hours because the running binary didn't match the source code, and required environment variables weren't set.

**Before any debugging session that involves a running process:**
1. **Source ↔ Binary match.** Verify the compiled/built output matches the current source. Check timestamps: `ls -la dist/` vs last build. If stale, rebuild first.
2. **Environment check.** Verify all required environment variables are set. Log them at startup (values redacted, presence confirmed).
3. **Single instance.** Verify only one instance of the process is running. Multiple instances = multiple bug sources.

If any of these fail, fix the environment before investigating the bug. Do not debug a stale binary.

---

## Rewrite Threshold Rule (NEW — 12-03-2026)

> **Lesson learned:** SyncSpace had 70+ bugs across 10 audits. Each fix wave introduced new bugs. Should have stopped fixing earlier.

**A subsystem should be flagged for rewrite (not more fixes) when ANY of these thresholds are hit:**
1. **Bug density:** More than 5 bugs found in a single file in one audit pass.
2. **Fix-creates-bug rate:** A fix for bug X introduces bug Y more than twice in the same subsystem.
3. **Layered-fix depth:** More than 3 rounds of fixes to the same module without resolving the core issue.
4. **God object:** Any single file exceeds 1000 lines with mixed concerns (e.g., auth + routing + state + broadcasting in one file).
5. **No test coverage:** The subsystem has zero automated tests and manual verification keeps finding regressions.

When flagged, the Technologist escalates to AM → Commander ท่านผู้บัญชาการ for a rewrite decision. Do not continue patching.

---

## Gap Bug Detection (NEW — 12-03-2026)

> **Lesson learned:** Most SyncSpace bugs were **missing code** (no handler, no error path, no sync call), not wrong code. Standard debugging (instrument → observe) doesn't find absent code.

**For every bug report that says "X doesn't work" or "nothing happens when Y":**
1. **Trace the expected path.** Before instrumenting, write down the exact sequence of calls that SHOULD happen (Layer 1 → Layer 2 → ... → Layer N).
2. **Find the gap.** Walk the sequence and find where the chain breaks. The bug is at the break point — not in any existing code, but in the absence of a connection.
3. **Check for silent returns.** Grep for early `return` statements with no error emission in handlers related to the feature. `if (!x) return;` without feedback is a gap bug.

Gap bugs cannot be found by instrumenting existing code. They are found by mapping what should exist and comparing it to what does exist.

---

## Downstream Consumer Check (NEW — 12-03-2026)

> **Lesson learned:** SyncSpace added JWT requirement to auth handler but never checked if the extension's auth sender could provide one. The fix broke the only client.

**Before merging any "hardening" or "security" fix:**
1. List every client/consumer that calls the hardened interface.
2. For each consumer: does it already satisfy the new requirement? If not, update it.
3. If the consumer is in a different component (e.g., extension vs. server), the fix MUST span both components.

**A server-side security fix with no client-side update is incomplete until verified that all clients already comply.**

---

## Regression Gate for Bug Fixes (event pipelines and state machines)

After any fix that touches an event pipeline, state machine, or async flow:
- A **manual end-to-end smoke test checklist** must be completed before the ticket is closed.
- The checklist is written into the ticket's Acceptance Criteria section.
- The Verification Scholar signs off on the checklist, not just unit test results.
- If the pipeline cannot be tested automatically (e.g., requires a live external event), the checklist must explicitly cover that scenario with manual steps.

---

## Side-Effect Scan (before removing or replacing any call)

Before removing, replacing, or refactoring any function call in a complex subsystem:
1. Grep for all callers of that function across the codebase.
2. For each caller: document what it was responsible for delivering.
3. Confirm the replacement covers all those responsibilities — or explicitly accept the regression and create a follow-up ticket.

This check must be documented in the PR/ticket notes. "I replaced X with Y" without a caller audit is a policy violation.

---

*Adopted from ClaudeTemplate — 11-03-2026. Adapted for RoundTable: AM/Commander naming.*
*Updated: 12-03-2026 — Fixed section number (was §8, should be §6). Added INDEV Persistent Toggleable Probes, Cross-Layer Trace, Environment Verification Gate, Rewrite Threshold, Gap Bug Detection, Downstream Consumer Check.*
