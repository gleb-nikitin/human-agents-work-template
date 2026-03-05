# Agent Workspace Template v2

Template workspace for AI agent-driven projects with file-based policy, spec-driven lifecycle, and shared tooling.

## Quick Start
1. Install: `bash agent/scripts/install-workspace.sh /absolute/path`
2. Create project: `bash agent/scripts/new-project.sh code my-project`
3. Start working in `code/my-project/`

## Key Files
- `rss/AGENTS.md` — shared policy (THE main document for all project agents)
- `_project-template/` — unified project scaffold
- `_project-template/agent/scripts/` — per-project runtime entrypoints (`run.sh`, `build.sh`, `monitor.sh`)
- `Human-README.md` — operator guide
- `docs/template-standard.yaml` — template standard definition
