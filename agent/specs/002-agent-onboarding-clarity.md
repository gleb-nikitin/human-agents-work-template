# Spec 002 — Agent Onboarding Clarity

## Status
`done`

## Goal
Eliminate structural ambiguities that block a new agent from operating deterministically:
- Triplicated Required Files lists that can drift between files
- Unparseable flat-bullet Post-Work Update Matrix
- Stale completed-spec entry in kb.md Canonical References
- Vague placeholder in AGENTS.md Auto Update Agents section

## Scope
- In scope: `AGENTS.md`, `agent/docs/run.md`, `agent/docs/context.md`, `agent/docs/kb.md`, `agent/specs/000-roadmap.md`
- Out of scope: `CLAUDE.md`, `rss/AGENTS.md`, `human-docs/`, project-level files

---

## Audit Findings

### Clear and sufficient
- Scope boundary (AGENTS.md lines 4–5)
- Core rules, concise and complete
- Logging format and timestamp rule
- Git safety defaults with explicit push commands
- Bootstrap script usage and startup order in run.md

### Issues fixed by this spec

**Issue 1 — Required Files list exists in 3 files (can drift)**
Three copies in AGENTS.md, run.md, and context.md. A new agent cannot determine which is authoritative.

**Issue 2 — Post-Work Update Matrix is flat-bullet, trigger boundaries invisible**
All bullets at same indent level; trigger labels and file targets look identical. Trigger-to-file mapping is not deterministic on first read.

**Issue 3 — Context Loading Priority step 3 is implicit**
Step 3 vaguely says "files explicitly referenced" without pointing to the authoritative section.

**Issue 4 — Auto Update Agents section has empty placeholder behavior**
Header + placeholder comment only; a new agent cannot determine if automation is configured or absent.

**Issue 5 — Stale completed spec in kb.md Canonical References**
Spec 001 listed as canonical reference; not needed on startup.

**Issue 6 — Next spec number is implicit**
Agent must read Spec Register and infer by counting.

---

## Changes

### Change 1 — AGENTS.md: label Required Files as authoritative
- **File:** `$WORKSPACE_ROOT/AGENTS.md` line 7
- **Before:** `## Required Files (Workspace \`/work\`)`
- **After:** `## Required Files — Authoritative (Workspace \`/work\`)`

### Change 2 — AGENTS.md: replace Post-Work Update Matrix with table
- **File:** `$WORKSPACE_ROOT/AGENTS.md` lines 33–51
- **Replace** the flat bullet list with:

```markdown
## Post-Work Update Matrix

| Trigger | Files to Update |
|---|---|
| `policy change` | `AGENTS.md`, `arch.md`, `kb.md`, `run.md`, `agent/log.md` |
| `human-facing process change` | `Human-Work-Doc.md`, `agent/log.md` |
| `project create/remove/rename` | `Human-Project-List.md`, `agent/log.md` |
| `rss resource availability change` | `rss/AGENTS.md`, `rss/docs/*.md`, `agent/log.md` |
| `explicit test run` | `agent/log.md` only (unless user requests doc updates) |
```

### Change 3 — AGENTS.md: reword Context Loading Priority step 3
- **File:** `$WORKSPACE_ROOT/AGENTS.md` lines 65–68
- **Before:** `3. Files explicitly referenced by local or global \`AGENTS.md\`.`
- **After:** `3. Files listed in \`## Required Files — Authoritative\` of local \`AGENTS.md\`.`

### Change 4 — AGENTS.md: replace placeholder in Auto Update Agents section
- **File:** `$WORKSPACE_ROOT/AGENTS.md` lines 94–95
- **Before:** `- Append-only section for automation updates.`
- **After:** `- none configured.`

### Change 5 — run.md: replace duplicate Required Files section with pointer
- **File:** `$WORKSPACE_ROOT/agent/docs/run.md` lines 10–17
- **Replace** 8-line list with:

```markdown
## Required Files
- Authoritative list: `$WORKSPACE_ROOT/AGENTS.md` § "Required Files — Authoritative".
```

### Change 6 — context.md: replace duplicate Required Files section with pointer
- **File:** `$WORKSPACE_ROOT/agent/docs/context.md` lines 45–53
- **Replace** 9-line list with:

```markdown
## Required Files for Startup
- Authoritative list: `$WORKSPACE_ROOT/AGENTS.md` § "Required Files — Authoritative".
```

### Change 7 — kb.md: remove stale spec 001 from Canonical References
- **File:** `$WORKSPACE_ROOT/agent/docs/kb.md` line 8
- **Delete:** `- $WORKSPACE_ROOT/agent/specs/001-work-docs-standardization.md: completed baseline docs-standardization spec.`

### Change 8 — 000-roadmap.md: register spec 002 and add next spec number with maintenance note
- **File:** `$WORKSPACE_ROOT/agent/specs/000-roadmap.md`
- Add to Active Specs: `- 002-agent-onboarding-clarity.md (in_progress)`
- Add to Spec Register:
  ```
  - `002-agent-onboarding-clarity.md` | `in_progress`
  - Next spec number: 003 — update this line whenever a new spec is registered
  ```

### Change 9 — AGENTS.md: compact Logging Granularity list to single line
- **File:** `$WORKSPACE_ROOT/AGENTS.md`
- **Before:**
  - `- Log key stages only:`
  - `- context load`
  - `- execution milestone`
  - `- validation`
  - `- context sync`
- **After:**
  - `- Log key stages only: context load, execution milestone, validation, context sync.`
- Keep:
  - `- Do not log micro-steps.`

---

## Execution Order
1. Register spec 002 in `000-roadmap.md` (Change 8)
2. Apply Changes 1–4 to `AGENTS.md`
3. Apply Change 5 to `run.md`
4. Apply Change 6 to `context.md`
5. Apply Change 7 to `kb.md`
6. Validate: `bash build.sh` → `bash run.sh` → `bash monitor.sh`
7. Append log entries to `agent/log.md` with `spec=$WORKSPACE_ROOT/agent/specs/002-agent-onboarding-clarity.md`
8. Update this spec status to `done`
9. Apply Change 9 and re-run validation

---

## Files to Change (absolute paths)
- `$WORKSPACE_ROOT/agent/specs/002-agent-onboarding-clarity.md` (this file)
- `$WORKSPACE_ROOT/agent/specs/000-roadmap.md`
- `$WORKSPACE_ROOT/AGENTS.md`
- `$WORKSPACE_ROOT/agent/docs/run.md`
- `$WORKSPACE_ROOT/agent/docs/context.md`
- `$WORKSPACE_ROOT/agent/docs/kb.md`
- `$WORKSPACE_ROOT/agent/log.md`

---

## Acceptance Criteria
1. AGENTS.md Required Files section header is labeled as authoritative.
2. run.md and context.md each contain a single pointer to AGENTS.md § Required Files (no duplicate lists).
3. Post-Work Update Matrix in AGENTS.md is a Markdown table — trigger-to-file mapping unambiguous on first read.
4. AGENTS.md Context Loading Priority step 3 references the authoritative section by name (no inline file enumeration).
5. Auto Update Agents section in AGENTS.md explicitly states `- none configured.`
6. kb.md Canonical References contains no completed specs.
7. 000-roadmap.md Spec Register has a `002` entry plus a `Next spec number` line with a maintenance note.
8. All three scripts pass: `build.sh` → SUCCESS, `run.sh` → SUCCESS, `monitor.sh` → SUCCESS.
9. Logging Granularity is compacted to one unambiguous line plus separate micro-step rule.
