# Workspace Rules in `$WORKSPACE_ROOT` (for humans, EN)

## Daily checklist (short)
- Confirm task runs in the correct zone: `code/` or `web/`.
- Confirm agent scope is correct and does not cross into sibling folders.
- For new projects, use only: `$WORKSPACE_ROOT/agent/scripts/new-project.sh`.
- Confirm new project name is `kebab-case`.
- Confirm required files exist: `AGENTS.md`, `log.md`, `docs/arch.md`, `docs/kb.md`, `docs/run.md`.
- Confirm meaningful actions are logged to `log.md`.
- If agent is blocked or requirements conflict: stop and ask user.
- Any improvement outside explicit request: only after user approval.

## Purpose
- This file explains the full operating model for humans: global rules, local rules, and practical usage.

## Workspace map
- `code/` - local development projects.
- `web/` - web projects oriented for run/deploy.
- `disk/` - large data, caches, temp files; not scanned by default.
- `rss/` - global shared resources + global `AGENTS.md`.
- `logs/` - aggregated log index (secondary source).
- `agent/` - overseer work area; may contain additional internal subfolders.

## Active personalization text (global)
- Scope boundary: read AGENTS.md only in the current working folder and its subfolders; never traverse to parent folders unless explicitly allowed by the user or in-scope AGENTS.md.
- Why: prevents unsanctioned scope expansion and accidental cross-project changes.
- Before work: check whether local AGENTS.md changed; if changed, re-read it and load only required referenced context.
- Why: avoids stale execution rules and context bloat.
- During work: follow the current in-scope AGENTS.md.
- Why: local policy is the direct execution contract.
- If requirements are unclear or conflicting, ask a focused clarification before proceeding.
- Why: reduces wrong actions caused by assumptions.
- After meaningful actions: append a brief factual record to local ./log.md as `YYYY-MM-DD HH:MM | action | result`.
- Why: keeps traceable, factual action history.
- After work: update in-scope AGENTS.md and related context files when facts/processes change.
- Why: keeps policy/context synchronized with reality.
- User communication: Russian.
- Why: consistent communication with workspace owner.
- Documentation/logs/context files: English, concise, LLM-efficient.
- Why: improves maintainability and reuse by agents.
- If blocked and user unavailable: stop execution and log the blocking reason.
- Why: avoids unsafe autonomous guessing.
- Never repeat the same failed action more than twice without new input.
- Why: prevents wasteful loops.
- Before executing scripts or commands, verify that required paths, files, and dependencies exist.
- Why: reduces predictable operational errors.
- Ignore prior assumptions if they contradict the current in-scope AGENTS.md.
- Why: current policy overrides old assumptions.
- Agent may propose improvements but must not execute non-requested improvements without user approval.
- Why: preserves user control over scope expansion.

## Current workspace `AGENTS.md` standard (explained)
- Principle: `AGENTS.md` must contain only minimally sufficient execution rules.
- `## Scope`: defines allowed execution boundary (`$WORKSPACE_ROOT` + subfolders).
- `## Core Rules`: defines strict execution cycle and anti-noise policy for instructions.
- `## Context Loading Priority`: deterministic loading order without arbitrary scanning.
- Always load:
- local in-scope `AGENTS.md`;
- global `$WORKSPACE_ROOT/rss/AGENTS.md`.
- `## Bootstrap Rules`: single deterministic project bootstrap/validation path.
- `## Context Sync`: keep human and agent context synchronized.
- `## Auto Update Agents`: append-only automation update section.

## Project creation practice
- Command: `$WORKSPACE_ROOT/agent/scripts/new-project.sh <code|web> <project-name> [options]`
- Example: `$WORKSPACE_ROOT/agent/scripts/new-project.sh code billing-api --purpose "Billing backend" --stack "go, postgres" --boundaries "api only"`
- Example: `$WORKSPACE_ROOT/agent/scripts/new-project.sh web landing-site --purpose "Marketing site" --stack "nextjs" --boundaries "frontend only" --deployment "docker"`
- `kebab-case` means lowercase letters/numbers with hyphens, no spaces and no `_`.

## Policy self-check (for stable 10/10)
- Command: `$WORKSPACE_ROOT/agent/scripts/policy-check.sh`
- Automatically checks:
- project name is `kebab-case`;
- required files (`AGENTS.md`, `log.md`, `docs/*`, `scripts/*`, `src/.gitkeep`);
- `log.md` line format;
- web project structure (`web/` directory).
- Output is deterministic: `SUCCESS` or `FAIL` with reasons.

## Active Codex automations
- Two recurring automations are defined to reduce manual routine.

### 1) Workspace Policy Check
- Time: daily at `11:30`.
- Purpose: keep workspace policy compliance visible.
- Action: runs policy check and reports status/violations; may append minimal proven policy gaps to `AGENTS.md`.

### 2) Human Project List Sync
- Time: daily at `11:40`.
- Purpose: keep human project index current.
- Action: scans `code/` and `web/` (excluding template names), updates `Human-Project-List.md`, appends one log line.

## Canonical locations
- Workspace policy (LLM, EN): `$WORKSPACE_ROOT/AGENTS.md`
- Global shared policy (LLM, EN): `$WORKSPACE_ROOT/rss/AGENTS.md`
- Overseer compact context (LLM, EN): `$WORKSPACE_ROOT/agent/docs/all-work-doc.md`
- Human quickstart (RU): `$WORKSPACE_ROOT/Human-README-Rus.md`
- Human quickstart (EN): `$WORKSPACE_ROOT/Human-README-Eng.md`
- Human policy (RU): `$WORKSPACE_ROOT/Human-Work-Doc.md`
- Human policy (EN): `$WORKSPACE_ROOT/Human-Work-Doc-Eng.md`
- Human project index: `$WORKSPACE_ROOT/Human-Project-List.md`

## Formal post-work update matrix
- `policy change` -> update `$WORKSPACE_ROOT/AGENTS.md`, `$WORKSPACE_ROOT/agent/docs/all-work-doc.md`, `$WORKSPACE_ROOT/log.md`.
- `human-facing process change` -> update `$WORKSPACE_ROOT/Human-Work-Doc.md`, `$WORKSPACE_ROOT/Human-Work-Doc-Eng.md`, `$WORKSPACE_ROOT/log.md`.
- `project create/remove/rename` -> update `$WORKSPACE_ROOT/Human-Project-List.md`, `$WORKSPACE_ROOT/log.md`.
- `rss resource availability change` -> update `$WORKSPACE_ROOT/rss/AGENTS.md`, relevant `$WORKSPACE_ROOT/rss/docs/*.md`, `$WORKSPACE_ROOT/log.md`.
- `explicit test run` -> by default update only `$WORKSPACE_ROOT/log.md`, unless user explicitly requests doc/context updates.
- Logging granularity: key stages only (`context load`, `execution milestone`, `validation`, `context sync`), no micro-steps.
