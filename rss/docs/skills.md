# Skills Registry

Status: available

Purpose:
- This file will contain the list of shared skills and shared scripts from `$WORKSPACE_ROOT/rss/skills` for all agents.

Available skills:
- `git-publish`
  - Path: `$WORKSPACE_ROOT/rss/skills/git-publish`
  - Entrypoint: `$WORKSPACE_ROOT/rss/skills/git-publish/scripts/run`
  - PR mode: `scripts/run pr --repo <repo_root> [--topic <slug>]`
  - No-PR mode: `scripts/run no-pr --repo <repo_root>`
  - Dry run: add `--dry-run` (prints detected paths, no commit/push)
