# Workspace Context

## Role
- Workspace control plane for standards, templates, and agent tooling.
- Goal: deterministic, low-noise project bootstrap from files alone.

## Structure
- `_project-template/` — unified project scaffold (code + web), includes full agent policy.
- `rss/index.md` — shared resources index (skills, tools).
- `rss/skills/git-publish/` — shared git publishing skill.
- `code/`, `web/` — domain folders for real projects.
- `agent/scripts/` — bootstrap and validation tools.
- `docs/template-standard.yaml` — machine-checkable template standard.

## Commands
- Install workspace: `bash agent/scripts/install-workspace.sh /absolute/path`
- New project: `bash agent/scripts/new-project.sh <code|web> <name> [options]`
- Validate projects: `bash agent/scripts/policy-check.sh`
- Sync templates: `bash agent/scripts/template-sync.sh --dry-run`

## Dependencies
- `bash`, `python3`

## Key Decisions
- One unified template; domain differences via installer flags.
- Each project gets a self-contained `AGENTS.md` from the template (no external shared policy file).
- Shared skills and tools are discovered via `rss/index.md`.
- `v3` roadmap layout (`agent/roadmap/state.md`, `archive.md`, `intent.md`) for all new projects.
- Project agents load only their local `AGENTS.md`. Never this workspace AGENTS.md.
