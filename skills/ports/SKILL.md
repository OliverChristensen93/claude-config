---
name: ports
description: List all occupied/listening localhost TCP ports and the process on each, including the git repo + branch a dev server is running from. Use when the user asks "what ports are in use", "what's running on localhost", "which servers are running", "what's on port X", or wants to find/kill a stray dev server.
---

# ports

Show every listening TCP port on this machine, the owning process, and — where the
process is a dev server running inside a git checkout — the repo and branch it's serving from.

## What to do
Run the bundled script and show the user its table output:

```bash
bash "$CLAUDE_SKILL_DIR/ports.sh"
```

If `$CLAUDE_SKILL_DIR` isn't set, use the absolute path: `bash ~/.claude/skills/ports/ports.sh`.

The table has columns: **PORT · PID · COMMAND · REPO · BRANCH**. Rows where REPO/BRANCH are `-`
are system/app processes (Spotify, Cursor, ControlCenter, Docker, etc.) — the meaningful dev
servers are the ones that resolve to a repo + branch.

## Follow-ups the user may want
- **Just the dev servers:** filter the output to rows where REPO is not `-`.
- **What's on a specific port:** `lsof -nP -iTCP:<port> -sTCP:LISTEN`
- **Kill a stray server:** confirm the PID with the user first, then `kill <PID>` (or `kill -9 <PID>` if it won't stop). Never kill a process without confirming what it is.

## How it works / notes
- Uses `lsof -nP -iTCP -sTCP:LISTEN` to list listening sockets, then resolves each PID's working
  directory (`lsof -d cwd`) and runs `git -C <cwd>` to get the repo root + current branch.
- macOS only (relies on `lsof`); written for bash 3.2 (the system bash), so no associative arrays.
- Repo/branch only resolves when the process's **cwd** is inside the checkout — true for typical
  `npm run dev` / node servers. A server started from a different cwd may not resolve.
- Detached HEAD shows as `(detached)`.
