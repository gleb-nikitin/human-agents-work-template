# Project CLAUDE.md

Claude Code auto-load entry point for this project.

## Non-Claude Agents
- If the current agent is not Claude, do not load this file.
- Exception: load only when the user explicitly asks to review or modify `CLAUDE.md`.

## On Session Start
1. Read `./AGENTS.md` — primary project policy authority.
2. Read `$WORKSPACE_ROOT/rss/AGENTS.md` — global shared policy (always required).

## Claude-Specific
- Log entries must use prefix `Claude:` -> `YYYY-MM-DD HH:MM | Claude: action | result`
