# Knowledge Base

## Role of this file
- Stable workspace reference: folder roles, project inventory, and durable decisions.
- Not a startup sequence file; operational startup order is defined in `$WORKSPACE_ROOT/agent/docs/run.md`.

## Read Next
1. `$WORKSPACE_ROOT/agent/docs/context.md` (startup snapshot)
2. `$WORKSPACE_ROOT/agent/docs/arch.md` (structure and boundaries)
3. `$WORKSPACE_ROOT/agent/specs/000-roadmap.md` (current plan/spec register)

## Canonical References
- `$WORKSPACE_ROOT/AGENTS.md`: workspace policy authority.
- `$WORKSPACE_ROOT/rss/AGENTS.md`: shared resources registry and loading rules.
- `$WORKSPACE_ROOT/agent/docs/context.md`: full no-history startup context.
- `$WORKSPACE_ROOT/agent/specs/000-roadmap.md`: global roadmap and priorities.
- `$WORKSPACE_ROOT/human-docs/Human-Work-Doc-Eng.md`: human-facing policy/process (EN).
- `$WORKSPACE_ROOT/human-docs/Human-Work-Doc-Rus.md`: human-facing policy/process (RU).
- `$WORKSPACE_ROOT/human-docs/Human-Project-List.md`: project inventory.

## Folder Roles
- `$WORKSPACE_ROOT/code`: executable local projects (can include remote-server components).
- `$WORKSPACE_ROOT/web`: docker-based web projects with remote sync workflows.
- `$WORKSPACE_ROOT/rss`: shared resources for projects; not a general publish area.
- `$WORKSPACE_ROOT/rss/skills`: shared-skills project with dedicated GitHub repository.
- `$WORKSPACE_ROOT/disk`: non-git data storage for all projects.
  - shared data: `$WORKSPACE_ROOT/disk/all`
  - project data: `$WORKSPACE_ROOT/disk/<project-name>`

## Project Inventory
- `$WORKSPACE_ROOT/code/vast-ai` - operations workspace for Vast.ai SDXL bootstrap/training flows.
- `$WORKSPACE_ROOT/rss/skills` - central managed repository of shared Codex skills.
- `$WORKSPACE_ROOT/code/_project-template` - code project template (bootstrap source, not production project).
- `$WORKSPACE_ROOT/web/_project-template` - web project template (bootstrap source, not production project).

## Key Decisions
- 2026-02-19: bootstrap and policy validation standardized via `new-project.sh` and `policy-check.sh`.
- 2026-02-20: git publishing standardized via shared `git-publish` skill.
- 2026-02-21: logging timestamp rule set to current write-time only (no backfill).
- 2026-02-21: project agent artifacts normalized to `/agent/*` layout.
- 2026-02-21: workspace and shared-skills logs moved to `agent/log.md` paths.
- 2026-02-21: roadmap/spec planning model moved to `$WORKSPACE_ROOT/agent/specs/*` (including `000-roadmap.md`).

## Template Standards (code/web)
- Canonical standard docs:
  - `$WORKSPACE_ROOT/docs/templates/code-template-standard.yaml`
  - `$WORKSPACE_ROOT/docs/templates/web-template-standard.yaml`
  - `$WORKSPACE_ROOT/docs/templates/template-standards.version` (hash-based)
- Canonical template roots:
  - `$WORKSPACE_ROOT/code/_project-template`
  - `$WORKSPACE_ROOT/web/_project-template`
- Sync tool:
  - `$WORKSPACE_ROOT/agent/scripts/template-sync.sh`
- Canonical report path:
  - `$WORKSPACE_ROOT/agent/reports/template-sync-last-run.md`
  - generated on `--apply` / apply-fail runs only; dry-run is read-only.
- Sync state path:
  - `$WORKSPACE_ROOT/agent/reports/template-sync-state.json`
- Common required files:
  - `./AGENTS.md`
  - `./CLAUDE.md`
  - `./agent/log.md`
  - `./agent/docs/context.md`
  - `./agent/docs/arch.md`
  - `./agent/docs/kb.md`
  - `./agent/docs/run.md`
  - `./agent/specs/000-roadmap.md`
  - `./agent/scripts/run.sh`
  - `./agent/scripts/build.sh`
  - `./agent/scripts/monitor.sh`
  - `./agent/src/.gitkeep`
- Web template additional file:
  - `./web/README.md`
- Legacy root paths that must stay absent in templates:
  - `./log.md`
  - `./docs/*`
  - `./specs/*`
  - `./scripts/*`
  - `./src/*`
- Existing project sync policy:
  - add only missing required paths/files
  - delete forbidden paths immediately (`rm -rf`, no quarantine)
  - do not rewrite existing content without explicit user approval

## Operational Notes
- Keep docs compact; keep detailed historical trail in `agent/log.md`.
- `.DS_Store` files are unavoidable macOS artifacts; treat them as noise under ignore-only policy (no mass cleanup workflow).
- If policy or process changes, sync both agent and human canonical docs per workspace matrix.
