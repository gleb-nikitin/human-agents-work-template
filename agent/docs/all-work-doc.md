# all-work-doc

## Purpose
Canonical compact workspace agreement for the overseer agent in `$WORKSPACE_ROOT`.

## Workspace Model
- `rss` = global shared resources and global `AGENTS.md`
- `code` + `web` = execution spaces
- `disk` = data-only storage
- `logs` = aggregated history index
- `AGENTS.md` = policy authority in scope

## Operating Rules
- Primary objective: optimize agent effectiveness by keeping instructions minimally sufficient.
- Rule priority (highest -> lowest): system/developer instructions -> user instructions -> local in-scope `AGENTS.md` -> workspace/global policy.
- Workspace/global policy provides defaults and must not override local project rules.
- Before adding policy text to any `AGENTS.md`, evaluate whether it helps execution or creates context noise.
- Do not duplicate personalization defaults in `AGENTS.md`.
- Use `AGENTS.md` for local operational specifics only.
- Do not scan outside allowed scope.
- Avoid reading unrelated files.
- Use deterministic, non-destructive actions.
- Ask user when instructions conflict or are ambiguous.
- Keep outputs concise.
- Keep agent-side context synchronized in `agent/docs/*` and human-side context synchronized in `human-docs/*`.

## Required Artifacts in Root
- `AGENTS.md`
- `CLAUDE.md`
- `human-docs/Human-Work-Doc-Rus.md`
- `human-docs/Human-Work-Doc-Eng.md`
- `human-docs/Human-Project-List.md`
- `agent/docs/all-work-doc.md`

## Canonical Sources
- LLM policy (English): `$WORKSPACE_ROOT/AGENTS.md`
- Claude Code auto-load (English): `$WORKSPACE_ROOT/CLAUDE.md`
- Global shared policy (English): `$WORKSPACE_ROOT/rss/AGENTS.md`
- Human policy (RU): `$WORKSPACE_ROOT/human-docs/Human-Work-Doc-Rus.md`
- Human policy (EN): `$WORKSPACE_ROOT/human-docs/Human-Work-Doc-Eng.md`

## Bootstrap Templates
- `$WORKSPACE_ROOT/code/_project-template`
- `$WORKSPACE_ROOT/web/_project-template`
- `$WORKSPACE_ROOT/agent/scripts/new-project.sh`
- `$WORKSPACE_ROOT/agent/scripts/policy-check.sh`

## Project Bootstrap Rules
- Project name format: `kebab-case`.
- User must choose destination area: `code/` or `web/`.
- New projects include `AGENTS.md` and baseline `CLAUDE.md`.
- On creation: add initial `log.md` record and initial `docs/arch.md` facts.

## Git Safety Defaults
- Default branch is `main`.
- Use another default branch only if explicitly defined in local in-scope `AGENTS.md`.
- Stage intentionally by explicit paths/files.
- Never use bulk staging (`git add -A`, `git add .`) unless user explicitly instructs it.

## Logging
- Append action records to local `log.md`.
- Format: `YYYY-MM-DD HH:MM | action | result`.
- Log key stages only: context load, execution milestone, validation, context sync.

## Post-Work Update Matrix
- `policy change` -> update `$WORKSPACE_ROOT/AGENTS.md`, `$WORKSPACE_ROOT/agent/docs/all-work-doc.md`, local `log.md`.
- `human-facing process change` -> update `$WORKSPACE_ROOT/human-docs/Human-Work-Doc-Rus.md`, `$WORKSPACE_ROOT/human-docs/Human-Work-Doc-Eng.md`, local `log.md`.
- `project create/remove/rename` -> update `$WORKSPACE_ROOT/human-docs/Human-Project-List.md`, local `log.md`.
- `rss resource availability change` -> update `$WORKSPACE_ROOT/rss/AGENTS.md`, relevant `$WORKSPACE_ROOT/rss/docs/*.md`, local `log.md`.
- `explicit test run` -> update only local `log.md` unless user explicitly requests doc/context updates.
