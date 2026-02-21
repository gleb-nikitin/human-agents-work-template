# Runbook

## Role of this file
- Operational workspace entrypoint: startup order, command matrix, and validation flow.
- Keeps execution steps only; structural/reference context lives in `context.md`, `arch.md`, and `kb.md`.

## Read Next
1. `$WORKSPACE_ROOT/agent/docs/context.md` (snapshot)
2. `$WORKSPACE_ROOT/agent/docs/arch.md` (structure)
3. `$WORKSPACE_ROOT/agent/docs/kb.md` (reference data)

## Startup Order
1. `$WORKSPACE_ROOT/AGENTS.md`
2. `$WORKSPACE_ROOT/rss/AGENTS.md`
3. `$WORKSPACE_ROOT/agent/docs/context.md`
4. `$WORKSPACE_ROOT/agent/specs/000-roadmap.md`
5. Open detailed docs as needed: `arch.md`, `run.md`, `kb.md`, active spec in `$WORKSPACE_ROOT/agent/specs/`.

## Required Files
- Authoritative list: `$WORKSPACE_ROOT/AGENTS.md` § "Required Files — Authoritative".

## Command Matrix
- Validate workspace projects:
  - `bash $WORKSPACE_ROOT/agent/scripts/run.sh`
  - `bash $WORKSPACE_ROOT/agent/scripts/policy-check.sh`
- Validate template standards sync gates:
  - `bash $WORKSPACE_ROOT/agent/scripts/template-sync.sh --domain code --dry-run`
  - `bash $WORKSPACE_ROOT/agent/scripts/template-sync.sh --domain web --dry-run`
  - `--dry-run` is verification-only (must not write report/state files).
- Apply template standards sync:
  - `bash $WORKSPACE_ROOT/agent/scripts/template-sync.sh --domain code --apply`
  - `bash $WORKSPACE_ROOT/agent/scripts/template-sync.sh --domain web --apply`
- Run onboarding protocol checks (workspace root + templates + active projects + `rss/skills`):
  - `bash $WORKSPACE_ROOT/agent/scripts/onboarding-check.sh`
  - `rss/skills` missing baseline docs (`AGENTS.md`, `agent/log.md`) are informational only.
- Validate agent script health:
  - `bash $WORKSPACE_ROOT/agent/scripts/build.sh`
- Quick status of required agent artifacts:
  - `bash $WORKSPACE_ROOT/agent/scripts/monitor.sh`
- Bootstrap a new project:
  - `bash $WORKSPACE_ROOT/agent/scripts/new-project.sh <code|web> <kebab-case-name> [options]`
- Export Claude chats for human docs:
  - `python3 $WORKSPACE_ROOT/agent/scripts/parse_claude_chats.py`

## Pre-Execution Checks
- Confirm required paths/files exist.
- Confirm command dependencies exist (`bash`, `python3`, project scripts).
- Load only context required for the current task.
- Confirm active spec path and include it in meaningful `agent/log.md` entries for implementation work.
- Before any cross-project file updates: use `agent/docs/kb.md` § "Project Inventory" as the authoritative project list, not filesystem glob.

## Logging Rule
- Append only key stages to `$WORKSPACE_ROOT/agent/log.md`.
- Format: `YYYY-MM-DD HH:MM | action | result`.
- Timestamps must be current write-time only; no backfilled/retroactive timestamps.
- For spec-driven implementation, include `spec=/absolute/path/to/spec.md` in log entry text.

## Post-Change Validation
1. `bash $WORKSPACE_ROOT/agent/scripts/build.sh`
2. `bash $WORKSPACE_ROOT/agent/scripts/run.sh`
3. `bash $WORKSPACE_ROOT/agent/scripts/onboarding-check.sh`
4. Add one factual line to `$WORKSPACE_ROOT/agent/log.md`

## Template Reconciliation Steps (code/web)
1. Confirm template baseline in `$WORKSPACE_ROOT/agent/docs/kb.md` (`Template Standards` section).
2. Check file placement in:
   - `$WORKSPACE_ROOT/code/_project-template`
   - `$WORKSPACE_ROOT/web/_project-template`
3. Run `bash $WORKSPACE_ROOT/agent/scripts/onboarding-check.sh` and require `SUCCESS`.
