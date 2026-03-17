# ProjectEnvironment

> Active project registry. Check this file before constructing any Development folder path or PreExisting TechStack path.
> Maintained by AM (Overseer). Update when a project is added, put on hold, or its source path changes.

---

## Active Projects

### UniOpsQC
**PROJECT_MODE:** Centralized
**PROJECT_ROOT:** `C:/UnicornVibeCode/UniOpsQC`
**SOURCE_ROOT:** `C:/UnicornVibeCode/UniOpsQC`
**ACTIVE:** true
**Notes:** RoundTable Framework — the governance framework itself. Planning and source in same root. Framework management, policy updates, skill development, contributor PR review.

---

### HubVSCode
**PROJECT_MODE:** Decentralized
**PROJECT_ROOT:** `C:/UnicornVibeCode/UniOpsQC/Development/HubVSCode`
**SOURCE_ROOT:** `C:/UnicornVibeCode/roundtable-hub-vscode`
**ACTIVE:** true
**Notes:** UniOpsQC Hub VSCode Extension (TypeScript, esbuild, v1.6.0). Publisher: UnicornTech. Planning hub in UniOpsQC/Development/HubVSCode — source code in separate repo (GitHub: UniOpsQC-vscode, local folder: roundtable-hub-vscode). Issues tracked in UniOpsQC repo (#50–55). Open bugs: SESSION LOGS filename mismatch, FRAMEWORK STATUS vunknown, Update Preview clipboard bug, Set project name dialog repeat.

---

## Rules

- Check this file before constructing any Development folder path or PreExisting TechStack path
- If a project is not listed here, add it before beginning work
- `SOURCE_ROOT` and `PROJECT_ROOT` are the same in Centralized mode with no sub-components; different in Decentralized mode
- Set `ACTIVE: false` for projects that are on hold — do not delete entries
- Update the Notes field when significant project state changes (new deployment, mode change, source path change)

---

*Last updated: 17-03-2026 by AM (AstonMartin)*
