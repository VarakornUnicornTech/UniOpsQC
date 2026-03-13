---
description: "Pre-existing codebase scan protocol: L1/L2/L3 tiers, completeness checks"
---

# Codebase Scanning Rules
> Full standard: `TeamDocument/1. Policies/05_PreExisting_Codebase.md`

## Tiered Scan Protocol
Execute in order, never skip. Trigger: first contact with any pre-existing codebase.
PreExisting TechStack MUST be initialized BEFORE any implementation, modification, or ticket.

### L1 — Broad Scan (MANDATORY always first)
- Scan directory tree to depth 3
- Identify entry points (`Program.cs`, `main.py`, `index.ts`, `package.json`, `*.sln`, etc.)
- Identify package manifests and tech stack markers
- Classify codebase size:
  - **S** (< 50 files): L2 default, suggest L3
  - **M** (50–200 files): L2 default, L3 on Commander request
  - **L** (> 200 files): L2 default, flag scope before L3, explicit Commander approval required
- Output: subsystem list, tech stack detected, size classification
- **Action:** Initialize `Development/[ProjectName]/PreExisting TechStack/[ProjectName].md`
  immediately with L1 findings. Do not wait for L2.

### L2 — Key Files (default follow-up)
- Read entry points, config files, main service/controller files, routers per subsystem
- Map architecture per subsystem, data flow, key classes and functions
- Output: architecture diagram per subsystem, Key Functions / Classes table
- **Action:** Populate each subsystem section in PreExisting TechStack

### L3 — Full Scan (Commander authorization REQUIRED)
- Full code scan across entire codebase
- Gate: only proceed if Commander explicitly authorizes
- Must complete ALL 5 mandatory completeness checks before presenting to Commander
- **L3 is NOT complete until all 5 checks pass. Presenting incomplete L3 = protocol violation.**

## PreExisting TechStack File Format
Location: `Development/[ProjectName]/PreExisting TechStack/[ProjectName].md`
Check `.claude/ProjectEnvironment.md` for correct project name before creating.
One section per subsystem:
```
## [Subsystem Name]
**Source files:** `src/path/to/module.ts`, ...
**Scan tier completed:** L1 | L2 | L3
**Last reviewed:** DD-MM-YYYY
### Purpose — [2-4 sentences]
### Architecture / Data Flow — [ASCII diagram or numbered pipeline]
### Key Functions / Classes
| Name | File | What it does |
### Critical Invariants — [Things that must never change]
### Known Quirks / Gotchas — [Non-obvious behaviour]
```

## L3 Completeness Checks (all 5 mandatory)

### Check 1 — File Manifest
Raw file listing per scanned directory vs documented files:
```
| Directory | Files Found | Files Documented | Gap | Status |
```
- PASS only when Found = Documented. GAP > 0 = mandatory re-scan.
- Verification Scholar signs off before presenting to Commander.

### Check 2 — Service-URL Tracing
Every frontend API client traced to its backend handler:
```
| Service File | API Base URL | Resolves To |
```
- Every service file must have a row. Unexpected port/host = flag and investigate.

### Check 3 — Conductor Independence Cross-Check
After receiving subagent L3 output, Conductor MUST independently verify file counts
per subsystem using Glob/Bash — separate from subagent's output.
- Conductor may NOT delegate this to the same subagent that produced the scan.
- Any count mismatch = re-scan affected subsystem only.

### Check 4 — Cross-Layer Subsystem Matrix
Extract subsystem registry from ALL layers (DB, App, Frontend, Infra):
- DB: grep CREATE SCHEMA/TABLE/FUNCTION, group by schema
- App: glob *Repository*, *Controller*, *Service*, *Router*
- Frontend: glob pages/**, *api*
- Infra: read docker-compose, glob *.tf

Build matrix documenting every subsystem at every layer:
```
| Subsystem | DB Schema | DB SPs | App Repos | App Controllers | App Services | Frontend | Infra | Status |
```
- Subsystem at one layer but missing at another = must be explicitly documented
  (intentional vs oversight). Silent omission = failure.
- When comparing two codebases: build matrices for both, present delta.
- Conductor owns this check — may NOT delegate to scan subagent.

### Check 5 — External Dependency & Hidden Service Audit (6 sub-audits)
All 6 mandatory. If a sub-audit finds nothing, state "None found" — never silently omit.

**5a. External Service Audit** — Scan all config files for URLs, API keys, connection strings.
Produce External Dependency Registry: `| Service | Type | Reference Location | URL | Credentials | Status |`
Flag plaintext credentials. Note environment-specific variants.

**5b. Background Worker Audit** — Scan for IHostedService, BackgroundService, Worker, Job, Scheduler.
Produce Background Services Registry: `| Service | Type | Registered In | What It Does | Triggers |`

**5c. Middleware Pipeline Audit** — Scan for app.Use*(), app.Map*() in order.
Produce Middleware Pipeline Registry: `| Order | Middleware | File | What It Does | External Deps |`
Pipeline order matters — document exact sequence. Include hub mappings.

**5d. Dependency Manifest Audit** — Scan .csproj/package.json/requirements.txt for
capability-implying packages (SemanticKernel, SignalR, Hangfire, MassTransit, Redis,
Serilog, IdentityServer, langchain, Stripe, etc.).
Produce: `| Package | Found In | Implied Capability | Documented? | Actually Used? |`
Grep for imports to verify usage — flag dead dependencies.

**5e. Inter-Service Communication Audit** — Scan for HttpClient, gRPC, message bus,
hardcoded localhost URLs between backend services (not frontend→backend).
Produce: `| Caller | Target | Protocol | URL/Channel | Purpose |`
Hardcoded localhost URLs = flag for deployment breakage.

**5f. Environment Configuration Audit** — Compare all environment variants
(dev/test/prod config files). Produce Environment Topology Map:
`| Setting | Development | Testing | Production | Notes |`
Flag security-sensitive settings relaxed in dev (CORS AllowAll, debug endpoints, plaintext secrets).

## Global Rules
- PreExisting TechStack initialized at FIRST CONTACT — not first modification
- PreExisting TechStack is living document — never delete sections, only update
- Technologist owns this document for their team's work
- Each section shows current scan tier (L1/L2/L3) so readers know documentation depth
- L3 always requires explicit Commander authorization — no team self-authorizes
- Bug fix reveals new architecture knowledge → add to subsystem's Known Quirks before ticket closes
- This document is the FIRST thing to consult before filing any bug report or change
- After `/compact` or session resume: re-check PreExisting TechStack file exists.
  Consult ProjectEnvironment.md for correct path. If missing and pre-existing codebase present,
  create immediately before any other work.
