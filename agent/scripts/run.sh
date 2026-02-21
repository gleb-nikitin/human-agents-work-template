#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
POLICY_CHECK="$SCRIPT_DIR/policy-check.sh"

if [[ ! -f "$POLICY_CHECK" ]]; then
  echo "Error: missing required script: $POLICY_CHECK" >&2
  exit 1
fi

bash "$POLICY_CHECK"
