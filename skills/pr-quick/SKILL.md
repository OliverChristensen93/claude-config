---
name: pr-quick
description: Quickly commit, push, and open a PR (if none exists) using a fast lower-tier model so it runs cheaply and quickly. Use when the user says "/pr-quick", "quick PR", "ship this quickly", or wants a fast commit-push-PR without spending the main model's budget.
---

# pr-quick

Goal: get the current work committed, pushed, and into a PR **fast and cheaply** — without using the main (expensive) model for the mechanical git work, and without disturbing the user's current model/effort.

## How it works (important)
You (the main agent) cannot change the session's model or effort. Instead, **delegate the entire pipeline to a subagent on a fast lower tier** via the Agent tool. The main session is untouched, so there is nothing to "restore" afterward. Just spawn the subagent, then relay its result.

## What to do
Call the **Agent** tool with `model: "sonnet"` (use `"haiku"` if the user wants it even faster) and this prompt:

> Run a quick commit → push → PR pipeline. Be concise and mechanical.
>
> 1. Run `git status` and `git branch --show-current`. If there are no changes to commit AND the branch is already pushed with an open PR, report that and stop.
> 2. **Never use `git add -A`.** Stage only the files that are part of this change (inspect `git status` and `git diff`; do not sweep in unrelated/untracked stray files like stray images or reformatted files). If unsure whether a file belongs, leave it unstaged and note it.
> 3. If the current branch is the default branch (`dev`/`develop`/`main`), create a new scoped feature branch off it first (descriptive kebab-case name based on the change). Otherwise stay on the current branch.
> 4. Commit with a concise **1-line** message describing what changed (no co-authored-by lines, no Claude mentions).
> 5. Push, setting upstream if needed (`git push -u origin <branch>`).
> 6. Check for an existing open PR for this branch with `gh pr view --json url,number 2>/dev/null || gh pr list --head <branch> --json url,number`. If one exists, do NOT create another — just return its URL. If none exists, create one targeting `dev` (fall back to `develop` if `dev` doesn't exist) with `gh pr create --base dev --fill` (or a concise title/body); keep the description short.
> 7. Report back: the exact branch name, whether a PR was created or already existed, and the PR URL. Nothing else.

After the subagent returns, show the user the branch, PR status, and PR URL.

## Notes
- The "lower model / medium effort" requested = the subagent's model tier. The main session's model and effort are never changed, so nothing needs to be reset.
- Respects the user's conventions: scoped staging (no `git add -A`), 1-line commits, PRs target `dev`.
