#!/usr/bin/env bash
# Reproduce my Claude Code skills + plugins on any machine.
# Run from inside the cloned repo:  ./bootstrap.sh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$SKILLS_DIR"

echo "==> 1/4  Marketplaces"
# claude-plugins-official is usually a built-in default; add tolerantly in case it isn't.
claude plugin marketplace add anthropics/claude-plugins-official 2>/dev/null || true
claude plugin marketplace add thedotmack/claude-mem 2>/dev/null || true

echo "==> 2/4  Plugins"
for p in \
  frontend-design@claude-plugins-official \
  skill-creator@claude-plugins-official \
  superpowers@claude-plugins-official \
  claude-mem@thedotmack ; do
  echo "    install $p"
  claude plugin install "$p" 2>&1 | tail -1 || echo "    (skipped/failed: $p)"
done

echo "==> 3/4  Custom skills (vendored in this repo)"
for d in "$REPO_DIR"/skills/*/ ; do
  name="$(basename "$d")"
  rm -rf "${SKILLS_DIR:?}/$name"
  cp -R "$d" "$SKILLS_DIR/"
  echo "    copied $name"
done

echo "==> 4/4  Matt Pocock skills (cloned from upstream)"
TMP="$(mktemp -d)"
git clone --depth 1 https://github.com/mattpocock/skills.git "$TMP/mp" >/dev/null 2>&1
for sk in \
  engineering/ask-matt engineering/diagnosing-bugs engineering/grill-with-docs \
  engineering/triage engineering/improve-codebase-architecture \
  engineering/setup-matt-pocock-skills engineering/tdd engineering/to-issues \
  engineering/to-prd engineering/prototype engineering/domain-modeling \
  engineering/codebase-design productivity/grill-me productivity/grilling \
  productivity/handoff productivity/teach productivity/writing-great-skills ; do
  src="$TMP/mp/skills/$sk"
  [ -d "$src" ] && cp -R "$src" "$SKILLS_DIR/" && echo "    copied $(basename "$sk")"
done
rm -rf "$TMP"

echo
echo "Done. Restart Claude Code for plugin changes to take effect."
