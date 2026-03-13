---
description: "Testing requirements: unit tests, integration tests, regression tests, verification sign-off"
paths:
  - "**/*.test.*"
  - "**/*.spec.*"
  - "**/tests/**"
  - "**/test/**"
  - "**/__tests__/**"
---

# Testing Rules

## Unit Tests Required
Every new function, method, and endpoint must have unit tests.
No ticket marked Complete without passing tests.

## Integration Tests for Cross-Module
Cross-module interactions require integration tests.
Verification Scholar signs off on test results before OverseerReport is filed.

## Hotfix Regression Test (MANDATORY)
Every bug fix includes a test case reproducing the original bug.
Test must fail before fix, pass after. Regression tests are permanent — never deleted.
Location: `Development/09_TestCase/_regression/`

## Test Documentation
`09_TestCase/` is mandatory in every project Development directory.
- Test plans and documentation stored here
- Executable test code lives in source tree (not in Development)
- `_regression/` subfolder for permanent regression tests
- Verification Scholar owns and maintains the test index

## Living Documentation
`Current TechStack.md` updated in the same session as code changes.
Verification Scholar checks currency as sign-off requirement.
**Missing documentation entry = ticket NOT Complete.** This is a hard blocker.

## Quality Standards
- All code commented for clarity
- Design systems use configurable values (CSS variables, config entries, constants) — no magic numbers
- `Current TechStack.md` is a living document — update whenever new classes, methods, or functions created
