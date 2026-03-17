# §11 — Self-Check Protocol (Post-Implementation)

> **Policy reference file.** Loaded on-demand from `.claude/policies/`. Core rules live in CLAUDE.md.

---

## Purpose

Detect hallucinations and unverified claims **after** implementation, before a ticket is marked Complete. This is the Verification Scholar's mandatory final gate on every ticket.

---

## When to Run

**Mandatory for every ticket before marking `[x] Complete`.** No exceptions.

The **Verification Scholar runs this protocol** — not the Technologist. The same person who implemented the ticket cannot sign off on it.

---

## The 4 Questions

For each question, evidence must be **shown** — not claimed.

---

### Q1 — Are tests ACTUALLY passing?

Show real test output. Reporting "tests pass" without showing the output is a hallucination red flag.

- **Required:** Paste actual test runner output (or explicitly state no tests exist for this ticket and explain why, with Commander sign-off recorded)
- **PASS:** Output shows tests passing with 0 failures
- **FAIL:** Output is missing, shows failures, or contains unexplained warnings

---

### Q2 — Are ALL acceptance criteria met?

List every acceptance criterion from the ticket file. Check each one individually.

- **Required:** Quote each criterion verbatim from the ticket. State PASS/FAIL for each with evidence.
- Do NOT check a criterion based on "it should work" reasoning — evidence only.
- **PASS:** Every criterion has a corresponding evidence artifact (test, file, output, screenshot)
- **FAIL:** Any criterion is unverified, assumed, or checked without evidence

---

### Q3 — Are there any unverified assumptions?

List any technical choices made during implementation that were not verified against official documentation or established codebase patterns.

- For each assumption: show the doc, file, or evidence that validates it.
- "I believe this works" = unverified assumption = **FAIL**
- **PASS:** All choices are grounded in evidence (docs, source code, tests)
- **FAIL:** Any "should work", "probably works", or "I assume" language in the implementation notes

---

### Q4 — Is there concrete evidence?

Confirm all of the following:

- [ ] Test results exist on disk (not just described in the response)
- [ ] Code changes are written to files (not planned or described in response)
- [ ] Errors encountered were addressed (not silently ignored)
- [ ] No warnings were dismissed without explanation

- **PASS:** All items above are confirmed
- **FAIL:** Any item is missing, or described rather than demonstrated

---

## 7 Hallucination Red Flags

When reviewing an implementation, raise an immediate blocker if any of these are present:

| # | Red Flag | Example |
|---|----------|---------|
| 1 | "Tests pass" without showing output | "All 12 tests pass." — no output attached |
| 2 | "Everything works" without evidence | "The feature is working correctly." |
| 3 | "Implementation complete" with failing tests | Ticket marked Complete; test run shows 2 failures |
| 4 | Error messages skipped in reports | Only happy path described; error cases not shown |
| 5 | Warnings treated as acceptable | "There are some TypeScript warnings but they're not important." |
| 6 | Failures hidden or minimized | Output truncated; only passing tests shown |
| 7 | Probabilistic language | "Should work", "probably works", "might work", "I believe", "I assume" |

If any red flag is present → **do not mark the ticket Complete.** Return to Technologist with specific identification of the flag and what evidence is needed.

---

## Protocol Depth by Complexity

| Complexity | Minimum Requirements |
|-----------|---------------------|
| Complex | All 4 questions with full evidence artifacts |
| Medium | All 4 questions; evidence can be brief |
| Simple | Q1 (test output) + Q4 (concrete evidence) at minimum |

---

## Output Format

```
## Self-Check Protocol — [Ticket ID] — [Title]

### Q1 — Tests Passing?
[PASS] Test output:
```
[paste actual test runner output here]
```

### Q2 — Acceptance Criteria Met?
- [x] Criterion 1 — Evidence: [test name / file / output reference]
- [x] Criterion 2 — Evidence: [test name / file / output reference]

### Q3 — Unverified Assumptions?
[PASS] No assumptions — all choices grounded in evidence.
  OR
[FAIL] Assumption: "[description]" → evidence needed: [what to verify]

### Q4 — Concrete Evidence?
- [x] Test results on disk: [path or output above]
- [x] Code changes written: [list of files modified]
- [x] Errors addressed: [evidence or "No errors encountered"]
- [x] No unexplained warnings: [evidence or "No warnings"]

**Self-Check: PASS** → Ticket may be marked [x] Complete.
  OR
**Self-Check: FAIL** → [List exactly what must be resolved before Complete.]
```

---

*Added: 16-03-2026*
