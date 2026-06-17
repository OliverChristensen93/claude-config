---
name: update-skills
description: Update all of the user's installed skills and plugins to their latest versions. Use when the user says "update my skills", "update all skills", "update plugins", "upgrade my skills", or wants everything refreshed to the newest version.
---

# Update Skills

Run the following steps to bring everything up to date, then report what changed. Run the bash steps and show the user a short summary.

## 1. Refresh marketplaces (pulls latest plugin metadata)
```bash
claude plugin marketplace update
```

## 2. Update every installed plugin
Update each plugin to its latest version (the CLI has no `--all`, so loop):
```bash
for p in $(claude plugin list 2>/dev/null | sed -n 's/.*[❯>] *\([^ ]*@[^ ]*\).*/\1/p'); do
  echo "=== $p ==="
  claude plugin update "$p" 2>&1 | tail -2
done
```
If that parse yields nothing, fall back to listing plugins with `claude plugin list` and run `claude plugin update <name>@<marketplace>` for each shown.

## 3. Re-copy the manually-installed Matt Pocock skills
These are not marketplace-managed, so update them by re-cloning and overwriting:
```bash
TMP=$(mktemp -d)
git clone --depth 1 https://github.com/mattpocock/skills.git "$TMP/mp" 2>&1 | tail -1
DEST=~/.claude/skills
for cat in engineering productivity; do
  for d in "$TMP/mp/skills/$cat"/*/; do
    name=$(basename "$d")
    # only refresh skills we already have installed
    [ -d "$DEST/$name" ] && cp -R "$d" "$DEST/" && echo "updated $name"
  done
done
rm -rf "$TMP"
```

## 4. Report
- Note that **a Claude Code restart is required** for plugin updates to take effect.
- Summarize which plugins updated vs. were already current, and which Matt Pocock skills were refreshed.
