#!/usr/bin/env bash
# List all listening TCP ports and, where resolvable, the git repo + branch
# of the process holding each port. macOS (uses lsof). bash 3.2 compatible.
set -uo pipefail

generate() {
  lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null | awk 'NR>1 {print $1"\t"$2"\t"$(NF-1)}' |
  while IFS=$'\t' read -r cmd pid name; do
    port="${name##*:}"
    case "$port" in (*[!0-9]*|"") continue;; esac

    cwd=$(lsof -a -p "$pid" -d cwd -Fn 2>/dev/null | sed -n 's/^n//p' | head -1)

    repo="-"; branch="-"
    if [ -n "$cwd" ] && [ -d "$cwd" ]; then
      root=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
      if [ -n "$root" ]; then
        repo=$(basename "$root")
        branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
        [ -z "$branch" ] && branch="(detached)"
      fi
    fi
    printf "%s\t%s\t%s\t%s\t%s\n" "$port" "$pid" "$cmd" "$repo" "$branch"
  done | sort -un -k1,1 | uniq
}

printf "%-7s %-7s %-18s %-28s %s\n" "PORT" "PID" "COMMAND" "REPO" "BRANCH"
printf "%-7s %-7s %-18s %-28s %s\n" "-----" "-----" "-------" "----" "------"
generate | while IFS=$'\t' read -r port pid cmd repo branch; do
  printf "%-7s %-7s %-18.18s %-28.28s %s\n" "$port" "$pid" "$cmd" "$repo" "$branch"
done
