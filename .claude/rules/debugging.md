---
description: "Debugging protocol: instrument-first rule, probe management, cross-layer tracing, gap bug detection"
paths:
  - "**/*.ts"
  - "**/*.js"
  - "**/*.py"
  - "**/*.go"
  - "**/*.rs"
  - "**/*.java"
---

# Debugging Rules
> Full standard: `TeamDocument/1. Policies/06_Debugging_Protocol.md`

## Instrument-First Rule (NON-NEGOTIABLE)
Never attempt a fix before you can see the system. Add observability first.
Order: Instrument → Observe → Hypothesize → Fix → Verify.
Attempting fixes blind wastes investigation cycles. Probes are the FIRST code written.

## RELEASE Projects — Remove-on-Fix Probes
- All probe lines prefixed `[DBG]` (trivially greppable)
- Probes removed in same commit as the fix — never ship `[DBG]` to production
- Probe pattern and findings documented in BugFixes log under
  `### Debug Instrumentation Session` heading before ticket closes
- If same subsystem debugged again: re-apply documented probe points
  (from PreExisting TechStack → Known Quirks or BugFixes log)

## INDEV Projects — Persistent Toggleable Probes
- Debug probes are PERSISTENT — NOT removed per-fix
- Gated behind runtime toggle: Extension `[project].debugMode` setting,
  Server `DEBUG_MODE` environment variable. Defaults to OFF in production.
- Toggle pattern:
  ```
  // Extension: getConfiguration('[project]').get<boolean>('debugMode', false)
  // Server: process.env.DEBUG_MODE === 'true'
  ```
- Mandatory probe coverage:
  - All message handlers (inbound + outbound)
  - All route handlers (request + response)
  - All state transitions (join/leave, open/close, auth state changes)
  - All event listeners (document events, WS events, timer callbacks)
  - All error paths (catch blocks, validation failures, silent returns)
- Probes NOT removed when fix committed — they stay for next investigation
- RELEASE cleanup: dedicated ticket strips all `[DBG]` lines + toggle infra

## Standard Probe Points (instrument first, adjust per subsystem)
1. Entry filter (e.g., session key check) — log what is being dropped and why
2. Branching decision (which code path taken) — log the condition value
3. Async operation result (deferred call / HTTP response) — log what returned

## Cross-Layer Trace Rule
When any interface contract changes (API signature, message payload, auth, state):
1. Trace ALL consumers — grep every caller/sender/handler across ALL components
2. Verify each consumer still works with new contract — update if not
3. No partial hardening — both sides of any interface change ship together
Applies to: message payloads, REST API contracts, auth requirements, DB schema changes.
Violation = CRITICAL bug (consumer breaking silently is worse than original vulnerability).

## Downstream Consumer Check
Before merging any "hardening" or "security" fix:
1. List every client/consumer that calls the hardened interface
2. For each consumer: does it already satisfy the new requirement? If not, update it
3. If consumer is in a different component (e.g., extension vs. server), fix MUST span both
A server-side security fix with no client-side update is incomplete until all clients verified.

## Gap Bug Detection
For every "X doesn't work" or "nothing happens when Y":
1. Trace expected path — write exact sequence of calls that SHOULD happen
2. Find gap — walk sequence, find where chain breaks
3. Check for silent returns — grep for early `return` in handlers with no error emission
   `if (!x) return;` without feedback = gap bug
Gap bugs = missing code, not wrong code. Cannot be found by instrumenting existing code.
Found by mapping what should exist vs what does exist.

## Side-Effect Scan (before removing or replacing any call)
Before removing/replacing/refactoring any function call in a complex subsystem:
1. Grep all callers of that function across the codebase
2. For each caller: document what it was responsible for delivering
3. Confirm replacement covers all responsibilities — or create follow-up ticket
"I replaced X with Y" without a caller audit is a policy violation.
Must be documented in PR/ticket notes.

## Regression Gate for Bug Fixes (event pipelines and state machines)
After any fix touching an event pipeline, state machine, or async flow:
- Manual E2E smoke test checklist MUST be completed before ticket closes
- Checklist written into ticket's Acceptance Criteria section
- Verification Scholar signs off on the checklist — not just unit test results
- If pipeline cannot be tested automatically, checklist covers manual steps explicitly

## Environment Verification Gate
Before any debugging session involving a running process:
1. Source ↔ Binary match — verify compiled output matches source (check timestamps)
2. Environment check — verify all required env vars are set (log presence, redact values)
3. Single instance — verify only one instance running (multiple = multiple bug sources)
Fix environment before investigating bug. Do not debug a stale binary.

## Rewrite Threshold
Flag for rewrite (not more fixes) when ANY hit:
1. 5+ bugs in single file in one audit pass
2. Fix-creates-bug rate exceeds 2x in same subsystem
3. 3+ rounds of fixes without resolving core issue
4. Single file exceeds 1000 lines with mixed concerns
5. Zero automated tests and manual verification keeps finding regressions
When flagged: Technologist escalates to AM → Commander for rewrite decision. Stop patching.
