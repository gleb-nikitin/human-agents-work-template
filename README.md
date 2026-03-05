# Agent Workspace Template v3

Template workspace for AI agent-driven projects with file-based policy, spec-driven lifecycle, and shared tooling.

## Quick Start
1. Install: `bash agent/scripts/install-workspace.sh /absolute/path`
2. Create project: `bash agent/scripts/new-project.sh code my-project`
3. Start working in `code/my-project/`

## Key Files
- `AGENTS.md` — workspace-level policy (bootstrap and validation)
- `_project-template/` — unified project scaffold (each project gets its own `AGENTS.md` with full policy)
- `_project-template/agent/scripts/` — per-project runtime entrypoints (`run.sh`, `build.sh`, `monitor.sh`)
- `_project-template/agent/src/` — project source code root
- `rss/index.md` — shared resources index (skills, tools)
- `Human-README.md` — operator guide
- `human-system-report.md` — human-facing quality snapshot (`7.5/10` overall)
- `docs/template-standard.yaml` — template standard definition

## Validation
- `bash agent/scripts/policy-check.sh` — check projects against template standard
- `bash agent/scripts/template-sync.sh --dry-run` — preview template alignment fixes
