# Spec 003 - Documentation Partition Audit

## Status
`done`

## Goal
Critically evaluate and normalize `/work` documentation partition so file roles are explicit, discoverable, and low-noise for a new agent without chat history.

## Scope
- In scope:
  - `$WORKSPACE_ROOT/AGENTS.md`
  - `$WORKSPACE_ROOT/agent/docs/context.md`
  - `$WORKSPACE_ROOT/agent/docs/arch.md`
  - `$WORKSPACE_ROOT/agent/docs/kb.md`
  - `$WORKSPACE_ROOT/agent/docs/run.md`
  - `$WORKSPACE_ROOT/agent/specs/000-roadmap.md`
  - `$WORKSPACE_ROOT/human-docs/Human-Work-Doc.md`
- Out of scope:
  - subproject internal docs
  - `rss/AGENTS.md`
  - `CLAUDE.md`

## Problem Statement
Current docs are usable, but role boundaries between `context.md` and `kb.md` are not explicit enough for strict no-context startup.  
Need to verify documentation granularity is sufficient but not excessive.

## Audit Questions
1. Does each core file state its unique role in 1-2 lines?
2. Can a new agent tell what is unique in `context.md` vs `kb.md` without reading both fully?
3. Is current file granularity optimal, or are any files over-split/under-split?
4. Is there any duplicated operational content that adds context noise?

## Planned Changes (after approval)
1. Add/normalize a concise `Role of this file` block in each core doc.
2. Add explicit cross-file navigation (`read next`) where needed.
3. Remove/trim overlapping sections that do not add unique value.
4. Keep docs compact; avoid adding explanatory prose beyond operational value.
5. Sync a concise human-facing file-role map in `Human-Work-Doc.md` derived from agent-side source of truth.

## Acceptance Criteria
- Each core file has explicit role definition (1-2 lines).
- `context.md` and `kb.md` have clearly non-overlapping primary purposes.
- A new agent can find startup path and file responsibilities without chat context.
- No unnecessary duplication remains across `context.md`, `kb.md`, `arch.md`, `run.md`.
- Result keeps current standard structure and does not add context noise.
- Human doc includes a concise `/work` file-role map consistent with agent docs.

## Audit Result
1. `Role of this file` added to `context.md`, `arch.md`, `kb.md`, `run.md` (passed).
2. `context.md` now serves startup snapshot + pointers; stable reference data is centralized in `kb.md` (passed).
3. Cross-file `Read Next` navigation added in core docs (passed).
4. Human-facing file-role map synced in `Human-Work-Doc.md` and aligned with agent-side source (passed).
5. Validation commands passed: `build.sh`, `run.sh`, `monitor.sh` (passed).

## Validation
- `bash $WORKSPACE_ROOT/agent/scripts/build.sh`
- `bash $WORKSPACE_ROOT/agent/scripts/run.sh`
- `bash $WORKSPACE_ROOT/agent/scripts/monitor.sh`
