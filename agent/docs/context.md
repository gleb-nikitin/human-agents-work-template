# Workspace Context

## Role of this file
- Startup snapshot for `$WORKSPACE_ROOT`: what this workspace is and what to read first.
- Holds operational context; stable reference data is kept in `$WORKSPACE_ROOT/agent/docs/kb.md`.

## Read Next
1. `$WORKSPACE_ROOT/AGENTS.md`
2. `$WORKSPACE_ROOT/agent/docs/run.md`
3. `$WORKSPACE_ROOT/agent/docs/kb.md`
4. `$WORKSPACE_ROOT/agent/specs/000-roadmap.md`

## Project
- Root: `$WORKSPACE_ROOT`
- Role: overseer workspace that defines standards and keeps project agents aligned.
- Goal: deterministic low-noise environment where new agents can start from files only.

## Host Baseline
- Device: MacBook Pro 16" (`Mac16,5`)
- SoC: Apple M4 Max (`arm64`)
- CPU: 14-core (`10P+4E`)
- GPU: 32-core (Metal)
- ANE: 16-core
- Memory: 36 GB unified memory (no dedicated VRAM)
- Storage: 1 TB NVMe SSD
- OS: macOS Tahoe 26.3 (`25C56`)

## Scope and Boundaries
- In scope: `$WORKSPACE_ROOT` and subfolders.
- Out of scope: parent folders, except explicit read-only allowlist from `$WORKSPACE_ROOT/AGENTS.md`.
- Rule: project agents should work inside their own project scope and use shared resources via `rss`.

## Reference Pointers
- Folder roles and project inventory: `$WORKSPACE_ROOT/agent/docs/kb.md`.
- Template baselines for `code` and `web`: `$WORKSPACE_ROOT/agent/docs/kb.md` (`Template Standards` section).
- Machine-checkable template standards source: `$WORKSPACE_ROOT/docs/templates/README.md`.
- Architecture map and component boundaries: `$WORKSPACE_ROOT/agent/docs/arch.md`.
- Operational commands and validation flow: `$WORKSPACE_ROOT/agent/docs/run.md`.

## Planning Model
- Global roadmap: `$WORKSPACE_ROOT/agent/specs/000-roadmap.md`.
- Stage specs: `$WORKSPACE_ROOT/agent/specs/NNN-kebab-title.md`.
- `000-roadmap.md` contains `Spec Register` for deterministic next spec number.

## Required Files for Startup
- Authoritative list: `$WORKSPACE_ROOT/AGENTS.md` § "Required Files — Authoritative".

## Operational Defaults
- Log format: `YYYY-MM-DD HH:MM | action | result`.
- No backfilled timestamps in `agent/log.md`.
- Use shared `git-publish` skill for pushes from project repos only.
- `.DS_Store` files are macOS-generated and expected; keep ignore-only handling and avoid cleanup sweeps.
