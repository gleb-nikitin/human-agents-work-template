# Spec 001 - Work Docs Standardization

## Status
- Spec status: `done`
- Roadmap link: `$WORKSPACE_ROOT/agent/specs/000-roadmap.md` (Priority 1)

## Goal
Bring `$WORKSPACE_ROOT` documentation to a stable, low-noise standard so a new agent can operate without chat-history dependency.

## Scope
- In scope: `$WORKSPACE_ROOT` project-level docs and agent artifacts.
- Out of scope: implementation details inside unrelated subprojects unless required by this spec.

## Confirmed Context (from user)
- `$WORKSPACE_ROOT/rss/skills` is a special shared-skills project with its own GitHub repository.
- `$WORKSPACE_ROOT/code` contains projects executed on this machine (can include remote-server parts).
- `$WORKSPACE_ROOT/web` contains projects with Docker-based OS/web-server runtime and remote sync.
- `$WORKSPACE_ROOT/rss` and `$WORKSPACE_ROOT/disk` are excluded from GitHub publishing, except `$WORKSPACE_ROOT/rss/skills`.
- `$WORKSPACE_ROOT/disk` data layout model:
  - shared: `$WORKSPACE_ROOT/disk/all`
  - per-project: `$WORKSPACE_ROOT/disk/<project-name>`
- Do not add extra cross-project knowledge rules for worker agents beyond existing scope/loading rules.
- Human docs are derivative; agent docs are source of truth.

## TODO
1. [done] Bring `$WORKSPACE_ROOT/agent/docs/*` to self-sufficient startup standard (no chat-history dependency).
2. [done] Define canonical project-inventory artifact for agents (path + one-line purpose for each project).
3. [done] Move/normalize folder-role documentation from non-standard placement into canonical docs structure.
4. [done] Ensure `$WORKSPACE_ROOT/AGENTS.md` and startup docs reference the canonical inventory source.
5. [done] Verify `new-project.sh` output aligns with updated standard and does not add context noise.
6. [done] Verify template docs (`code/_project-template`, `web/_project-template`) align with this standard.
7. [done] After agent-side truth is stable, sync `$WORKSPACE_ROOT/human-docs/Human-Project-List.md`.
8. [done] Remove `$WORKSPACE_ROOT/logs` and drop current aggregated-symlink plan; global log aggregation will be handled later in a dedicated separate spec.
9. [done] Add explicit required-files-by-standard section for `/work` agent docs/policies so a new `/work` agent can start without chat context.

## Acceptance Criteria
- Canonical agent-side project inventory exists and is current.
- Folder-role definitions are stored in canonical docs, not ad-hoc notes.
- New agent can infer `/work` purpose, boundaries, and project landscape from files only.
- Required files by standard are explicitly listed in `/work` docs/policies.
- Human project list is synchronized from agent-side canonical source.

## Risks
- Workspace noise can cause drift if changes are not split into bounded steps.
- Over-documentation can reduce agent efficiency; keep updates compact and operational.
