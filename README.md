# claude-config

My Claude Code skills + plugins, kept in sync across machines.

## What's here
- `skills/` — my custom skills (vendored; this repo is their source of truth):
  - `my-skills` — lists my favourite skills (`/my-skills`)
  - `update-skills` — updates all plugins + skills (`/update-skills`)
- `bootstrap.sh` — reproduces the full setup on a new machine:
  - adds the `claude-plugins-official` and `thedotmack` marketplaces
  - installs plugins: frontend-design, skill-creator, superpowers, claude-mem
  - copies the vendored custom skills into `~/.claude/skills/`
  - clones the Matt Pocock skills from `mattpocock/skills` and copies them in

## Set up a new machine
```bash
git clone <this-repo-url> ~/claude-config
cd ~/claude-config
./bootstrap.sh
# then restart Claude Code
```

## Keep machines in sync
- Edited a custom skill? It lives in `~/.claude/skills/<name>/`. Copy it back here and commit:
  ```bash
  cp -R ~/.claude/skills/my-skills ~/claude-config/skills/
  git -C ~/claude-config add -A && git -C ~/claude-config commit -m "update my-skills" && git -C ~/claude-config push
  ```
- On the other machine: `git -C ~/claude-config pull && ~/claude-config/bootstrap.sh`

## Notes
- Marketplace plugins self-update via `claude plugin update <name>` (or run `/update-skills`).
- Matt Pocock skills are not marketplace-managed; re-running `bootstrap.sh` re-pulls the latest.
