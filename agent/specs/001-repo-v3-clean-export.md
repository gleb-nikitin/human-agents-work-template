# Spec 001: Repo v3 Clean Export Pass

## Status
- Accepted and closed on 2026-03-05.

## Objective
- Produce a review-ready public `repo/` export using deterministic workflow:
  - copy from donor
  - sanitize in place
  - full-text audit
  - publish preview update

## Scope
- In scope:
  - `repo/` content cleanup for public export readiness
  - template/docs/script consistency checks
  - `workspace/publish-preview.md` refresh for current state
- Out of scope:
  - push/publish to GitHub
  - donor source modifications
  - non-approved expansion of export allowlist

## Inputs and Constraints
- Donor source path: from `public/work/config.yaml`
- Allowed export categories: configured allowlist and agreed public scope only
- Sanitization baseline:
  - replace personal absolute roots with `__PATH_PLACEHOLDER_CHANGE_ME__/`
  - no personal identifiers
  - no Cyrillic/personalization leftovers
  - remote-access policy references only in intended shared-policy location

## Execution Plan
1. Rebuild `repo/` from donor using explicit allowlist flow.
2. Apply sanitization rules in place.
3. Run full-text audits across all files:
   - personal paths
   - donor identifiers
   - Cyrillic text
   - remote-access policy references outside allowed file
   - unresolved placeholder tails
4. Resolve findings and repeat audits until clean.
5. Validate template baseline:
   - `agent/scripts` runtime entrypoints in template
   - standards/policy-check alignment to v3 roadmap layout
6. Update `workspace/publish-preview.md` with current summaries and blockers.
7. Prepare local commit (no push).

## Acceptance Criteria
- [x] `repo/` contains only approved public-export scope.
- [x] No personal absolute paths remain in export files.
- [x] No donor-specific identifiers remain in public-facing text.
- [x] No Cyrillic text remains in export files.
- [x] Remote-access policy references appear only in approved shared-policy location.
- [x] Template checks pass for current v3 structure.
- [x] `workspace/publish-preview.md` reflects current repo state and proposed commit message.
- [ ] Local git status is clean after commit preparation.

## Risks
- Donor updates may reintroduce stale private tails.
- Legacy v2/v3 structural drift can break policy checks if not aligned per pass.
