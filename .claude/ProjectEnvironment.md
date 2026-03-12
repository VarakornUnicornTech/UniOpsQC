# ProjectEnvironment

> Active project registry. Check this file before constructing any Development folder path or PreExisting TechStack path.
> Maintained by AM (Overseer). Update when a project is added, put on hold, or its source path changes.

---

## Field Reference

| Field | Description |
|-------|-------------|
| **PROJECT_MODE** | `Centralized` = planning docs and source code share the same root (greenfield/solo projects). `Decentralized` = planning hub and source code are in separate locations (pre-existing codebases, client repos). |
| **PROJECT_ROOT** | The top-level directory of your project. All Development folders and RoundTable logs are created relative to this path. |
| **SOURCE_ROOT** | Where the actual source code lives. Same as PROJECT_ROOT in Centralized mode. Different in Decentralized mode (e.g., a separate repo or subfolder). |
| **ACTIVE** | `true` = currently being worked on. `false` = on hold (do not delete entries, just set to false). |
| **CONVERSATION_LANGUAGE** | Language for AI conversation responses. Values: `auto` (detect from user input), or ISO code (`th`, `en`, `ja`, `zh`, etc.). Default: `auto`. |
| **LOG_LANGUAGE** | Language for RoundTable and Team Chat log entries. Values: `conversation` (match conversation language), or ISO code. Default: `conversation`. |
| **DOC_LANGUAGE** | Language for planning documents and technical documentation. Values: ISO code. Default: `en`. |
| **Notes** | Free-text field for tracking significant project state changes. |

---

## Active Projects

<!-- EXAMPLE (remove or replace with your actual project):

### MyWebApp
**PROJECT_MODE:** Centralized
**PROJECT_ROOT:** `d:/Projects/MyWebApp`
**SOURCE_ROOT:** `d:/Projects/MyWebApp`
**ACTIVE:** true
**CONVERSATION_LANGUAGE:** auto
**LOG_LANGUAGE:** conversation
**DOC_LANGUAGE:** en
**Notes:** Main web application. Started 01-03-2026.

### ClientPortal
**PROJECT_MODE:** Decentralized
**PROJECT_ROOT:** `d:/Projects/ClientPortal`
**SOURCE_ROOT:** `d:/ClientRepo/portal-frontend`
**ACTIVE:** true
**CONVERSATION_LANGUAGE:** en
**LOG_LANGUAGE:** en
**DOC_LANGUAGE:** en
**Notes:** Client's existing React app. Planning docs in PROJECT_ROOT, source code in client's repo.
-->

### [Your Project Name]
**PROJECT_MODE:** Centralized
**PROJECT_ROOT:** `[full path to your project root]`
**SOURCE_ROOT:** `[full path to your source code]`
**CONVERSATION_LANGUAGE:** auto
**LOG_LANGUAGE:** conversation
**DOC_LANGUAGE:** en
**ACTIVE:** true
**Notes:** Replace this entry with your actual project details.

---

## Rules

- Check this file before constructing any Development folder path or PreExisting TechStack path
- If a project is not listed here, add it before beginning work
- `SOURCE_ROOT` and `PROJECT_ROOT` are the same in Centralized mode with no sub-components; different in Decentralized mode
- Set `ACTIVE: false` for projects that are on hold — do not delete entries
- Update the Notes field when significant project state changes (new deployment, mode change, source path change)
