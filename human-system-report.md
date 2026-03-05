# System Evaluation Report

## Overall: 7.5/10

## Agent Effectiveness: 8/10

**Strengths:**
- Cold start is fast and deterministic. An agent reads AGENTS.md → roadmap/state.md → active spec and knows exactly what to do. No ambiguity.
- The spec lifecycle (intent → plan → execute → accept → archive) gives agents clear boundaries. They know when to stop, when to ask, and when to proceed.
- Protocol modes (Discuss/Plan/Execute/CTO) map well to real operator commands. The agent never guesses which mode it's in.
- Lazy-load policy prevents context window pollution. Agents load arch.md, run.md, kb.md only when needed.
- Logging format is strict and useful for cross-session continuity.

**Weaknesses:**
- The CTO protocol is ambitious but untested at scale. Multi-agent delegation (CTO spawns Execute agents) depends heavily on the LLM's ability to write self-contained specs — which varies.
- `rss/index.md` as a discovery mechanism is thin. With only one skill (git-publish), it works. At 10+ skills, agents would need semantic search or categorization.
- No error recovery protocol. If an agent fails mid-spec, the next session sees `active_spec` pointing to a partially-done spec with no structured "resume from step N" mechanism. The agent must re-read and infer progress from checked criteria.

## Code Quality: 7/10

**Strengths:**
- Shell scripts are clean, use `set -euo pipefail`, validate inputs, and fail early with clear messages.
- `policy-check.sh` and `template_sync.py` are well-structured and do exactly one job each.
- The PyYAML fallback parser in `template_sync.py` is pragmatic — zero external dependencies for a management tool is the right call.
- `git-publish/scripts/run` has solid safety filtering (secrets, build artifacts, editor temps) and never bulk-stages.

**Weaknesses:**
- `template_sync.py` fallback YAML parser is fragile. It handles the current file but would break on nested structures, multi-line values, or comments in unexpected positions. Fine for now, risk if the standard grows.
- `new-project.sh` uses `sed -i ''` (macOS-only). Breaks on Linux without modification. No portability guard.
- `git-publish/scripts/run` merge-done does `git reset --hard origin/main` — destructive and correct for the workflow, but no pre-check for uncommitted work beyond the `require_clean_worktree` filter. If an excluded file (e.g., `.env`) has important changes, the user gets no warning.
- SKILL.md describes a full prepare→publish pipeline with classifiers and plans, but `scripts/run` implements a simpler direct flow. The spec-vs-implementation gap could confuse agents that read the SKILL.md literally.
- No tests for any script. Policy-check and template-sync are testable and would benefit from a basic test suite.

## Architecture: 8/10

**Strengths:**
- Clean separation: workspace AGENTS.md governs bootstrap, project AGENTS.md governs execution. No cross-contamination.
- Template-driven project creation means every project starts identical and validated.
- The how-to system (`agent/how-to/`) is a good pattern for accumulated knowledge without bloating core docs.

**Weaknesses:**
- `disk/` and `server/` paths are referenced in the template but never created or validated. Phantom infrastructure.
- No mechanism for cross-project coordination. If two projects need to share a decision or dependency, there's no structured path beyond the workspace log.

## Summary

The system solves the right problem: making agent sessions deterministic and resumable from files alone. The spec-driven lifecycle is the strongest part — it prevents agents from drifting and gives operators clear control points. Code is functional and safe but would benefit from portability fixes and basic test coverage. The main risk is the gap between SKILL.md documentation and actual implementation, which could cause agent confusion in edge cases.
