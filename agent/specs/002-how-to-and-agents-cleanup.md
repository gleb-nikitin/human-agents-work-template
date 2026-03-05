# Spec 002: Template How-To Structure and AGENTS Cleanup

## Status
- Accepted and closed on 2026-03-05.

## Objective
- Align the v3 public template with canonical How-To conventions.
- Remove code-indexer instructions from template `AGENTS.md`.

## Scope
- In scope:
  - `_project-template/AGENTS.md`
  - `_project-template/agent/how-to/*`
  - `_project-template/agent/docs/*` references to how-to paths
  - workspace template validation files (`docs/template-standard.yaml`, `agent/scripts/policy-check.sh`)
- Out of scope:
  - publish/push
  - donor source edits
  - unrelated policy rewrites

## Plan
1. Remove `## Code Search (MCP: code-indexer)` section from template `AGENTS.md`.
2. Add How-To folder and index file: `_project-template/agent/how-to/index.md`.
3. Update template context/docs references to point to `./agent/how-to/index.md` (and `./agent/how-to/*.md` when needed).
4. Add How-To paths to template required checks in:
   - `docs/template-standard.yaml`
   - `agent/scripts/policy-check.sh`
5. Run template validation checks and review resulting diff.

## Acceptance Criteria
- [x] Template `AGENTS.md` no longer contains Code Search block.
- [x] `_project-template/agent/how-to/index.md` exists with concise usage guidance.
- [x] `kb.md` and related docs reference the new How-To location.
- [x] Template standard and policy-check require How-To path(s).
- [x] `policy-check --domain code` passes.

## Risks
- Validation drift if required paths are updated in one checker but not the other.
