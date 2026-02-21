# Spec 006 - Validation Gates Readonly + Portability

## Status
`done`

## Goal
Fix two regressions in validation gates:
1. `onboarding-check.sh` should not fail by default when `/rss/skills` baseline docs are absent in a clean checkout.
2. `template-sync --dry-run` must be side-effect free (no writes to tracked report/state artifacts).

## Scope
- `$WORKSPACE_ROOT/agent/scripts/onboarding-check.sh`
- `$WORKSPACE_ROOT/agent/scripts/template_sync.py`
- `$WORKSPACE_ROOT/AGENTS.md`
- `$WORKSPACE_ROOT/agent/docs/run.md`
- `$WORKSPACE_ROOT/agent/docs/kb.md`
- `$WORKSPACE_ROOT/docs/templates/README.md`
- `$WORKSPACE_ROOT/agent/specs/000-roadmap.md`

## Implemented
1. Updated `onboarding-check.sh` `check_skills_workspace` logic:
   - keep hard check for `$WORKSPACE_ROOT/rss/skills` directory presence.
   - treat missing `$WORKSPACE_ROOT/rss/skills/AGENTS.md` and `$WORKSPACE_ROOT/rss/skills/agent/log.md` as `[INFO]` (non-blocking).
   - keep hard check that legacy `$WORKSPACE_ROOT/rss/skills/log.md` must stay absent.
2. Updated `template_sync.py`:
   - removed report write in `--dry-run` path.
   - `--dry-run` now performs verification only and exits without filesystem writes.
3. Updated policy docs to reflect the new behavior:
   - onboarding baseline wording in workspace `AGENTS.md`.
   - runbook/kb/template README notes about dry-run read-only behavior and onboarding optionality for `rss/skills` baseline docs.

## Validation
- `bash $WORKSPACE_ROOT/agent/scripts/build.sh`
- `bash $WORKSPACE_ROOT/agent/scripts/policy-check.sh`
- `bash $WORKSPACE_ROOT/agent/scripts/onboarding-check.sh`
- `git status --short` confirms dry-run checks do not touch `template-sync-last-run.md`.

## Result
- Validation scripts are usable on clean checkouts with minimal `rss/skills` content.
- Dry-run checks are now deterministic and non-mutating.
