# Spec 005 - Template Standard Propagation Guardrails

## Status
`done`

## Goal
Ensure every template standard change is machine-checkable and enforced in the same change cycle across:
- `$WORKSPACE_ROOT/code/_project-template`
- `$WORKSPACE_ROOT/web/_project-template`
- bootstrap and validation scripts
- existing projects in matching domain (safe automatable sync only)

## Scope
- In scope:
  - `$WORKSPACE_ROOT/docs/templates/*`
  - `$WORKSPACE_ROOT/agent/docs/*`
  - `$WORKSPACE_ROOT/code/_project-template`
  - `$WORKSPACE_ROOT/web/_project-template`
  - `$WORKSPACE_ROOT/code/*` (excluding `_project-template` and excluded cache/vendor dirs)
  - `$WORKSPACE_ROOT/web/*` (excluding `_project-template` and excluded cache/vendor dirs)
  - `$WORKSPACE_ROOT/agent/scripts/new-project.sh`
  - `$WORKSPACE_ROOT/agent/scripts/template-sync.sh`
  - `$WORKSPACE_ROOT/agent/scripts/template_sync.py`
  - `$WORKSPACE_ROOT/agent/scripts/policy-check.sh`
  - `$WORKSPACE_ROOT/agent/scripts/onboarding-check.sh`
- Out of scope:
  - feature/business logic changes in active subprojects
  - human-facing redesign outside required sync updates

## Problem Statement
Template updates were previously manual and not hard-gated, which caused drift between:
- standard expectations
- template directories
- project bootstrap/check scripts
- existing project layouts

Need deterministic guardrails with canonical editable standard docs and strict sync checks.

## Operator Decisions (Applied)
1. Canonical report path only:
   - `$WORKSPACE_ROOT/agent/reports/template-sync-last-run.md`
   - no `$WORKSPACE_ROOT/logs` usage.
2. Forbidden-path handling:
   - immediate delete (`rm -rf` semantics), no quarantine.
3. Excluded project directory names:
   - `.git`, `node_modules`, `.venv`, `venv`, `dist`, `build`, `.cache`, `__pycache__` (+ `.pytest_cache`).
4. Standard change policy:
   - sync apply is mandatory; dry-run-only is insufficient.
5. Auto-edit policy:
   - templates: overwrite to standard where template files are managed
   - existing projects: add missing required paths/files only; do not rewrite existing content
   - if non-trivial content rewrite/conflict is needed: report + fail.
6. Version format:
   - hash-based version in `template-standards.version`.
7. Domain/project roots:
   - direct children of `$WORKSPACE_ROOT/code` and `$WORKSPACE_ROOT/web`
   - exclude `_project-template` from project sync scan.

## Implemented
1. Added canonical standards directory:
   - `$WORKSPACE_ROOT/docs/templates/code-template-standard.yaml`
   - `$WORKSPACE_ROOT/docs/templates/web-template-standard.yaml`
   - `$WORKSPACE_ROOT/docs/templates/template-standards.version`
   - `$WORKSPACE_ROOT/docs/templates/template-standards.schema.json`
   - `$WORKSPACE_ROOT/docs/templates/README.md`
2. Added template snippets for managed template files:
   - `$WORKSPACE_ROOT/docs/templates/snippets/code/*`
   - `$WORKSPACE_ROOT/docs/templates/snippets/web/*`
3. Implemented sync/enforcement tool:
   - `$WORKSPACE_ROOT/agent/scripts/template-sync.sh`
   - `$WORKSPACE_ROOT/agent/scripts/template_sync.py`
   - supports:
     - `--domain code|web`
     - `--dry-run`
     - `--apply`
4. Implemented hash-state hard gate:
   - state file: `$WORKSPACE_ROOT/agent/reports/template-sync-state.json`
   - `--dry-run` fails when:
     - standards hash is not applied for the domain
     - pending sync changes exist
     - conflicts exist
5. Enforcement integration:
   - `$WORKSPACE_ROOT/agent/scripts/policy-check.sh` now hard-checks template sync for code+web via dry-run gate.
   - `$WORKSPACE_ROOT/agent/scripts/onboarding-check.sh` now hard-checks template sync for code+web via dry-run gate.
   - `$WORKSPACE_ROOT/agent/scripts/new-project.sh` now blocks project creation if domain template sync gate is not green.
6. Script health integration:
   - `$WORKSPACE_ROOT/agent/scripts/build.sh` validates `template_sync.py` syntax.
   - `$WORKSPACE_ROOT/agent/scripts/monitor.sh` validates presence of template standard artifacts and sync scripts.
7. Applied initial sync rollout:
   - `code` domain apply created missing standard paths in `$WORKSPACE_ROOT/code/vast-ai/agent/*`.
   - `web` domain apply completed with no project changes (no active web projects).
   - pre-apply dry-run intentionally failed with `state_mismatch=yes` (hard-gate behavior confirmed).
8. Workspace docs updated for operational clarity:
   - `$WORKSPACE_ROOT/AGENTS.md`
   - `$WORKSPACE_ROOT/agent/docs/context.md`
   - `$WORKSPACE_ROOT/agent/docs/kb.md`
   - `$WORKSPACE_ROOT/agent/docs/run.md`

## Acceptance Criteria
- Standard docs are canonical and machine-checkable.
- Hash version is deterministic and enforced.
- Sync apply is mandatory after standards changes.
- Checks fail hard when standard sync is missing.
- Existing project sync is add-only + deterministic forbidden deletion.
- Canonical report path is `$WORKSPACE_ROOT/agent/reports/template-sync-last-run.md`.

## Validation
- `bash $WORKSPACE_ROOT/agent/scripts/template-sync.sh --domain code --dry-run`
- `bash $WORKSPACE_ROOT/agent/scripts/template-sync.sh --domain web --dry-run`
- `bash $WORKSPACE_ROOT/agent/scripts/template-sync.sh --domain code --apply`
- `bash $WORKSPACE_ROOT/agent/scripts/template-sync.sh --domain web --apply`
- `bash $WORKSPACE_ROOT/agent/scripts/build.sh`
- `bash $WORKSPACE_ROOT/agent/scripts/policy-check.sh`
- `bash $WORKSPACE_ROOT/agent/scripts/onboarding-check.sh`
- `bash $WORKSPACE_ROOT/agent/scripts/run.sh`
- `bash $WORKSPACE_ROOT/agent/scripts/monitor.sh`
