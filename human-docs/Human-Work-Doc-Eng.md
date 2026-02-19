AGENT NOTICE:
Human reference file.
Load only when explicitly requested by user or referenced by in-scope AGENTS.md.
Not a primary execution context.

1. System Purpose

This workspace is a strictly controlled environment where:
- projects are isolated
- agents are deterministic
- actions are predictable
- behavior is controllable

Core idea:

agent = executor, human = operator

---

2. Workspace Architecture

work/
├── code/     local development projects
├── web/      deploy-oriented projects
├── disk/     large files (not indexed)
├── rss/      global resources and policy
├── agent/    service agents and scripts
├── logs/     aggregated logs
├── human-docs/ human-facing documents

Rule:

each agent works only inside its own folder scope

---

3. Sources of Truth

For agents

local AGENTS.md
rss/AGENTS.md
CLAUDE.md (Claude Code auto-load)

For humans

human-docs/Human-Work-Doc-Rus.md
human-docs/Human-Project-List.md

---

4. Rule Priority

On conflict, apply in this order:

system/developer
-> user
-> local AGENTS.md
-> global workspace defaults

---

5. Agent Behavior Contract (full)

- Scope boundary: read AGENTS.md only in the current working folder and its subfolders; never traverse to parent folders unless explicitly allowed by the user or in-scope AGENTS.md.
- Before work: check whether local AGENTS.md changed; if changed, re-read it and load only required referenced context.
- During work: follow the current in-scope AGENTS.md.
- If requirements are unclear or conflicting, ask a focused clarification before proceeding.
- After meaningful actions: append a brief factual record to local ./log.md as `YYYY-MM-DD HH:MM | action | result`.
- After work: update in-scope AGENTS.md and related context files when facts/processes change.
- User communication: Russian.
- Documentation/logs/context files: English, concise, LLM-efficient.
- If blocked and user unavailable: stop execution and log the blocking reason.
- Never repeat the same failed action more than twice without new input.
- Before executing scripts or commands, verify that required paths, files, and dependencies exist.
- Ignore prior assumptions if they contradict the current in-scope AGENTS.md.
- Agent may propose improvements but must not execute non-requested improvements without user approval.

---

6. Practical Meaning

Agent:
- does not cross project boundaries
- does not invent missing data
- does not do extra work
- does not improve outside request
- does not repeat failed actions
- records meaningful actions

If an agent stops, this is normal.
It means the safety architecture is working.

---

7. Git Policy

By default:
- branch -> main
- staging -> intentional (explicit files)
- push -> only after diff check
- other branch -> only if explicitly defined in local AGENTS.md

Forbidden without explicit permission:

git add -A
git add .

---

8. Operator Commands for Agent Control

These are agreed operator phrases for chat control.
Important: these are not system execution modes.
Mandatory behavior is defined by system/developer directives and in-scope AGENTS.md.

---

planning mode

план

Agent thinks and proposes steps.

---

execution

сделай

Agent executes without extra reasoning output.

---

research mode

исследуй

Agent:
- analyzes
- proposes options
- evaluates risks

No changes are applied.

---

return to fast mode

режим

Agent returns to short, fast execution style.

---

safe push

пуш безопасно

Agent must:
1. check diff
2. check staged diff
3. confirm no unrelated files
4. commit
5. push
6. check CI

---

diagnostics

диагностика

Agent finds root cause and reports conclusions.

---

context refresh

обнови контекст

Agent re-reads rules and structure.

---

emergency stop

стоп

Agent stops immediately.

---

9. Practical Workflow Pattern

Optimal cycle:

план
-> alignment
-> сделай
-> пуш безопасно

For complex tasks:

исследуй
-> solution
-> режим
-> сделай

---

10. Project Creation

agent/scripts/new-project.sh <code|web> <name>

Project name:

kebab-case

Required files:

AGENTS.md
CLAUDE.md
log.md
docs/arch.md
docs/kb.md
docs/run.md

---

11. Automations

---

Policy Check — 11:30

Checks all projects for policy compliance.

If OK -> short report
If FAIL -> list of violations

Does not auto-fix.

---

Project List Sync — 11:40

Updates the human project list.

---

12. Logging

Format:

YYYY-MM-DD HH:MM | action | result

Log only key events.
