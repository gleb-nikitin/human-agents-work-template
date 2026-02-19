# Project AGENTS.md (code template)

## Scope
- Scope boundary: this project folder and subfolders only.
- Do not traverse parent folders unless user explicitly requests.

## Required Files
- `AGENTS.md`
- `CLAUDE.md`
- `log.md`
- `docs/arch.md`
- `docs/kb.md`
- `docs/run.md`

## Context Loading
1. This `AGENTS.md`
2. Global `$WORKSPACE_ROOT/rss/AGENTS.md` (always)
3. Files explicitly linked from local or global `AGENTS.md`

## Bootstrap Requirements
- Project directory name must be `kebab-case`.
- Initial `log.md` record is required on project creation.
- `docs/arch.md` must be initially populated with project purpose, stack, and boundaries.

## Workflow
- Read only required files.
- Do not inspect sibling projects.
- Append concise action records to `./log.md`.
- If process/facts change, update `AGENTS.md` and relevant docs.

## Logging Format
- `YYYY-MM-DD HH:MM | action | result`
