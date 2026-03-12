# /template-check

## Purpose
Check whether a newer version of RoundTable Framework is available by comparing the local version against the remote repository.

## Arguments
None.

## Steps

1. **Read local version** from `template-version.json`.
   - If missing, report: "No template-version.json found -- cannot determine current version."

2. **Fetch remote version** from the RoundTable Framework repository:
   - Attempt to fetch `template-version.json` from the GitHub raw URL:
     `https://raw.githubusercontent.com/VarakornUnicornTech/unicorn_roundtable_framework_repo/main/template-version.json`
   - If fetch fails, report: "Could not reach remote repository. Check your internet connection or verify the repository URL."

3. **Compare versions** using semantic versioning:
   - Parse local `version` and remote `version`
   - Determine: UP TO DATE, UPDATE AVAILABLE, or AHEAD OF REMOTE

4. **If an update is available**, also fetch the remote `CHANGELOG.md` and extract only the sections newer than the local version.

5. **Present the result:**

```markdown
## RoundTable Framework -- Update Check

| Property | Value |
|----------|-------|
| **Local version** | [local version] |
| **Remote version** | [remote version] |
| **Status** | [UP TO DATE / UPDATE AVAILABLE / AHEAD OF REMOTE] |

### What's New (since [local version])
[Changelog entries for versions between local and remote, or "Nothing -- you're up to date."]

### Next Steps
- Run `/template-diff` to see exactly what changed
- Run `/template-apply` to apply the update
```

## Output
A version comparison report with changelog highlights if an update is available.
