# Template Standards

This directory is the canonical, machine-checkable source for project template standards.

## Canonical Files
- `$WORKSPACE_ROOT/docs/templates/code-template-standard.yaml`
- `$WORKSPACE_ROOT/docs/templates/web-template-standard.yaml`
- `$WORKSPACE_ROOT/docs/templates/template-standards.version`

## How To Edit Standards
1. Edit `code-template-standard.yaml` and/or `web-template-standard.yaml`.
2. Recompute and update `template-standards.version` (hash-based).
3. Set `standard_version` in both standard files to the same hash value.
4. Run sync apply for each impacted domain.

## Sync Commands
- Dry run:
  - `bash $WORKSPACE_ROOT/agent/scripts/template-sync.sh --domain code --dry-run`
  - `bash $WORKSPACE_ROOT/agent/scripts/template-sync.sh --domain web --dry-run`
  - Dry-run is read-only and must not modify tracked files.
- Apply:
  - `bash $WORKSPACE_ROOT/agent/scripts/template-sync.sh --domain code --apply`
  - `bash $WORKSPACE_ROOT/agent/scripts/template-sync.sh --domain web --apply`

## Enforcement
- `policy-check.sh` and `onboarding-check.sh` call `template-sync.sh --dry-run` as a hard gate.
- If standards hash/state is not applied, checks fail and instruct running sync apply.
- On standards changes, sync apply is mandatory.

## Waiver Policy
- Waiver is allowed only by explicit user instruction.
- Without explicit waiver, standard changes must include template + existing-project synchronization in the same change cycle.

## Last Run Report
- Canonical report path:
  - `$WORKSPACE_ROOT/agent/reports/template-sync-last-run.md`
- Report is written on apply/fail-apply runs, not on dry-run.
