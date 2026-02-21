# Workspace AGENTS.md

## Scope
- `$WORKSPACE_ROOT` and subfolders only.
- Never traverse parent folders unless explicitly allowed by user or in-scope `AGENTS.md`.

## Required Files — Authoritative (Workspace)
- `$WORKSPACE_ROOT/AGENTS.md` - workspace policy entrypoint.
- `$WORKSPACE_ROOT/agent/log.md` - append-only factual workspace log.
- `$WORKSPACE_ROOT/agent/docs/context.md` - full workspace context snapshot for no-history startup.
- `$WORKSPACE_ROOT/agent/docs/arch.md` - workspace architecture and boundaries.
- `$WORKSPACE_ROOT/agent/docs/kb.md` - folder roles and canonical project inventory.
- `$WORKSPACE_ROOT/agent/docs/run.md` - startup order and command matrix.
- `$WORKSPACE_ROOT/agent/specs/000-roadmap.md` - global roadmap and priorities.

## Allowed Out-of-Scope Reads (Allowlist)
- Read-only exception: `${HOME}/.ssh/AGENTS.md` (private resource registry for GitHub/SSH auth).
- Only load when a task requires GitHub publishing/auth details (for example `git-publish` skill).

## Core Rules
- Primary objective: maximize agent execution efficiency.
- Primary execution target is `$WORKSPACE_ROOT`.
- Keep instructions minimally sufficient; do not add context noise.
- Before adding text to any `AGENTS.md`, check if it improves execution clarity.
- Before work: if local `AGENTS.md` changed, re-read it and load only required referenced context.
- During work: follow current in-scope `AGENTS.md`.
- Rule priority (highest -> lowest): system/developer instructions -> user instructions -> local in-scope `AGENTS.md` -> workspace/global policy.
- Workspace/global policy provides defaults and must not override local project rules.
- If requirements are unclear/conflicting: ask focused clarification before proceeding.
- After meaningful actions: append to local `./agent/log.md` as `YYYY-MM-DD HH:MM | action | result`.
- After work: update in-scope `AGENTS.md` and related context files when facts/processes change.

## Post-Work Update Matrix

| Trigger | Files to Update |
|---|---|
| `policy change` | `AGENTS.md`, `arch.md`, `kb.md`, `run.md`, `agent/log.md` |
| `human-facing process change` | `human-docs/Human-Work-Doc-Eng.md`, `human-docs/Human-Work-Doc-Rus.md`, `agent/log.md` |
| `project create/remove/rename` | `Human-Project-List.md`, `agent/log.md` |
| `rss resource availability change` | `rss/AGENTS.md`, `rss/docs/*.md`, `agent/log.md` |
| `explicit test run` | `agent/log.md` only (unless user requests doc updates) |

## Logging Granularity
- Log key stages only: `context load`, `execution milestone`, `validation`, `context sync`.
- Do not log micro-steps.

## Logging Timestamp Rule
- `agent/log.md` entries must use the current time at write-time (no backfill/retroactive timestamps).
- Rationale: agents often rely on log ordering (for example, collecting changes since last `git-publish` marker); backfilled timestamps break simple "since last push" workflows.

## Context Loading Priority
1. Local `AGENTS.md` in active folder.
2. Global `$WORKSPACE_ROOT/rss/AGENTS.md` (always).
3. Files listed in `## Required Files — Authoritative` of local `AGENTS.md`.

## Bootstrap Rules
- Use `$WORKSPACE_ROOT/agent/scripts/new-project.sh <code|web> <project-name> [options]`.
- Validate with `$WORKSPACE_ROOT/agent/scripts/policy-check.sh`.
- Project name must be `kebab-case`.
- User must explicitly choose destination: `code/` or `web/`.
- New projects must use `AGENTS.md` (uppercase).
- On creation: add initial factual `agent/log.md` entry and initial `agent/docs/arch.md` facts.

## Onboarding Protocol
- Overseer agent runs onboarding compliance via `$WORKSPACE_ROOT/agent/scripts/onboarding-check.sh`.
- Protocol pass/fail baseline is required-file presence across workspace root, templates, and active projects.
- `$WORKSPACE_ROOT/rss/skills` baseline checks remain structure-focused; missing `AGENTS.md` / `agent/log.md` there is informational, not fail-blocking.
- Record protocol results in `$WORKSPACE_ROOT/agent/log.md`.

## Template Standards Sync
- Canonical standard docs:
  - `$WORKSPACE_ROOT/docs/templates/code-template-standard.yaml`
  - `$WORKSPACE_ROOT/docs/templates/web-template-standard.yaml`
  - `$WORKSPACE_ROOT/docs/templates/template-standards.version`
- Sync entrypoint: `$WORKSPACE_ROOT/agent/scripts/template-sync.sh`.
- If standard docs/version change, run sync apply for impacted domain(s) in the same change cycle:
  - `bash $WORKSPACE_ROOT/agent/scripts/template-sync.sh --domain code --apply`
  - `bash $WORKSPACE_ROOT/agent/scripts/template-sync.sh --domain web --apply`
- Existing projects are sync-safe only:
  - add missing required paths/files
  - delete forbidden paths
  - do not rewrite existing file content without explicit user approval
- Canonical sync report path:
  - `$WORKSPACE_ROOT/agent/reports/template-sync-last-run.md`
- `--dry-run` must be side-effect free (no report/state writes).

## Git Safety Defaults
- Default branch is `main`.
- Use another default branch only if explicitly defined in local in-scope `AGENTS.md`.
- Stage intentionally by explicit paths/files.
- Never use bulk staging (`git add -A`, `git add .`) unless user explicitly instructs it.
- Git publishing is handled via shared skill `git-publish`:
  - Agent must pass repo explicitly via `--repo /absolute/path` to avoid publishing from the wrong directory.
  - The workspace root `$WORKSPACE_ROOT` is not a git repo; never use it as `--repo`.
  - `repo_root` should point to a specific project repo, typically `$WORKSPACE_ROOT/code/<project>` or `$WORKSPACE_ROOT/web/<project>`.
  - If user asks `пуш` / `git push` / `push`: run `$WORKSPACE_ROOT/rss/skills/git-publish/scripts/run pr --repo <repo_root>`.
  - If user asks `пуш без пр` / `push no pr` / `push without pr`: run `$WORKSPACE_ROOT/rss/skills/git-publish/scripts/run no-pr --repo <repo_root>`.

## Context Sync
- Keep `$WORKSPACE_ROOT/human-docs/Human-Work-Doc-Eng.md` and `$WORKSPACE_ROOT/human-docs/Human-Work-Doc-Rus.md` current for human context.
- Keep `$WORKSPACE_ROOT/agent/docs/context.md`, `$WORKSPACE_ROOT/agent/docs/arch.md`, `$WORKSPACE_ROOT/agent/docs/kb.md`, and `$WORKSPACE_ROOT/agent/docs/run.md` current for agent context.

## Auto Update Agents
- none configured.

## Canonical Sources
- LLM policy (English): this file `$WORKSPACE_ROOT/AGENTS.md`
- Global shared policy (English): `$WORKSPACE_ROOT/rss/AGENTS.md`
- LLM full project context (English): `$WORKSPACE_ROOT/agent/docs/context.md`
- LLM project inventory and folder roles (English): `$WORKSPACE_ROOT/agent/docs/kb.md` (`Project Inventory` section)
- LLM architecture/run context (English): `$WORKSPACE_ROOT/agent/docs/arch.md`, `$WORKSPACE_ROOT/agent/docs/run.md`
- Human policy (English): `$WORKSPACE_ROOT/human-docs/Human-Work-Doc-Eng.md`
- Human policy (Russian): `$WORKSPACE_ROOT/human-docs/Human-Work-Doc-Rus.md`
