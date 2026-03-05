# Human README

Use this repository as the root of a workspace where you and your agents work under the same rules, scripts, and project structure.

This system works best when the human acts as the operator and the agent acts as the executor.

## Start here
1. Choose where the workspace should live.
2. Ask your agent to read `AGENTS.md`.
3. Let the agent run `bash agent/scripts/install-workspace.sh /absolute/workspace/root`.
4. Review `rss/AGENTS.md` (the shared policy for all projects).
5. Start creating projects under `code/` or `web/`.

## How to work with agents

Use clear operator-style commands.

- `let's discuss intents`
  General direction. You explain what you want overall. No immediate implementation.
- `let's discuss the next spec`
  When the next version needs clear scope and boundaries.
- `explore`
  The agent researches, analyzes options, and identifies risks. Nothing is changed.
- `plan`
  The agent proposes a concrete plan. Nothing is executed yet.
- `do it`
  The agent executes the agreed task end-to-end.
- `launch an agent to write the spec, review it, then launch an agent to implement it`
  Planning and implementation highly automated. Multi-agent support must be enabled.
- `commit`
  Save a safe local checkpoint.
- `push`
  Controlled git publishing flow: prepare/review first, publish second.
- `push without PR`
  Direct push to the default branch (only when explicitly requested).
- `merge done`
  Post-merge cleanup after PR is merged into `main`.
- `refresh context`
  The agent re-reads rules and current files.
- `stop`
  The agent stops immediately.

## How to choose the right mode

- Small task: `do it`
- Unclear task: `explore`
- Task that needs sequencing: `plan`
- Task that changes rules, templates, or multiple projects: start with a spec

## Git and safety

- `commit` is local and safe.
- `push` is safer than a manual `git push`.
- If you do not want changes yet, say `explore` or `plan`.
- If a task touches shared rules or templates, review carefully before publishing.

## Main folders

- `_project-template/` — unified project scaffold
- `_project-template/agent/scripts/` — project-local runtime command entrypoints
- `rss/` — shared policy and skills for all projects
- `agent/` — workspace docs, scripts, roadmap, and log
- `docs/` — template standard
- `code/` — code project roots
- `web/` — web project roots
- `disk/` — local files not tracked in git
