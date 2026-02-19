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
- Before adding policy text to any `AGENTS.md`, evaluate whether it helps execution or creates context noise.
- Do not duplicate personalization defaults in `AGENTS.md`.
- Use `AGENTS.md` for local operational specifics only.
- Do not scan outside allowed scope.
- Avoid reading unrelated files.
- Use deterministic, non-destructive actions.
- Ask user when instructions conflict or are ambiguous.
- Keep outputs concise.
- Keep agent-side context continuously synchronized in `agent/docs/*` while keeping human-side context synchronized in `Human-Work-Doc.md`.

## Required Artifacts in Root
- `AGENTS.md`
- `log.md`
- `Human-README-Rus.md`
- `Human-Work-Doc.md`
- `Human-Project-List.md`
- `agent/docs/all-work-doc.md`

## Canonical Sources
- LLM policy (English): `$WORKSPACE_ROOT/AGENTS.md`
- Global shared policy (English): `$WORKSPACE_ROOT/rss/AGENTS.md`
- Human policy (Russian): `$WORKSPACE_ROOT/Human-Work-Doc.md`

## Bootstrap Templates
- `$WORKSPACE_ROOT/code/_project-template`
- `$WORKSPACE_ROOT/web/_project-template`
- `$WORKSPACE_ROOT/agent/scripts/new-project.sh`
- `$WORKSPACE_ROOT/agent/scripts/policy-check.sh`

## Project Bootstrap Rules
- Project name format: `kebab-case`.
- User must choose destination area: `code/` or `web/`.
- New projects use `AGENTS.md` (uppercase).
- On creation: add initial `log.md` record and initial `docs/arch.md` facts.

## Logging
- Append action records to `$WORKSPACE_ROOT/log.md`.
- Format: `YYYY-MM-DD HH:MM | action | result`.
- Log key stages only: context load, execution milestone, validation, context sync.

## Post-Work Update Matrix
- `policy change` -> update `$WORKSPACE_ROOT/AGENTS.md`, `$WORKSPACE_ROOT/agent/docs/all-work-doc.md`, `$WORKSPACE_ROOT/log.md`.
- `human-facing process change` -> update `$WORKSPACE_ROOT/Human-Work-Doc.md`, `$WORKSPACE_ROOT/log.md`.
- `project create/remove/rename` -> update `$WORKSPACE_ROOT/Human-Project-List.md`, `$WORKSPACE_ROOT/log.md`.
- `rss resource availability change` -> update `$WORKSPACE_ROOT/rss/AGENTS.md`, relevant `$WORKSPACE_ROOT/rss/docs/*.md`, `$WORKSPACE_ROOT/log.md`.
- `explicit test run` -> update only `$WORKSPACE_ROOT/log.md` unless user explicitly requests context/doc updates.

## Current Decisions
- Base workspace directories created: `code`, `web`, `disk`, `rss`, `logs`, `agent/docs`.
- Overseer governance docs initialized.
- `$WORKSPACE_ROOT/agent/` is extensible; overseer agent may create additional internal subfolders when needed.
- Primary subproject templates created for `code` and `web`.
- 2026-02-19: user confirmed and applied compact global personalization text for all agents/projects.
- 2026-02-19: bootstrap policy finalized (kebab-case, explicit code/web choice, uppercase AGENTS.md, mandatory initial log and arch facts).
- 2026-02-19: standard bootstrap script added (`agent/scripts/new-project.sh`).
- 2026-02-19: standard policy validation script added (`agent/scripts/policy-check.sh`).
- 2026-02-19: human docs split into dedicated files (`Human-README-Rus.md`, `Human-Work-Doc.md`, `Human-Project-List.md`).
- 2026-02-19: continuous dual-context maintenance confirmed (human doc + agent docs).
- 2026-02-19: root `AGENTS.md` converted to compact agent-first format with references and append-only `Auto Update Agents` section.
- 2026-02-19: user confirmed that overseer `AGENTS.md` size is unrestricted; compact vs detailed format is chosen by operational convenience.
- 2026-02-19: `rss` cleaned to empty state until shared resources are explicitly introduced.
- 2026-02-19: global `$WORKSPACE_ROOT/rss/AGENTS.md` introduced; agents must read it in addition to local `AGENTS.md`.
- 2026-02-19: `rss/AGENTS.md` intentionally set to empty until explicit global rules are introduced.
- 2026-02-19: initialized `$WORKSPACE_ROOT/rss/docs` with `ssh-keys.md`, `web-storage.md`, `servers.md`; `rss/AGENTS.md` now tracks availability.
- 2026-02-19: performed hard-trim of root/rss AGENTS content to remove non-essential context noise.
- 2026-02-19: created code project `$WORKSPACE_ROOT/code/test-bootstrap` via standard bootstrap script and validated with policy-check.
