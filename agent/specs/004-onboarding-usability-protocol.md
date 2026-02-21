# Spec 004 - Onboarding Usability Protocol

## Status
`done`

## Goal
Define a lightweight, repeatable onboarding protocol to verify standard compliance with minimal overhead:
- `/work` as reference baseline
- templates and existing projects against current standards
- explicit check coverage for `$WORKSPACE_ROOT/rss/skills`
- bootstrap procedure readiness for new projects

## Scope
- In scope:
  - `$WORKSPACE_ROOT/AGENTS.md`
  - `$WORKSPACE_ROOT/agent/docs/context.md`
  - `$WORKSPACE_ROOT/agent/docs/arch.md`
  - `$WORKSPACE_ROOT/agent/docs/kb.md`
  - `$WORKSPACE_ROOT/agent/docs/run.md`
  - `$WORKSPACE_ROOT/agent/specs/000-roadmap.md`
  - `$WORKSPACE_ROOT/human-docs/Human-Work-Doc.md`
  - `$WORKSPACE_ROOT/code/_project-template`
  - `$WORKSPACE_ROOT/web/_project-template`
  - `$WORKSPACE_ROOT/code/vast-ai`
  - `$WORKSPACE_ROOT/rss/skills`
- Out of scope:
  - deep functional testing of subproject internals
  - `rss/AGENTS.md` content redesign
  - `CLAUDE.md`

## Problem Statement
Core docs are clearer, but compliance checks are still ad-hoc and not explicitly scoped by project class.
Need a compact, deterministic protocol for regular checks with low context overhead.
Resolved in this spec:
- template baseline was clarified and codified for both `code` and `web`
- template layout was reconciled to `./agent/*` standard

## Operator Decisions (Fixed for this spec)
1. Protocol executor: overseer agent only.
2. Result recording: `$WORKSPACE_ROOT/agent/log.md` only.
3. Pass/fail baseline: required-file presence is sufficient.
4. `/work` is reference baseline; `code` and `web` templates will evolve as separate standards later.

## Planned Work
1. Define minimal checklist for required-file presence checks by target class:
   - `/work` control-plane docs
   - `code`/`web` templates
   - active projects in `code/*` and `web/*`
   - `$WORKSPACE_ROOT/rss/skills`
2. Define deterministic pass/fail output format for log entries.
3. Add concise references in docs where this protocol is invoked.
4. Keep protocol short enough to avoid context noise.
5. Ensure active project checks enforce `agent/specs/000-roadmap.md`.
6. Ensure onboarding check validates `new-project.sh` in dry-run mode for both `code` and `web`.
7. Ensure subproject folder layout checks detect misplaced legacy agent files and confirm required agent file placement.
8. Apply template layout correction for `$WORKSPACE_ROOT/code/_project-template`:
   - remove root `./scripts` and `./src` from template standard
   - add missing standard subfolders under `./agent`
   - align checks/scripts/docs to the updated layout
9. Run the same layout verification pass for `$WORKSPACE_ROOT/web/_project-template` and add required corrections if mismatches are found.

## Implemented
1. Added protocol script:
   - `$WORKSPACE_ROOT/agent/scripts/onboarding-check.sh`
2. Added protocol references to:
   - `$WORKSPACE_ROOT/agent/docs/run.md`
   - `$WORKSPACE_ROOT/AGENTS.md`
   - `$WORKSPACE_ROOT/human-docs/Human-Work-Doc.md`
3. Added protocol script presence check to:
   - `$WORKSPACE_ROOT/agent/scripts/monitor.sh`
4. Updated policy gate for active projects:
   - `$WORKSPACE_ROOT/agent/scripts/policy-check.sh` now requires `agent/specs/000-roadmap.md`
5. Added bootstrap readiness checks:
   - `$WORKSPACE_ROOT/agent/scripts/onboarding-check.sh` now runs deterministic `new-project.sh --dry-run` checks for `code` and `web`
6. Aligned active subproject docs:
   - `$WORKSPACE_ROOT/code/vast-ai/AGENTS.md`
   - `$WORKSPACE_ROOT/code/vast-ai/agent/specs/000-roadmap.md`
   - `$WORKSPACE_ROOT/rss/skills/AGENTS.md` (logging timestamp rule)
7. Added explicit protocol visibility in templates:
   - `$WORKSPACE_ROOT/code/_project-template/AGENTS.md` (`Onboarding Protocol Compatibility`)
   - `$WORKSPACE_ROOT/web/_project-template/AGENTS.md` (`Onboarding Protocol Compatibility`)
   - `$WORKSPACE_ROOT/code/_project-template/agent/docs/run.md` (command matrix + bootstrap validation command)
   - `$WORKSPACE_ROOT/web/_project-template/agent/docs/run.md` (command matrix + bootstrap validation command)
8. Added subproject placement checks:
   - `$WORKSPACE_ROOT/agent/scripts/policy-check.sh` now fails on legacy root agent paths in active projects (`./log.md`, `./specs/000-roadmap.md`)
   - `$WORKSPACE_ROOT/agent/scripts/onboarding-check.sh` now verifies template legacy paths are absent (`./log.md`, `./specs/000-roadmap.md`, `./docs/{arch,kb,run}.md`)
   - `$WORKSPACE_ROOT/agent/scripts/onboarding-check.sh` verifies `$WORKSPACE_ROOT/rss/skills/log.md` is absent in favor of `./agent/log.md`
9. Registered operator-requested correction stage:
   - code template root/agent layout cleanup is now tracked as pending work in this spec
   - dedicated `/web/` parity-check step added as a required follow-up
10. Added canonical template baseline to workspace docs:
   - `$WORKSPACE_ROOT/agent/docs/kb.md` (`Template Standards (code/web)`)
   - `$WORKSPACE_ROOT/agent/docs/context.md` pointer to template standards
   - `$WORKSPACE_ROOT/agent/docs/run.md` template reconciliation steps
11. Executed code/web template reconciliation:
   - moved template operational files from root to `./agent/*`:
     - `./scripts/*` -> `./agent/scripts/*`
     - `./src/.gitkeep` -> `./agent/src/.gitkeep`
   - added missing `./agent/docs/context.md` to both templates
   - updated template `AGENTS.md` and `agent/docs/run.md` to new paths
12. Updated validation scripts for new template standard:
   - `$WORKSPACE_ROOT/agent/scripts/onboarding-check.sh` now requires template `./agent/docs/context.md`, `./agent/scripts/*`, `./agent/src/.gitkeep`, and absence of root `./scripts` and `./src`
   - `$WORKSPACE_ROOT/agent/scripts/policy-check.sh` now supports both legacy and current project entrypoint paths for active projects (`./scripts/*` or `./agent/scripts/*`; `./src/.gitkeep` or `./agent/src/.gitkeep`)

## Protocol Output Format
- Script prints deterministic summary:
  - `onboarding-check: SUCCESS (checked=N, failures=0)` or
  - `onboarding-check: FAIL (checked=N, failures=M)`
- Overseer records result in:
  - `$WORKSPACE_ROOT/agent/log.md`

## Acceptance Criteria
- A documented onboarding protocol exists and is easy to execute.
- Pass/fail signals are explicit and deterministic.
- Protocol output location is fixed to `$WORKSPACE_ROOT/agent/log.md`.
- Required-file checks include templates, existing projects, and `$WORKSPACE_ROOT/rss/skills`.
- Onboarding protocol validates `new-project.sh` dry-run for both `code` and `web`.
- Subproject layout checks verify agent files are placed under `./agent/*` paths as required.
- `$WORKSPACE_ROOT/code/_project-template` root/agent layout is corrected to the updated standard.
- `$WORKSPACE_ROOT/web/_project-template` passes the same layout standard check.
- No major expansion of existing docs; changes stay compact.

## Validation
- `bash $WORKSPACE_ROOT/agent/scripts/build.sh`
- `bash $WORKSPACE_ROOT/agent/scripts/run.sh`
- `bash $WORKSPACE_ROOT/agent/scripts/monitor.sh`
- `bash $WORKSPACE_ROOT/agent/scripts/onboarding-check.sh`
- `bash $WORKSPACE_ROOT/agent/scripts/policy-check.sh`
