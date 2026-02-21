# Architecture

## Role of this file
- Structural map of `/work` components and boundaries.
- Defines what belongs to workspace control-plane docs/scripts versus managed project areas.

## Read Next
1. `$WORKSPACE_ROOT/agent/docs/context.md` (startup snapshot)
2. `$WORKSPACE_ROOT/agent/docs/kb.md` (stable reference and inventory)
3. `$WORKSPACE_ROOT/agent/docs/run.md` (operations and validation)

## Purpose
Overseer workspace project for `$WORKSPACE_ROOT`.
It maintains standards, bootstrap tooling, and compliance checks for workspace projects.

## Scope
- In scope: `$WORKSPACE_ROOT` and subfolders.
- Out of scope: parent folders, except explicit read-only allowlist defined in `$WORKSPACE_ROOT/AGENTS.md`.

## Workspace Architecture Map
- `$WORKSPACE_ROOT/AGENTS.md`: root policy entrypoint for all agents.
- `$WORKSPACE_ROOT/agent/docs/*`: compact agent context and runbook.
- `$WORKSPACE_ROOT/agent/specs/*`: roadmap + stage specs (planning source of truth).
- `$WORKSPACE_ROOT/docs/templates/*`: canonical machine-checkable template standards + snippets.
- `$WORKSPACE_ROOT/agent/scripts/new-project.sh`: deterministic project bootstrap.
- `$WORKSPACE_ROOT/agent/scripts/template-sync.sh`: standards-driven template/project sync entrypoint.
- `$WORKSPACE_ROOT/agent/scripts/template_sync.py`: sync engine (hash/state gates, apply/dry-run, reporting).
- `$WORKSPACE_ROOT/agent/scripts/policy-check.sh`: required structure/policy validation for `code/*` and `web/*`.
- `$WORKSPACE_ROOT/agent/scripts/parse_claude_chats.py`: optional export utility for human chat history.
- `$WORKSPACE_ROOT/human-docs/*`: human-facing policy and project registry.
- `$WORKSPACE_ROOT/rss/*`: shared resources and shared skills registry.
- `$WORKSPACE_ROOT/rss/skills`: shared-skills project with its own GitHub lifecycle.

## Runtime and Dependencies
- Shell tooling: `bash`, `cp`, `date`, `find`.
- Python tooling: `python3` for `parse_claude_chats.py` and `template_sync.py`.
- Baseline policy checks run locally and do not require network access.

## Boundaries and Safety
- Keep operations deterministic and non-destructive.
- Do not publish from `$WORKSPACE_ROOT` (workspace root is not a git repo).
- Use project-local repos under `code/*` or `web/*` for git publishing flows.
- Treat `$WORKSPACE_ROOT/rss` and `$WORKSPACE_ROOT/disk` as non-published storage areas, except `$WORKSPACE_ROOT/rss/skills` which is intentionally published as its own repo.
