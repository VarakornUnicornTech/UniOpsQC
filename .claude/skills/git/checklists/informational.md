# Review Checklist — Pass 2: INFORMATIONAL

These patterns SHOULD be flagged. Findings are advisory — merge at discretion.

## Magic Numbers
- Numeric literals without named constants
- Hardcoded strings that should be configuration values
- Timeouts/thresholds without documentation

## Dead Code
- Unreachable code after unconditional return/throw
- Unused imports or variables
- Commented-out code blocks (should be deleted, not commented)

## Missing Test Coverage
- New functions/methods without corresponding test
- New API endpoints without integration test
- Changed business logic without updated test assertions

## Type Coercion at Boundaries
- Loose equality (`==` instead of `===`) at system boundaries
- Missing type narrowing when receiving external data
- Implicit type conversions in API response handling

## Conditional Side Effects
- Mutations inside conditional branches (hard to trace state changes)
- Side effects in ternary operators
- Assignment inside `if` conditions

## Performance
- N+1 query patterns (loop of individual queries instead of batch)
- Unbounded loops without safety limits
- Synchronous operations that should be async
- Missing pagination on list endpoints

## Inconsistent Patterns
- Error handling style differs from rest of codebase
- Naming conventions broken (camelCase vs snake_case mix)
- Different approaches to same problem in adjacent code
