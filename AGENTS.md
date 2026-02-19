# Workspace AGENTS.md

## Install Note
- On a new machine, set `WORKSPACE_ROOT` to the absolute path of this repository.
- Replace `$WORKSPACE_ROOT` placeholders in commands with that path before execution.

## Scope
- `$WORKSPACE_ROOT` and subfolders only.
- Never traverse parent folders unless explicitly allowed by user or in-scope `AGENTS.md`.

## Core Rules
- Primary objective: maximize agent execution efficiency.
- Keep instructions minimally sufficient; do not add context noise.
- Before adding text to any `AGENTS.md`, check if it improves execution clarity.
- Before work: if local `AGENTS.md` changed, re-read it and load only required referenced context.
- During work: follow current in-scope `AGENTS.md`.
- If requirements are unclear/conflicting: ask focused clarification before proceeding.
- After meaningful actions: append to local `./log.md` as `YYYY-MM-DD HH:MM | action | result`.
- After work: update in-scope `AGENTS.md` and related context files when facts/processes change.

## Post-Work Update Matrix
- `policy change`
- update `$WORKSPACE_ROOT/AGENTS.md`
- update `$WORKSPACE_ROOT/agent/docs/all-work-doc.md`
- update `$WORKSPACE_ROOT/log.md`
- `human-facing process change`
- update `$WORKSPACE_ROOT/Human-Work-Doc-Rus.md`
- update `$WORKSPACE_ROOT/Human-Work-Doc-Eng.md`
- update `$WORKSPACE_ROOT/log.md`
- `project create/remove/rename`
- update `$WORKSPACE_ROOT/Human-Project-List.md`
- update `$WORKSPACE_ROOT/log.md`
- `rss resource availability change`
- update `$WORKSPACE_ROOT/rss/AGENTS.md`
- update relevant `$WORKSPACE_ROOT/rss/docs/*.md`
- update `$WORKSPACE_ROOT/log.md`
- `explicit test run`
- update only `$WORKSPACE_ROOT/log.md` unless user explicitly requests context/doc updates

## Logging Granularity
- Log key stages only:
- `context load`
- `execution milestone`
- `validation`
- `context sync`
- Do not log micro-steps.

## Context Loading Priority
1. Local `AGENTS.md` in active folder.
2. Global `$WORKSPACE_ROOT/rss/AGENTS.md` (always).
3. Files explicitly referenced by local or global `AGENTS.md`.

## Bootstrap Rules
- Use `$WORKSPACE_ROOT/agent/scripts/new-project.sh <code|web> <project-name> [options]`.
- Validate with `$WORKSPACE_ROOT/agent/scripts/policy-check.sh`.
- Project name must be `kebab-case`.
- User must explicitly choose destination: `code/` or `web/`.
- New projects must use `AGENTS.md` (uppercase).
- On creation: add initial factual `log.md` entry and initial `docs/arch.md` facts.

## Context Sync
- Keep `$WORKSPACE_ROOT/Human-Work-Doc-Rus.md` current for human context.
- Keep `$WORKSPACE_ROOT/Human-Work-Doc-Eng.md` current for human context (EN).
- Keep `$WORKSPACE_ROOT/agent/docs/all-work-doc.md` current for agent context.

## Auto Update Agents
- Append-only section for automation updates.

## Canonical Sources
- LLM policy (English): this file `$WORKSPACE_ROOT/AGENTS.md`
- Global shared policy (English): `$WORKSPACE_ROOT/rss/AGENTS.md`
- LLM compact context (English): `$WORKSPACE_ROOT/agent/docs/all-work-doc.md`
- Human policy (Russian): `$WORKSPACE_ROOT/Human-Work-Doc-Rus.md`
- Human policy (English): `$WORKSPACE_ROOT/Human-Work-Doc-Eng.md`
