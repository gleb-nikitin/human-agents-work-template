# Project AGENTS.md (code template)

## Scope
- Scope boundary: this project folder and subfolders only.
- Do not traverse parent folders unless user explicitly requests.

## Required Files
- `./AGENTS.md` - project policy entrypoint and loading order.
- `./agent/log.md` - append-only factual action log.
- `./agent/docs/context.md` - startup context snapshot for no-history sessions.
- `./agent/docs/arch.md` - concise architecture summary (purpose/stack/boundaries).
- `./agent/docs/kb.md` - decisions, assumptions, and references.
- `./agent/docs/run.md` - operational run/build/test instructions.
- `./agent/specs/000-roadmap.md` - project-level roadmap with global goals and statuses.
- `./agent/scripts/run.sh` - project run entrypoint (or dispatcher).
- `./agent/scripts/build.sh` - project build entrypoint.
- `./agent/scripts/monitor.sh` - project monitoring/status entrypoint.
- `./agent/src/.gitkeep` - source tree anchor for bootstrap consistency.

## Context Loading
1. This `AGENTS.md`
2. Global `$WORKSPACE_ROOT/rss/AGENTS.md` (always)
3. Files explicitly linked from local or global `AGENTS.md`

## Bootstrap Requirements
- Project directory name must be `kebab-case`.
- Initial `agent/log.md` record is required on project creation.
- `agent/docs/arch.md` must be initially populated with project purpose, stack, and boundaries.
- `agent/specs/000-roadmap.md` must exist on project creation.

## Onboarding Protocol Compatibility
- Template is validated by `$WORKSPACE_ROOT/agent/scripts/onboarding-check.sh`.
- Keep `Required Files` aligned with workspace protocol checks.
- If required-file set changes, update both `policy-check.sh` and `new-project.sh` in the same change set.

## Workflow
- Read only required files.
- Do not inspect sibling projects.
- Append concise action records to `./agent/log.md`.
- If process/facts change, update `AGENTS.md` and relevant docs.

## Logging Format
- `YYYY-MM-DD HH:MM | action | result`

## Logging Timestamp Rule
- `agent/log.md` entries must use current write-time timestamps only.
- Do not add backfilled/retroactive timestamps.

## Git
- Git publishing uses shared skill `git-publish`:
  - Run from the project root directory, then:
    - `пуш` => `$WORKSPACE_ROOT/rss/skills/git-publish/scripts/run pr --repo "$PWD"`
    - `пуш без пр` => `$WORKSPACE_ROOT/rss/skills/git-publish/scripts/run no-pr --repo "$PWD"`
