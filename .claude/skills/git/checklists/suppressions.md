# Review Suppressions — DO NOT Flag These

These patterns are known false positives. Filter them out before reporting.

## Type System Guarantees
- Redundant null checks where TypeScript strict mode guarantees non-null
- Optional chaining on properties that are always defined per interface
- Type assertions that match the actual runtime type

## Non-Logic Changes
- Threshold or configuration value changes (not logic changes)
- Comments-only changes (documentation updates)
- Import reordering or organization
- Whitespace and formatting changes
- Variable renaming without behavior change

## Test Patterns
- Mock implementations that intentionally simplify behavior
- Test fixtures with hardcoded values (that's their purpose)
- `any` type usage in test files for mock flexibility
- Intentionally empty catch blocks in test error-path assertions

## Framework Conventions
- Framework-required patterns (e.g., Express middleware signature with unused `next`)
- Decorator patterns that appear as dead code to static analysis
- Event handler registrations that appear as "unused" but are runtime-bound
