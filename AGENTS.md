# Workspace AGENTS.md

## Scope
- `$WORKSPACE_ROOT` and subfolders only.
- Never traverse parent folders unless explicitly allowed by user or in-scope `AGENTS.md`.

## Install Note
- On a new machine, set `WORKSPACE_ROOT` to the absolute path of this repository.
- Replace `$WORKSPACE_ROOT` placeholders in commands with that path before execution.

## Required Files — Authoritative
- `$WORKSPACE_ROOT/AGENTS.md`
- `$WORKSPACE_ROOT/agent/log.md`
- `$WORKSPACE_ROOT/agent/docs/context.md`
- `$WORKSPACE_ROOT/agent/docs/arch.md`
- `$WORKSPACE_ROOT/agent/docs/kb.md`
- `$WORKSPACE_ROOT/agent/docs/run.md`
- `$WORKSPACE_ROOT/agent/specs/000-roadmap.md`

## Core Rules
- Primary objective: maximize agent execution efficiency.
- Keep instructions minimally sufficient; do not add context noise.
- Before work: if local `AGENTS.md` changed, re-read it and load only required referenced context.
- During work: follow current in-scope `AGENTS.md`.
- Rule priority (highest -> lowest): system/developer -> user -> local in-scope `AGENTS.md` -> workspace/global policy.
- If requirements are unclear/conflicting: ask focused clarification before proceeding.
- After meaningful actions: append to local `./agent/log.md` as `YYYY-MM-DD HH:MM | action | result`.
- After work: update in-scope `AGENTS.md` and related context files when facts/processes change.

## Logging Rules
- Log key stages only: `context load`, `execution milestone`, `validation`, `context sync`.
- Do not log micro-steps.
- `agent/log.md` timestamps must be current write-time only (no backfill/retroactive timestamps).

## Context Loading Priority
1. Local `AGENTS.md` in active folder.
2. Global `$WORKSPACE_ROOT/rss/AGENTS.md` (always).
3. Files listed in `## Required Files — Authoritative`.

## Onboarding and Standards
- Bootstrap projects with `$WORKSPACE_ROOT/agent/scripts/new-project.sh <code|web> <project-name> [options]`.
- Validate workspace policy with `$WORKSPACE_ROOT/agent/scripts/policy-check.sh`.
- Validate onboarding readiness with `$WORKSPACE_ROOT/agent/scripts/onboarding-check.sh`.
- Template standards source:
  - `$WORKSPACE_ROOT/docs/templates/code-template-standard.yaml`
  - `$WORKSPACE_ROOT/docs/templates/web-template-standard.yaml`
  - `$WORKSPACE_ROOT/docs/templates/template-standards.version`
- Sync entrypoint: `$WORKSPACE_ROOT/agent/scripts/template-sync.sh`.

## Publication Export Rules
- Before each public export cycle, append an `export checkpoint` line to `$WORKSPACE_ROOT/agent/log.md` with current stage and source baseline.
- Publication summary must be derived from active/completed specs in `$WORKSPACE_ROOT/agent/specs/` (not from chat memory).
- For spec-driven exports, include `spec=<path>` in meaningful log entries.

## Post-Work Update Matrix
- `policy change` -> update `AGENTS.md`, `agent/docs/*`, `agent/log.md`.
- `human-facing process change` -> update `human-docs/Human-Work-Doc-Rus.md`, `human-docs/Human-Work-Doc-Eng.md`, `agent/log.md`.
- `project create/remove/rename` -> update `human-docs/Human-Project-List.md`, `agent/log.md`.
- `rss resource availability change` -> update `rss/AGENTS.md`, relevant `rss/docs/*.md`, `agent/log.md`.
- `explicit test run` -> update `agent/log.md` only unless user requests extra doc updates.

## Git Safety Defaults
- Default branch is `main`.
- Stage intentionally by explicit paths/files.
- Never use bulk staging (`git add -A`, `git add .`) unless user explicitly instructs it.

## Canonical Sources
- LLM policy: this file `$WORKSPACE_ROOT/AGENTS.md`
- Global shared policy: `$WORKSPACE_ROOT/rss/AGENTS.md`
- Agent startup context: `$WORKSPACE_ROOT/agent/docs/context.md`
- Agent architecture: `$WORKSPACE_ROOT/agent/docs/arch.md`
- Agent knowledge base: `$WORKSPACE_ROOT/agent/docs/kb.md`
- Agent runbook: `$WORKSPACE_ROOT/agent/docs/run.md`
