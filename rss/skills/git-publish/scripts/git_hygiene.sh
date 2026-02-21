#!/usr/bin/env bash
set -euo pipefail

REPO=""
APPLY=0

usage() {
  echo "Usage: git_hygiene.sh --repo <path> [--apply]" >&2
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)
      REPO="${2:-}"
      shift 2
      ;;
    --apply)
      APPLY=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown arg: $1" >&2
      usage
      exit 2
      ;;
  esac
done

if [[ -z "$REPO" ]]; then
  echo "Missing required flag: --repo <path>" >&2
  usage
  exit 2
fi

if ! command -v git >/dev/null 2>&1; then
  echo "git is required" >&2
  exit 2
fi

if [[ ! -d "$REPO/.git" ]]; then
  echo "Not a git repo: $REPO" >&2
  exit 2
fi

cd "$REPO"

if [[ "$APPLY" -eq 1 ]]; then
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "Refusing --apply with dirty working tree. Commit/stash first." >&2
    exit 2
  fi
fi

git fetch origin --prune --quiet

echo "== status =="
git status -sb

gone_branches="$(
  git for-each-ref --format='%(refname:short) %(upstream:track)' refs/heads \
    | awk '$2 ~ /\[gone\]/ {print $1}'
)"

if [[ -n "$gone_branches" ]]; then
  echo "== gone local branches =="
  echo "$gone_branches"
else
  echo "== gone local branches =="
  echo "(none)"
fi

if [[ "$APPLY" -eq 0 ]]; then
  echo "dry-run: no changes applied (use --apply)."
  exit 0
fi

if git show-ref --verify --quiet refs/heads/main; then
  git checkout main >/dev/null
  git pull --ff-only origin main
fi

if [[ -n "$gone_branches" ]]; then
  while IFS= read -r branch; do
    [[ -z "$branch" || "$branch" == "main" ]] && continue
    git branch -D "$branch" >/dev/null
  done <<< "$gone_branches"
fi

echo "== final status =="
git status -sb
