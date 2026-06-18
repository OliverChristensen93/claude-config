---
name: my-skills
description: List the user's favourite / manually-added skills with a description and "use when" for each. Use when the user asks "what skills do I have", "my skills", "favourite skills", "remind me what skills I added", or wants an overview of their installed/curated skills.
---

# My Skills

When invoked, present the curated favourites below. Show each skill's invocation, what it does, and when to reach for it. Keep it scannable.

## Favourites

### Matt Pocock skills (manually copied into `~/.claude/skills/`)
- **`/grill-with-docs`** — A relentless interview that sharpens a plan or design, producing ADRs (architecture decision records) and a glossary as you go. **When:** after you've drafted a rough plan/idea but *before* you accept it and start building — it stress-tests assumptions, fills gaps, and leaves design docs behind. Good on anything non-trivial where getting the design wrong is costly. (Manual invoke only — won't trigger automatically.)
- **`/prototype`** — Quickly spike a throwaway prototype to validate an idea. **When:** you're unsure an approach will work and want to learn fast before committing to real implementation.
- **`/tdd`** — Test-driven development (red-green-refactor). **When:** building a feature or fixing a bug and you want tests written first to drive the design and lock in behaviour.
- **`/improve-codebase-architecture`** — Refactor toward deeper modules and cleaner seams. **When:** code feels tangled, hard to test, or hard to navigate and you want a structural cleanup.

### Plugins (marketplace-managed)
- **superpowers** (`@claude-plugins-official`) — A full software-development *methodology* for the agent, not a single command. It changes how I work by default: instead of jumping straight to code, I tease out a spec, get your sign-off on the design, write a clear implementation plan, then drive the work with TDD, YAGNI/DRY, and (for big tasks) parallel subagents — with built-in debugging, code-review, and verification skills. **When:** it triggers automatically as soon as you start building something real. You don't run it per-task; it's just on. Lean on it most for larger features where planning + autonomous execution pays off.
- **claude-mem** (`@thedotmack`) — Persistent memory across sessions. It runs *automatically* via hooks: it captures what happens during a session, compresses it into summaries, and surfaces relevant context in future sessions. **When:** you don't run it at session start — just restart Claude Code and past context appears on its own. Reach for it explicitly only to search prior memory or pull a timeline report of past work.
- **frontend-design** (`@claude-plugins-official`) — Guidance/skill for building polished UI and frontend components. **When:** working on visual/UI work — layouts, components, styling — and you want stronger design sensibility than default.
- **skill-creator** (`@claude-plugins-official`) — Create, edit, eval, and optimize skills (including these). **When:** you want to build a new skill, improve an existing one's behaviour, or tune a description so it triggers more reliably.

### My custom skills
- **`/pr-quick`** — Fast commit → push → PR (if none exists), delegated to a lower-tier model (Sonnet/Haiku) so it runs cheaply without spending your main model's budget. Follows your conventions (no `git add -A`, 1-line commits, branch off `dev` if on default, PR targets `dev`). **When:** you just want the current work shipped into a PR quickly.
- **`/ports`** — Lists all occupied localhost ports + the process on each, with the git repo + branch for any dev server. **When:** you want to see what servers are running, find what's on a port, or track down a stray dev server to kill.

### Meta
- **`/update-skills`** — Updates everything: refreshes marketplaces, updates every installed plugin, and re-pulls the Matt Pocock skills. **When:** periodically, or whenever you want the latest versions. Restart Claude Code afterward for plugin updates to apply.
- **`/insights`** — Generates a usage report analysing your Claude Code sessions (what's working, friction points, suggestions, features to try). **When:** periodically to reflect on your workflow and find improvements. (Built-in command, not a custom skill.)

## Notes
- Matt Pocock skills are a manual copy (no auto-update). Updating them is handled by `/update-skills`, or manually via `npx skills@latest add mattpocock/skills`.
- Plugins update via `claude plugin update <name>` (or just run `/update-skills`).
- To see everything installed: `claude plugin list` and the skills shown in each session.
