# Spec 003: Clean-Session Public Readiness Audit and Human Docs Refresh

## Objective
- Run a clean-session, no-history validation pass of `repo/`.
- Decide whether the repository is ready for public GitHub publication.
- Assess overall project quality (structure, policy consistency, onboarding usability).
- Refresh human-facing documentation to match actual v3 behavior.

## Execution Mode
- Intended executor: a fresh agent session started by the user.
- This spec is the only required task contract for that session.

## Scope
- In scope:
  - full repository audit for public release readiness
  - quality assessment with explicit verdict and rationale
  - updates to human-facing docs (`README.md`, `Human-README.md`, and `AGENTS-install.md` if required by real workflow)
  - consistency fixes between docs, policy, and actual file structure
- Out of scope:
  - push/publish to GitHub
  - changes to donor source outside `repo/`
  - non-requested refactors unrelated to readiness/doc quality

## Inputs
- `./AGENTS.md`
- `./agent/specs/000-roadmap.md`
- this spec file
- current repository tree under `./`

## Required Audit Pass
1. Structure and policy consistency:
   - verify `AGENTS.md`, template files, scripts, and standard checks align with v3 layout.
2. Public-safety scan:
   - personal absolute paths
   - donor identifiers
   - Cyrillic text
   - secrets/token-like data
   - remote-access policy placement consistency
3. Validation commands:
   - `bash agent/scripts/policy-check.sh --domain code`
   - `bash agent/scripts/template-sync.sh --domain code --dry-run`
4. Human-doc usability review:
   - verify quick-start commands are executable and path-correct
   - verify terminology matches real v3 files (roadmap paths, how-to location, script locations)
   - remove stale or contradictory guidance

## Deliverables
1. `agent/docs/public-readiness-audit.md`
   - summary verdict: `ready` / `ready-with-notes` / `not-ready`
   - blockers (if any) with exact file references
   - quality scorecard (policy consistency, docs quality, install flow, validation health)
2. Updated human docs:
   - `README.md`
   - `Human-README.md`
   - `AGENTS-install.md` (create or update only if needed for actual v3 operator flow)
3. Updated spec checklist and logs:
   - checkboxes in this spec
   - `agent/log.md`

## Acceptance Criteria
- [x] `agent/docs/public-readiness-audit.md` exists with clear verdict and evidence-backed findings.
- [x] All blocking public-safety findings are resolved or explicitly documented as blockers.
- [x] Human docs reflect actual v3 behavior and current file layout.
- [x] Quick-start commands in human docs map to existing scripts/paths.
- [x] `policy-check --domain code` passes.
- [x] `template-sync --domain code --dry-run` executes successfully.
- [x] No contradictions remain between `AGENTS.md`, template docs, and human-facing docs.

## Reporting Format
- Findings must include severity:
  - `critical` — blocks public publish
  - `major` — should be fixed before publish
  - `minor` — acceptable for publish, track as follow-up
- Each finding should include:
  - file path
  - issue summary
  - recommended fix
  - status (`fixed` / `open`)

## Risks
- Clean-session agent may miss historical intent; this spec must remain source of truth.
- Human docs can drift from policy quickly if commands/paths change without synchronized updates.
