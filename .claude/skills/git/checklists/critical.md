# Review Checklist — Pass 1: CRITICAL (Blocking)

These patterns MUST be flagged. Any finding blocks merge until resolved.

## SQL Injection
- Raw string concatenation in SQL queries
- Template literals with user input in query strings
- Missing parameterized queries where user input touches SQL

## Race Conditions
- Shared mutable state accessed without locks/mutexes
- Read-modify-write without atomicity guarantees
- Concurrent access to maps/collections without synchronization

## Cross-Site Scripting (XSS)
- Unescaped user input rendered in HTML
- `innerHTML` / `dangerouslySetInnerHTML` with user data
- Missing output encoding at rendering boundary

## Authentication Bypass
- Protected routes missing auth middleware/guards
- Authorization checks that can be skipped via parameter manipulation
- Session/token validation gaps

## LLM Trust Boundary
- User input passed directly into system prompts
- Missing sanitization between user content and AI instructions
- Tool call parameters derived from untrusted input without validation

## Silent Failures
- `catch` blocks that swallow errors (empty catch, catch-and-return-null)
- Error handlers that don't log, don't notify, don't re-throw
- Promise chains with no `.catch()` or `try/catch` around `await`

## Resource Leaks
- Event listeners added without corresponding removal
- Timers/intervals set without cleanup on dispose/unmount
- Database connections opened without close in finally block
- File handles not closed after use

## Unvalidated External Input
- External API responses used without validation
- User input passed to file system operations without sanitization
- WebSocket messages processed without schema validation
