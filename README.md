# Blank Work

Public template for a workspace where humans and coding agents collaborate with deterministic rules.

## Language
- English (this file): `$WORKSPACE_ROOT/README.md`
- Russian quickstart: `$WORKSPACE_ROOT/Human-README-Rus.md`
- English quickstart: `$WORKSPACE_ROOT/Human-README-Eng.md`

## What This Repository Provides
- A ready-to-use workspace structure (`code/`, `web/`, `rss/`, `agent/`, etc.).
- Canonical policy files for agents and humans.
- Project bootstrap and policy validation scripts.
- A shared resources area (`rss/`) with explicit availability tracking.

## Canonical Sources
- Agent policy (English): `$WORKSPACE_ROOT/AGENTS.md`
- Global shared policy (English): `$WORKSPACE_ROOT/rss/AGENTS.md`
- Agent compact context (English): `$WORKSPACE_ROOT/agent/docs/all-work-doc.md`
- Human policy (Russian): `$WORKSPACE_ROOT/Human-Work-Doc-Rus.md`
- Human policy (English): `$WORKSPACE_ROOT/Human-Work-Doc-Eng.md`
- Human quickstart (Russian): `$WORKSPACE_ROOT/Human-README-Rus.md`
- Human quickstart (English): `$WORKSPACE_ROOT/Human-README-Eng.md`

## Quick Start
1. Set your workspace root to this repository path:
   - `WORKSPACE_ROOT=<path-to-repo>`
2. Create a project:
   - `$WORKSPACE_ROOT/agent/scripts/new-project.sh <code|web> <project-name> [options]`
3. Validate policy compliance:
   - `$WORKSPACE_ROOT/agent/scripts/policy-check.sh`

## Placeholder Convention
- Documentation uses `$WORKSPACE_ROOT` instead of local absolute paths.
- Replace `$WORKSPACE_ROOT` with your real local repository path when executing commands.

## Intentionally Empty / Not Available
- `rss/docs/*` resources may exist as placeholders and be marked `not available` in `rss/AGENTS.md`.
- See `$WORKSPACE_ROOT/rss/docs/_example-resource.md` for minimal resource doc format.
- This is expected for public template state.

## Safety and Scope
- Agents must follow local `AGENTS.md` + global `rss/AGENTS.md`.
- Destructive actions require explicit user instruction/confirmation.

## License
- MIT (`$WORKSPACE_ROOT/LICENSE`)
