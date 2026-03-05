# Workspace Context

## Role
- Workspace control plane for standards, templates, and agent tooling.
- Goal: deterministic, low-noise project bootstrap from files alone.

## Structure
- `_project-template/` — unified project scaffold (code + web).
- `rss/AGENTS.md` — THE shared policy for all project agents.
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
- `rss/AGENTS.md` is THE shared policy (all projects inherit).
- `v2` roadmap layout (`state/archive/intent`) for all new projects.
- Project agents load only their local `AGENTS.md` + `rss/AGENTS.md`. Never this workspace AGENTS.md.
