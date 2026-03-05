# Workspace AGENTS.md

## Scope
- `__ROOT__/` and subfolders only.
- This file governs workspace maintenance and project bootstrapping.
- Project agents do not load this file; they use their local `AGENTS.md`.

## Core Rules
- Primary objective: maximize agent execution efficiency.
- Keep instructions minimally sufficient; do not add context noise.
- Rule priority: system/developer → user → local AGENTS.md → workspace policy.
- If requirements are unclear or conflicting: ask focused clarification before proceeding.

## Bootstrap
- Create project: `bash __ROOT__/agent/scripts/new-project.sh <code|web> <name> [options]`
- Project name must be `kebab-case`.
- User must explicitly choose domain: `code/` or `web/`.
- New projects use `v3` roadmap layout in `./agent/roadmap/`: `state.md`, `archive.md`, `intent.md`.
- Project-local runtime scripts live in `./agent/scripts/` (`run.sh`, `build.sh`, `monitor.sh`).
- On creation: write initial `agent/log.md` entry and populate `agent/docs/arch.md` facts.

## Validation
- Validate projects: `bash __ROOT__/agent/scripts/policy-check.sh`
- Sync templates: `bash __ROOT__/agent/scripts/template-sync.sh --dry-run`

## Template Sync Rules
- Canonical standard: `__ROOT__/docs/template-standard.yaml`.
- Reference template: `__ROOT__/_project-template/`.
- Shared resources index: `__ROOT__/rss/index.md`.
- Existing projects: add missing required paths/files, delete forbidden paths, do not rewrite existing content without user approval.
- `--dry-run` must be side-effect free.

## Git Safety
- Default branch: `main`.
- Stage explicit paths only. Never `git add -A` or `git add .`.
- Workspace root must never be used as `--repo` for git-publish.

## Context Sync
- Keep `README.md` and `Human-README.md` aligned with actual operating reality.
- Keep `agent/docs/context.md` current for workspace agent context.

## Post-Work Updates
| Trigger | Files to Update |
|---|---|
| policy change | `AGENTS.md`, `agent/docs/context.md`, `agent/log.md` |
| human-facing process change | `Human-README.md`, `agent/log.md` |
| project create/remove/rename | `agent/docs/context.md`, `agent/log.md` |
| template standard change | `docs/template-standard.yaml`, `_project-template/`, `agent/log.md` |
