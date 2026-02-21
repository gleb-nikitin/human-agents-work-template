# Public Export Summary

## Scope
- This summary captures public-safe workspace updates exported from private `/work` into this template.
- Source of truth for change intent: `$WORKSPACE_ROOT/agent/specs/`.

## Export Checkpoint
- Previous export baseline: PR #2 merged (`fix unknown remote HEAD handling for git-publish`).
- Current export stage: specs-and-standards synchronization for template publication.

## Included Spec Summaries
- `001-work-docs-standardization.md`
  - Standardized workspace agent layout around `agent/docs`, `agent/specs`, and `agent/log.md`.
  - Unified required files and startup behavior for no-chat-history initialization.
- `002-agent-onboarding-clarity.md`
  - Clarified onboarding intent, reduced duplicated guidance, and improved required-files readability.
- `003-doc-partition-audit.md`
  - Partitioned docs by role (`context`, `arch`, `kb`, `run`) and aligned agent/human source-of-truth boundaries.
- `004-onboarding-usability-protocol.md`
  - Added deterministic onboarding protocol checks covering workspace, templates, active projects, and `rss/skills`.
  - Standardized file-placement validation and readiness bootstrap checks.
- `005-template-standard-propagation-guardrails.md`
  - Added machine-checkable template standards under `docs/templates/*`.
  - Added template sync gate tooling (`agent/scripts/template-sync.sh`, `template_sync.py`) with state/report artifacts.
  - Enforced synchronization workflow when standards change.

## Public-Safe Notes
- Absolute private paths from source specs/docs are placeholderized to `$WORKSPACE_ROOT`.
- Runtime-private report history is not exported; `agent/reports/*` remains template-safe.
