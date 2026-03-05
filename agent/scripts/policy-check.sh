#!/usr/bin/env bash
set -euo pipefail

# Validate projects against template standard.
# Usage: bash agent/scripts/policy-check.sh [--domain code|web|all]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEMPLATE_DIR="$WORKSPACE_ROOT/_project-template"
STANDARD_FILE="$WORKSPACE_ROOT/docs/template-standard.yaml"

DOMAIN="all"
if [ "${1:-}" = "--domain" ] && [ -n "${2:-}" ]; then
  DOMAIN="$2"
fi

ERRORS=0
CHECKED=0

check_project() {
  local project_dir="$1"
  local project_name
  project_name=$(basename "$project_dir")

  # Skip template directories
  if [[ "$project_name" == _* ]]; then
    return
  fi

  CHECKED=$((CHECKED + 1))
  echo "Checking: $project_dir"

  # Check kebab-case naming
  if [[ ! "$project_name" =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?$ ]]; then
    echo "  ERROR: project name '$project_name' is not kebab-case"
    ERRORS=$((ERRORS + 1))
  fi

  # Required files
  local required_files=(
    "AGENTS.md"
    "CLAUDE.md"
    "agent/log.md"
    "agent/docs/context.md"
    "agent/docs/arch.md"
    "agent/docs/kb.md"
    "agent/docs/run.md"
    "agent/scripts/run.sh"
    "agent/scripts/build.sh"
    "agent/scripts/monitor.sh"
    "agent/specs/000-spec-template.md"
    "agent/roadmap/state.md"
    "agent/roadmap/archive.md"
    "agent/roadmap/intent.md"
  )

  for req in "${required_files[@]}"; do
    if [ ! -f "$project_dir/$req" ]; then
      echo "  MISSING: $req"
      ERRORS=$((ERRORS + 1))
    fi
  done

  # Forbidden files
  if [ -f "$project_dir/log.md" ]; then
    echo "  FORBIDDEN: log.md (should be agent/log.md)"
    ERRORS=$((ERRORS + 1))
  fi
  if [ -f "$project_dir/agent/specs/000-roadmap.md" ]; then
    echo "  FORBIDDEN: agent/specs/000-roadmap.md (use roadmap/ dir)"
    ERRORS=$((ERRORS + 1))
  fi
  if [ -d "$project_dir/agent/specs/roadmap" ]; then
    echo "  FORBIDDEN: agent/specs/roadmap/ (use agent/roadmap/)"
    ERRORS=$((ERRORS + 1))
  fi

  # Policy rules: AGENTS.md must contain required sections
  local agents_file="$project_dir/AGENTS.md"
  if [ -f "$agents_file" ]; then
    if ! grep -q '## Shared Policy' "$agents_file"; then
      echo "  POLICY: AGENTS.md missing '## Shared Policy' section"
      ERRORS=$((ERRORS + 1))
    fi
    if ! grep -q '## Cold Start' "$agents_file"; then
      echo "  POLICY: AGENTS.md missing '## Cold Start' section"
      ERRORS=$((ERRORS + 1))
    fi
    if ! grep -q 'rss/AGENTS.md' "$agents_file"; then
      echo "  POLICY: AGENTS.md must reference rss/AGENTS.md"
      ERRORS=$((ERRORS + 1))
    fi
  fi

  # Log format check
  local log_file="$project_dir/agent/log.md"
  if [ -f "$log_file" ]; then
    if ! grep -q 'category | action | result' "$log_file"; then
      echo "  WARN: agent/log.md header may not match 4-field format"
    fi
  fi

  echo "  OK"
}

# Scan domains
if [[ "$DOMAIN" == "all" || "$DOMAIN" == "code" ]]; then
  if [ -d "$WORKSPACE_ROOT/code" ]; then
    for dir in "$WORKSPACE_ROOT/code"/*/; do
      [ -d "$dir" ] && check_project "$dir"
    done
  fi
fi

if [[ "$DOMAIN" == "all" || "$DOMAIN" == "web" ]]; then
  if [ -d "$WORKSPACE_ROOT/web" ]; then
    for dir in "$WORKSPACE_ROOT/web"/*/; do
      [ -d "$dir" ] && check_project "$dir"
    done
  fi
fi

# Also validate the template itself
echo ""
echo "Checking template: $TEMPLATE_DIR"
for req in AGENTS.md CLAUDE.md agent/log.md agent/docs/context.md agent/docs/arch.md agent/docs/kb.md agent/docs/run.md agent/scripts/run.sh agent/scripts/build.sh agent/scripts/monitor.sh agent/specs/000-spec-template.md agent/roadmap/state.md agent/roadmap/archive.md agent/roadmap/intent.md; do
  if [ ! -f "$TEMPLATE_DIR/$req" ]; then
    echo "  TEMPLATE MISSING: $req"
    ERRORS=$((ERRORS + 1))
  fi
done
echo "  OK"

echo ""
echo "Checked $CHECKED projects. Errors: $ERRORS"
if [ "$ERRORS" -gt 0 ]; then
  exit 1
fi
