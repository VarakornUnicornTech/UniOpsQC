# §5 — Pre-Existing Codebase Standards

> **Policy reference file.** Loaded on-demand from `.claude/TeamDocument/1. Policies/`. Core rules live in CLAUDE.md.

**Applies to:** ALL teams (Overseer, Monolith, Syndicate, Arcade, Cipher) — any project that has a pre-existing codebase, regardless of whether the work is a fork, modification, rebuild, or investigation. There are no exceptions.

---

## 5a. Tiered Scan Protocol (MANDATORY — Global)

**Trigger:** `Development/[ProjectName]/PreExisting TechStack/[ProjectName].md` MUST be initialized at the **start of any Discovery or Scan session** — before any implementation, before any modification, before any ticket is opened. The document is NOT deferred until "first touch". First contact with the codebase IS the trigger.

**This applies to every team, every session, every project with pre-existing code.**

---

**Scan Tiers — Execute in order, never skip a tier:**

**L1 — Broad Scan (MANDATORY — always first)**
- Scan directory tree to depth 3
- Identify entry point files (`Program.cs`, `main.py`, `index.ts`, `package.json`, `*.sln`, `docker-compose.yml`, etc.)
- Identify package manifests and tech stack markers
- Classify codebase size (see Size Gate below)
- Output: subsystem list, tech stack detected, size classification (S / M / L)
- **Action:** Initialize `Development/[ProjectName]/PreExisting TechStack/[ProjectName].md` immediately with L1 findings. Do not wait for L2 or L3.

**L2 — Specific Scan (default follow-up after L1)**
- Read key files per subsystem: entry points, config files, main service/controller files, router files
- Map architecture per subsystem, data flow, key classes and functions
- Output: architecture diagram per subsystem, Key Functions / Classes table populated
- **Action:** Populate each subsystem section in `Development/[ProjectName]/PreExisting TechStack/[ProjectName].md` as sections are scanned.

**L3 — Full Code Scan (Commander authorization required)**
- Read all source files in depth across the entire codebase
- Gate: only proceed if **Commander ท่านผู้บัญชาการ explicitly authorizes** — regardless of codebase size
- If L3 is requested on a Large (L) codebase, flag the scope to Commander before starting
- **Action:** Complete all subsystem sections in `Development/[ProjectName]/PreExisting TechStack/[ProjectName].md` to full depth.
- **Verification required:** After scan, Conductor MUST complete all five checks in §7b (File Manifest, Service-URL Tracing, Conductor Cross-Check, Cross-Layer Subsystem Tracing, External Dependency & Hidden Service Audit) before the L3 is considered complete and before any output is presented to Commander ท่านผู้บัญชาการ.

---

**Size Gate (used to inform Commander — does NOT block any scan tier):**

| Class | Source File Count | Default Recommendation |
|-------|------------------|----------------------|
| **S — Small** | < 50 source files | L2 default, suggest L3 to Commander |
| **M — Medium** | 50–200 source files | L2 default, L3 available on Commander request |
| **L — Large** | > 200 source files | L2 default, flag scope before L3, L3 requires Commander explicit approval |

> Size classification is reported to Commander after L1. Commander decides whether to authorize L3.

---

**File location and naming:**
- Folder: `Development/[ProjectName]/PreExisting TechStack/` (relative to project root — see Project Structure Mode for path rules)
- File name: `[ProjectName].md` — use the actual project name (e.g., `Unicorn.BOS.md`, `MyApp.md`)
- Full path example: `Development/UNI_Refactor/PreExisting TechStack/Unicorn.BOS-A-PROJECT.md`
- Check `.claude/ProjectEnvironment.md → ACTIVE_PROJECTS` to confirm the correct `[ProjectName]` subfolder before creating the file

**File section format (one section per subsystem):**

```markdown
## [Subsystem Name]
**Source files:** `src/path/to/module.ts`, `src/path/to/other.ts`
**Scan tier completed:** L1 | L2 | L3
**Last reviewed:** DD-MM-YYYY

### Purpose
[What this subsystem does — 2–4 sentences.]

### Architecture / Data Flow
[ASCII diagram or numbered pipeline describing how data moves through the subsystem.]

### Key Functions / Classes
| Name | File | What it does |
|------|------|-------------|
| `functionName()` | `file.ts:L42` | [brief description] |

### Critical Invariants
1. [Thing that must never change and why]
2. [Another invariant]

### Known Quirks / Gotchas
- [Non-obvious behaviour, timing races, caching gotchas, etc.]
```

---

**Global Rules — apply to all teams without exception:**
- The PreExisting TechStack file (`Development/[ProjectName]/PreExisting TechStack/[ProjectName].md`) is initialized at **first contact with the codebase** — not at first modification.
- The PreExisting TechStack file is a **living document** — never delete sections, only update them.
- The Technologist (MT/SC/AX/GL) owns this document for their team's work.
- Each section must show its current scan tier (`L1 / L2 / L3`) so any reader knows how deep the documentation goes.
- L3 (Full Code Scan) always requires **explicit Commander ท่านผู้บัญชาการ authorization** — no team may self-authorize a full scan.
- If a bug fix reveals new architecture knowledge (e.g., a compile cache gotcha, a buffer-before-suppress pattern), add it to the relevant subsystem's "Known Quirks" before the ticket is closed.
- This document is the **first thing to consult** before filing any bug report or implementing any change in a known subsystem.
- After `/compact` or session resume: re-check `Development/[ProjectName]/PreExisting TechStack/[ProjectName].md` exists. Consult `.claude/ProjectEnvironment.md` for the correct project name and path. If the file does not exist and a pre-existing codebase is present, create it immediately before any other work.

---

## 5b. L3 Completeness Verification Protocol (MANDATORY — every L3 scan)

**Applies to:** Every team, every L3 scan, every project — no exceptions.

**Root cause of this rule:** L3 scans delegated to subagents produce prose summaries that may omit individual files even when the correct directories were scanned. A summary that touches the right folders is not the same as a summary that enumerates every file in those folders. This protocol closes that gap.

**All five checks below are mandatory. L3 is not complete until all five pass. Presenting L3 output to Commander ท่านผู้บัญชาการ before all five checks pass is a protocol violation.**

---

**Check 1 — File Manifest (Completeness Verification)**

After receiving the L3 scan output, the Conductor must run a raw file listing on every scanned subsystem directory and produce a File Manifest as a mandatory section in the PreExisting TechStack file:

```markdown
## L3 File Manifest — Completeness Verification
| Directory | Files Found | Files Documented | Gap | Status |
|-----------|-------------|-----------------|-----|--------|
| src/Client/src/pages/settings/ | 8 .tsx | 8 .tsx | 0 | ✓ PASS |
| src/Observer/Controllers/      | 5 .cs  | 5 .cs  | 0 | ✓ PASS |
| src/Brain/api/routers/         | 12 .py | 12 .py | 0 | ✓ PASS |
```

**Rules:**
- A row shows **PASS** only when Files Found = Files Documented.
- Any **GAP > 0** is a mandatory re-scan trigger for that subsystem — not optional.
- The Manifest must be signed off by the Verification Scholar before the L3 is presented to Commander ท่านผู้บัญชาการ.
- L3 is not complete until every row shows PASS.

---

**Check 2 — Service-URL Tracing**

For any project with a frontend layer, every API client/service file (`*.service.ts`, `*_service.py`, or equivalent) must be read during L3 and its API base URL explicitly traced to the backend service that handles it. The result must be documented in the PreExisting TechStack file:

```markdown
## Frontend → Backend Service Map
| Service File          | API Base URL                         | Resolves To                       |
|-----------------------|--------------------------------------|-----------------------------------|
| aiAgent.service.ts    | localhost:5200/api/ai-agents         | Observer: AiAgentController       |
| knowledge.service.ts  | localhost:8000/api/v1/knowledge      | Brain: knowledge router           |
| rag.service.ts        | localhost:8000/api/v1/rag            | Brain: rag router                 |
```

**Rules:**
- Every service file must have a traced row — no service file left without a mapping.
- Any service file pointing to an unexpected port or host must be flagged and investigated before the L3 is filed.
- This prevents architectural misidentification where a feature appears to belong to one service but its API lives in another.

---

**Check 3 — Conductor Independence Cross-Check**

When L3 is performed by a subagent or delegated tool, the Conductor must independently run a raw file-count check per subsystem using Glob or Bash — separate from the subagent's output — before accepting the scan as complete:

```
After receiving any subagent L3 output, Conductor MUST independently run:
  Glob("**/*.tsx", path="src/[Project]/src/pages/")    → compare count to subagent output
  Glob("**/*.cs",  path="src/[Project]/Controllers/")  → compare count to subagent output
  Glob("**/*.py",  path="src/[Project]/api/routers/")  → compare count to subagent output

If count does not match → flag gap → re-scan that subsystem → do not present output to Commander until resolved.
```

**Rules:**
- The Conductor may NOT delegate this cross-check to the same subagent that produced the original scan.
- The cross-check is mandatory regardless of how comprehensive the subagent's output appears.
- If any count mismatches, re-scan only the affected subsystem — not the entire codebase.

---

**Check 4 — Cross-Layer Subsystem Tracing (MANDATORY)**

**Root cause:** Checks 1–3 verify files are counted and service URLs are traced, but they operate within each layer independently. They do not verify that subsystems discovered in one layer are accounted for in all other layers. A database schema can define an entire subsystem (tables, SPs, RLS) that has zero application code — and if the scan only enumerates application-layer files, the database subsystem is invisible.

**This is not limited to SQL.** The same failure pattern applies to:
- **Database scripts** containing schemas/tables/SPs that have no matching repository, controller, or service in application code
- **Application code** (controllers, services, repositories) that reference database objects, external APIs, or subsystems not documented elsewhere
- **Frontend routes/pages** that call API endpoints with no documented backend handler
- **Config/infrastructure files** (Docker Compose services, Terraform resources, CI/CD pipelines) that define services not documented as subsystems
- **Dependency manifests** (package.json, .csproj, requirements.txt) that pull in major frameworks implying undocumented capabilities

**Procedure — executed by the Conductor after Checks 1–3 pass:**

**Step 1: Extract the Subsystem Registry from ALL layers.**

Scan every layer of the codebase and extract a master list of distinct subsystems/namespaces/domains. A "subsystem" is any self-contained domain with its own data, logic, or interface:

```
Layer: Database (SQL scripts, migrations, seed data)
  → Grep("CREATE SCHEMA", path="[sql-directory]")
  → Grep("CREATE TABLE", path="[sql-directory]")  → group by schema
  → Grep("CREATE.*FUNCTION", path="[sql-directory]")  → group by schema
  Result: list of database schemas with table counts and SP counts

Layer: Application Code (C#, Python, TypeScript backend)
  → Glob("**/*Repository*", path="src/")  → which domains have repositories?
  → Glob("**/*Controller*", path="src/")  → which domains have controllers?
  → Glob("**/*Service*", path="src/")  → which domains have services?
  → Glob("**/*Router*", path="src/")  → which domains have routers?
  Result: list of application-layer domains with file counts

Layer: Frontend (React, Vue, Angular, etc.)
  → Glob("**/pages/**", path="src/[client]/")  → which page groups exist?
  → Glob("**/*api*", path="src/[client]/")  → which API clients exist?
  Result: list of frontend domains

Layer: Infrastructure (Docker, Terraform, CI/CD)
  → Read docker-compose.yml  → which services are defined?
  → Glob("**/*.tf", path="infra/")  → which resources exist?
  Result: list of infrastructure services
```

**Step 2: Build the Cross-Layer Matrix.**

Produce a matrix documenting every subsystem found at ANY layer and whether it has coverage at each other layer:

```markdown
## Cross-Layer Subsystem Matrix
| Subsystem | DB Schema | DB SPs | App Repositories | App Controllers | App Services | Frontend UI | Infra | Status |
|-----------|-----------|--------|-----------------|----------------|-------------|-------------|-------|--------|
| Auth      | auth.*    | 5 SPs  | AuthRepository  | AuthController + 8 | JwtService + 4 | LoginPage + 11 | — | FULL |
| AI/Agents | ai.*      | 1 SP   | **NONE**        | **NONE**       | **NONE**     | **NONE**    | — | DB-ONLY |
| Workspace | workspace.* | 1 SP | **NONE**        | **NONE**       | **NONE**     | **NONE**    | — | DB-ONLY |
| Knowledge | knowledge.* | 1 SP | **NONE**        | **NONE**       | **NONE**     | **NONE**    | — | DB-ONLY |
| Comms     | comms.*   | 1 SP   | NotifRepo       | NotifController | SignalRNotifier | — | — | PARTIAL |
```

**Step 3: Flag and document every gap.**

Any subsystem that exists at one layer but NOT at another must be explicitly documented in the PreExisting TechStack file with:
- What exists (which layer, what objects)
- What does NOT exist (which layers are missing)
- Whether this is intentional (ported DB only, planned for future) or an oversight

**Step 4: Cross-reference against comparison targets.**

When scanning two related codebases (e.g., original + refactor), the matrix must be built for BOTH projects and compared side-by-side. Every subsystem present in the original must be accounted for in the refactor — either as "ported", "partially ported (specify which layers)", or "not ported (archived/dropped)".

**Rules:**
- This check applies to EVERY L3 scan, not just multi-codebase comparisons.
- A subsystem documented only at one layer (e.g., "DB complete, app nonexistent") is not a failure — but it MUST be explicitly stated. The failure is when it is not mentioned at all.
- The Cross-Layer Matrix is a mandatory section in the PreExisting TechStack file for every L3 scan.
- The Conductor owns this check. It may NOT be delegated to the scan subagent.
- When comparing two codebases, the Conductor must build matrices for both and present a delta showing what moved, what was added, what was dropped, and what is partially ported.
- "47 .sql files" or "[N] config files" is never acceptable as a final documentation state for a bundled-definition directory. The content inside those files must be decomposed into the matrix.

---

**Check 5 — External Dependency & Hidden Service Audit (MANDATORY)**

**Root cause:** Checks 1–4 trace subsystems that declare themselves through code structure (files, schemas, controllers, routes). But many critical system components hide inside configuration files, dependency manifests, entry-point registrations, and environment variables — they have no dedicated directory, no schema, and no controller. They are invisible to structural scans. This check forces the Conductor to read the files where hidden dependencies live and extract every external integration, background service, and capability-implying package.

**This check has six mandatory sub-audits. All six must be completed.**

---

**5a. External Service & Integration Audit**

Scan all configuration files for outbound URLs, API keys, connection strings, and service references that indicate external dependencies the system relies on.

```
Files to scan:
  → appsettings.json, appsettings.*.json (all environment variants)
  → .env, .env.*, docker.env
  → launchSettings.json
  → docker-compose.yml, docker-compose.*.yml
  → Any *config*.json, *config*.yaml, *config*.toml at project root

Extract and document:
  → Every URL, hostname, port, or connection string
  → Every API key reference or secret vault path
  → Every named external service (SendGrid, Twilio, MACROKIOSK, Cloudflare, Azure, AWS, etc.)
```

Produce an **External Dependency Registry**:

```markdown
## External Dependency Registry
| Service | Type | Reference Location | URL/Endpoint | Credentials | Status |
|---------|------|-------------------|-------------|-------------|--------|
| SendGrid | Email provider | appsettings.json:SendGrid | api.sendgrid.com | API key in config | ACTIVE |
| MACROKIOSK | SMS gateway | appsettings.json:Sms | HTTP POST endpoint | Credentials in config | ACTIVE |
| Cloudflare Tunnel | Reverse proxy | cloudflared config | vbosauth.aith123.com | Tunnel token | ACTIVE |
| PostgreSQL | Database | docker-compose.yml | localhost:5432 | .env credentials | ACTIVE |
```

**Rules:**
- Every external URL found in config must have a row — no silent dependencies.
- Credentials found in plaintext must be flagged as a security concern.
- Environment-specific variants (dev vs prod vs test) must be noted — different environments may talk to different services.
- Webhook/callback URLs where external services call INTO the app must also be documented (search for webhook, callback, notify URLs in configs and code).

---

**5b. Background Worker & Hosted Service Audit**

Scan entry-point files for registered background services, hosted workers, scheduled tasks, and any non-HTTP processing that runs without a controller or route.

```
Files to scan:
  → Program.cs / Startup.cs / Host configuration files
  → Any file matching *Worker*, *HostedService*, *BackgroundService*, *Job*, *Scheduler*
  → Crontab files, task scheduler configs
  → Python: main.py, __main__.py, celery configs, APScheduler configs

Extract:
  → Grep("AddHostedService|IHostedService|BackgroundService", path="src/")
  → Grep("builder.Services.Add", path="**/Program.cs")  → all DI registrations
  → Grep("AddSingleton|AddScoped|AddTransient", path="**/Program.cs")  → service registrations
```

Produce a **Background Services Registry**:

```markdown
## Background Services Registry
| Service | Type | Registered In | What It Does | Triggers |
|---------|------|--------------|-------------|----------|
| OutboxWorker | IHostedService | Program.cs | Processes domain event outbox | Timer (continuous) |
| MarketDataFeed | BackgroundService | Program.cs | WebSocket market data ingestion | External WebSocket |
```

**Rules:**
- Any `IHostedService`, `BackgroundService`, `Worker`, or equivalent registered in DI must be documented.
- If none exist, explicitly state "No background services found" — do not silently omit.

---

**5c. Middleware & Pipeline Component Audit**

Scan entry-point files for all middleware registrations and pipeline components — these often implement critical cross-cutting behaviour (auth, rate limiting, tenant resolution, caching) that has no dedicated subsystem.

```
Extract from Program.cs / Startup.cs:
  → Every app.Use*() call
  → Every app.Map*() call (hub mappings, endpoint routing)
  → Order matters — document the exact pipeline sequence
```

Produce a **Middleware Pipeline Registry**:

```markdown
## Middleware Pipeline (in execution order)
| Order | Middleware | File | What It Does | External Dependencies |
|-------|-----------|------|-------------|----------------------|
| 1 | GlobalExceptionMiddleware | Middleware/GlobalException.cs | Catch-all error handler | None |
| 2 | RateLimitMiddleware | Middleware/RateLimit.cs | IP-based rate limiting | In-memory (no Redis) |
| 3 | TenantResolverMiddleware | Middleware/TenantResolver.cs | Sets RLS context | PostgreSQL connection |
```

**Rules:**
- Pipeline order must be documented — it affects security and correctness.
- Any middleware that references an external service (Redis, cache, logging service) must note that dependency.
- Hub mappings (SignalR, WebSocket) count as pipeline components and must be listed.

---

**5d. Dependency Manifest Audit (Package-Implied Capabilities)**

Scan all dependency manifests for major frameworks and libraries that imply undocumented capabilities or subsystems.

```
Files to scan:
  → *.csproj (NuGet packages)
  → package.json (npm packages)
  → requirements.txt, pyproject.toml, Pipfile (Python packages)

Flag any package that implies a capability not documented as a subsystem:
  → Microsoft.SemanticKernel → AI orchestration capability
  → SignalR → Real-time communication
  → Hangfire/Quartz → Job scheduling
  → MassTransit/RabbitMQ/Kafka → Message bus
  → StackExchange.Redis → Caching layer
  → Serilog/Seq/Application Insights → Structured logging pipeline
  → IdentityServer/Duende → OAuth/OIDC server
  → langchain/llama-index → RAG/LLM pipeline
  → Stripe/PayPal SDK → Payment processing
```

Produce a **Capability-Implying Packages** table:

```markdown
## Capability-Implying Packages
| Package | Found In | Implied Capability | Documented as Subsystem? | Actually Used in Code? |
|---------|----------|-------------------|-------------------------|----------------------|
| Microsoft.SemanticKernel | Observer.csproj | AI agent orchestration | Yes — Section 5 | Yes |
| StackExchange.Redis | Auth.Api.csproj | Caching / session store | **NO** | Check code references |
| SignalR | Auth.Api.csproj | Real-time hubs | Yes — Section 5 (Infra) | Yes |
```

**Rules:**
- Any package implying a capability that has NO corresponding subsystem documentation is a gap — investigate and document.
- "Actually Used in Code?" column prevents false positives from leftover packages — grep for import/using statements to verify.
- Presence of a package with no code usage should be flagged as potential dead dependency.

---

**5e. Inter-Service Communication Audit**

Scan application code for any service-to-service HTTP calls, gRPC connections, message bus interactions, or internal API consumption that is not a frontend→backend call (those are covered by Check 2).

```
Search patterns:
  → Grep("HttpClient|IHttpClientFactory|RestClient|WebClient", path="src/")
  → Grep("GrpcChannel|GrpcClient", path="src/")
  → Grep("IBus|IPublishEndpoint|IMediator.*Send", path="src/")  → message bus
  → Grep("localhost:\d{4}|127\.0\.0\.1:\d{4}", path="src/")  → hardcoded internal URLs
  → Grep("fetch\(|axios\.|\.post\(|\.get\(", path="src/", glob="*.ts")  → backend-to-backend in Node
```

Produce an **Inter-Service Communication Map**:

```markdown
## Inter-Service Communication Map
| Caller | Target | Protocol | URL/Channel | Purpose |
|--------|--------|---------|-------------|---------|
| Observer | Brain | HTTP | localhost:8000/api/v1/* | AI pipeline requests |
| Auth.Api | Observer | SignalR | localhost:5200/hubs/* | Real-time notifications |
```

**Rules:**
- Every internal service-to-service call must be documented — not just frontend-to-backend.
- If no inter-service calls exist, explicitly state "No inter-service communication found."
- Any hardcoded localhost URL in source code must be flagged — these break in deployment.

---

**5f. Environment Configuration Audit**

Scan all environment-specific configuration files and produce a topology map per environment, documenting where URLs, ports, feature flags, and service references differ.

```
Files to compare:
  → appsettings.json vs appsettings.Development.json vs appsettings.Production.json vs appsettings.Testing.json
  → .env vs .env.production vs .env.test
  → docker-compose.yml vs docker-compose.test.yml vs docker-compose.prod.yml
  → launchSettings.json (all profiles)
```

Produce an **Environment Topology Map**:

```markdown
## Environment Topology
| Setting | Development | Testing | Production | Notes |
|---------|------------|---------|------------|-------|
| Auth.Api port | 5064 | 5064 | 5087 | Different port in prod |
| DB host | localhost:5432 | localhost:5433 | [Azure endpoint] | Test uses separate DB |
| CORS | AllowAll | AllowAll | **MUST LOCK DOWN** | Security risk if unchanged |
| SendGrid | Disabled/mock | Disabled/mock | Live | Verify key rotation |
```

**Rules:**
- Any setting that differs across environments must be documented.
- Security-sensitive settings that are relaxed in dev (CORS AllowAll, debug endpoints, plaintext secrets) must be flagged with a warning for production.
- If only one environment config exists, note "Single environment config — no prod/test variants found" as a finding.

---

**Check 5 Output Requirements:**

All six sub-audits produce their respective registries/tables as mandatory sections in the PreExisting TechStack file. The combined output is:

1. External Dependency Registry
2. Background Services Registry
3. Middleware Pipeline Registry
4. Capability-Implying Packages table
5. Inter-Service Communication Map
6. Environment Topology Map

**Rules:**
- All six sub-audits are mandatory for every L3 scan. If a sub-audit finds nothing, it must explicitly state "None found" — silent omission is not acceptable.
- The Conductor owns this check. It may NOT be delegated to the scan subagent.
- Check 5 runs AFTER Check 4 (Cross-Layer Matrix) — it catches what the matrix cannot.
- Config files from ALL environments must be read, not just the default.

---

**Failure consequence:** Presenting an L3 output to Commander ท่านผู้บัญชาการ without completing all five checks is a protocol violation — equivalent to filing an incomplete ticket. The output must be retracted and a corrected version resubmitted with a completed File Manifest, Cross-Layer Subsystem Matrix, and all Check 5 registries.

---

*Updated: 13-03-2026*
