# Runbook

## When to Load
- Load only when executing, building, validating, or collecting runtime commands.

## Commands
- Run: `bash ./agent/scripts/run.sh`
- Build: `bash ./agent/scripts/build.sh`
- Monitor: `bash ./agent/scripts/monitor.sh`

## Bootstrap Validation
- Workspace policy check (from project root): `bash ../../agent/scripts/policy-check.sh --domain __PROJECT_AREA__`
- Workspace template sync check (from project root): `bash ../../agent/scripts/template-sync.sh --domain __PROJECT_AREA__ --dry-run`

## Test
- Project-specific. Replace with the real test command after first implementation.

## Validate
- Keep script entrypoints in `./agent/scripts/` as the canonical runtime interface for project agents.
