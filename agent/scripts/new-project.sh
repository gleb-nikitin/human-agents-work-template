#!/usr/bin/env bash
set -euo pipefail

# Create a new project from the unified template.
# Usage: bash agent/scripts/new-project.sh <code|web> <kebab-case-name> [options]
#
# Options:
#   --purpose <text>      Project purpose (replaces __PROJECT_PURPOSE__)
#   --stack <text>        Tech stack (added to arch.md)
#   --boundaries <text>   Scope boundaries (added to arch.md)
#   --deployment <text>   Deployment target (web only, added to arch.md)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
WORKSPACE_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
TEMPLATE_DIR="$WORKSPACE_ROOT/_project-template"

if [ $# -lt 2 ]; then
  echo "Usage: $0 <code|web> <kebab-case-name> [options]"
  echo ""
  echo "Options:"
  echo "  --purpose <text>"
  echo "  --stack <text>"
  echo "  --boundaries <text>"
  echo "  --deployment <text>  (web only)"
  exit 1
fi

DOMAIN="$1"
PROJECT_NAME="$2"
shift 2

# Validate domain
if [[ "$DOMAIN" != "code" && "$DOMAIN" != "web" ]]; then
  echo "Error: domain must be 'code' or 'web', got '$DOMAIN'"
  exit 1
fi

# Validate kebab-case
if [[ ! "$PROJECT_NAME" =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?$ ]]; then
  echo "Error: project name must be kebab-case, got '$PROJECT_NAME'"
  exit 1
fi

# Parse options
PURPOSE=""
STACK=""
BOUNDARIES=""
DEPLOYMENT=""

while [ $# -gt 0 ]; do
  case "$1" in
    --purpose) PURPOSE="$2"; shift 2 ;;
    --stack) STACK="$2"; shift 2 ;;
    --boundaries) BOUNDARIES="$2"; shift 2 ;;
    --deployment) DEPLOYMENT="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

PROJECT_DIR="$WORKSPACE_ROOT/$DOMAIN/$PROJECT_NAME"
PROJECT_PATH="$PROJECT_DIR"

if [ -d "$PROJECT_DIR" ]; then
  echo "Error: project directory already exists: $PROJECT_DIR"
  exit 1
fi

echo "Creating $DOMAIN project: $PROJECT_NAME"
echo "  Path: $PROJECT_DIR"

# Copy template
cp -R "$TEMPLATE_DIR" "$PROJECT_DIR"

# Replace placeholders
find "$PROJECT_DIR" -type f \( -name '*.md' -o -name '*.yaml' -o -name '*.sh' \) | while read -r file; do
  sed -i '' "s|__PROJECT_NAME__|${PROJECT_NAME}|g" "$file"
  sed -i '' "s|__PROJECT_PATH__|${PROJECT_PATH}|g" "$file"
  sed -i '' "s|__PROJECT_AREA__|${DOMAIN}|g" "$file"
  if [ -n "$PURPOSE" ]; then
    sed -i '' "s|__PROJECT_PURPOSE__|${PURPOSE}|g" "$file"
  fi
done

# Apply optional arch.md content
ARCH_FILE="$PROJECT_DIR/agent/docs/arch.md"
if [ -n "$PURPOSE" ]; then
  sed -i '' "/## Purpose/{n;s|^- TBD$|- ${PURPOSE}|;}" "$ARCH_FILE"
fi
if [ -n "$STACK" ]; then
  sed -i '' "/## Stack/{n;s|^- TBD$|- ${STACK}|;}" "$ARCH_FILE"
fi
if [ -n "$BOUNDARIES" ]; then
  sed -i '' "/## Boundaries/{n;s|^- TBD$|- ${BOUNDARIES}|;}" "$ARCH_FILE"
fi

# Web-specific additions
if [ "$DOMAIN" = "web" ]; then
  mkdir -p "$PROJECT_DIR/web"
  cat > "$PROJECT_DIR/web/README.md" <<'WEBEOF'
# Web Component

Web-specific files and assets for this project.
WEBEOF

  if [ -n "$DEPLOYMENT" ]; then
    echo "" >> "$ARCH_FILE"
    echo "## Deployment" >> "$ARCH_FILE"
    echo "- $DEPLOYMENT" >> "$ARCH_FILE"
  fi
fi

# Set executable bits on scripts
find "$PROJECT_DIR" -name '*.sh' -exec chmod +x {} \;

# Write initial log entry
TIMESTAMP=$(date '+%Y-%m-%d %H:%M')
echo "${TIMESTAMP} | milestone | project bootstrap | created ${DOMAIN} project ${PROJECT_NAME}" >> "$PROJECT_DIR/agent/log.md"

echo ""
echo "Project created: $PROJECT_DIR"
echo "Next: cd $PROJECT_DIR && read AGENTS.md"
