# Workspace Roadmap (/work)

## Role
- Keep `$WORKSPACE_ROOT` as a reference execution environment for human + agents.
- Keep rules deterministic, concise, and low-noise.
- Ensure new projects bootstrap with the same standards and low friction.

## Planning Model
- Horizon: continuous, no fixed end date.
- This file keeps global goals and priorities only.
- Implementation details live in stage specs: `$WORKSPACE_ROOT/agent/specs/NNN-kebab-title.md`.
- Roadmap item statuses: `todo`, `in_progress`, `blocked`, `done`, `deferred`, `dropped`.
- Spec document statuses: `draft`, `approved`, `in_progress`, `done`, `superseded`.

## Current Priorities
1. [done] Make `/work` agent documentation self-sufficient, so chat history is not required.
2. [done] Align `/work` documentation with current workspace standards.
3. [done] Validate `new-project` bootstrap against current standards and low-noise startup quality.
4. [done] Maintain a full subproject registry with concise purpose for each project.
5. [done] Keep human-facing docs synchronized with agent-facing operating reality.
6. [done] Audit and optimize documentation partition for role clarity and low-noise navigation.
7. [done] Define and standardize a lightweight onboarding usability protocol with checks for templates, existing projects, and `/rss/skills`.
8. [todo] Evolve `code` and `web` templates as separate standards (both distinct from `/work` and from each other) based on their runtime and delivery differences.
9. [done] Add guardrails so standards are always propagated to templates and required target paths in the same change cycle.
10. [done] Make validation gates portable and read-only in dry-run mode (no check-time side effects).

## Active Specs
- None.

## Spec Register
- `001-work-docs-standardization.md` | `done`
- `002-agent-onboarding-clarity.md` | `done`
- `003-doc-partition-audit.md` | `done`
- `004-onboarding-usability-protocol.md` | `done`
- `005-template-standard-propagation-guardrails.md` | `done`
- `006-validation-gates-readonly-portability.md` | `done`
- Next spec number: 007 — update this line whenever a new spec is registered

## Execution Rules
- First bring `/work` itself to standard; then supervise subprojects.
- Split work into bounded stages to prevent context overload from workspace size/noise.
- Keep agent files compact and operational; remove or avoid non-essential content.

## Spec and Log Linking
- For implementation work, `agent/log.md` entries must include the active spec path.
- PR descriptions must include the active spec path.

## Workspace Definition of Done
- A new agent can understand `/work` from in-scope files without chat context.
- Subprojects follow standards and are easy for a new agent to start safely.
- Agent context files contain only operationally relevant information.

## Ownership
- Roadmap is updated by the overseer agent after discussion with the user.
- New `NNN` specs are created from roadmap decisions.
