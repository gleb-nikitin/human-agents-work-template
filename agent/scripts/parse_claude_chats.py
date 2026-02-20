#!/usr/bin/env python3
"""
parse_claude_chats.py

Convert Claude conversation JSONL files to numbered CSV files.
Tracks processed files to avoid reprocessing on subsequent runs.

Usage:
    python3 parse_claude_chats.py

Defaults:
    WORKSPACE_ROOT is inferred as the repository root (two levels up from this script).
    INPUT_DIR points to ~/.claude/projects/<workspace-slug>.
    OUTPUT_DIR points to $WORKSPACE_ROOT/human-docs/claude-chats.
    Set WORKSPACE_ROOT env var to override inference.
"""

import csv
import json
import os
import sys
from datetime import datetime, timezone
from pathlib import Path

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

def _workspace_slug(workspace_root: Path) -> str:
    normalized = workspace_root.resolve().as_posix().strip("/")
    return f"-{normalized.replace('/', '-')}" if normalized else ""


WORKSPACE_ROOT = Path(
    os.environ.get("WORKSPACE_ROOT", Path(__file__).resolve().parents[2].as_posix())
).resolve()
INPUT_DIR = (Path.home() / ".claude" / "projects" / _workspace_slug(WORKSPACE_ROOT)).as_posix()
OUTPUT_DIR = (WORKSPACE_ROOT / "human-docs" / "claude-chats").as_posix()
STATE_FILE = (WORKSPACE_ROOT / "human-docs" / "claude-chats" / "parse_state.json").as_posix()

# Subdirectory names (within INPUT_DIR) to skip entirely
SKIP_DIRS = {"memory"}

# ---------------------------------------------------------------------------
# State helpers
# ---------------------------------------------------------------------------

def load_state(state_path: str) -> dict:
    """Load the JSON state file. Returns empty state on missing or corrupt file."""
    if not os.path.isfile(state_path):
        return {"processed": {}}
    try:
        with open(state_path, "r", encoding="utf-8") as fh:
            data = json.load(fh)
        if not isinstance(data.get("processed"), dict):
            raise ValueError("unexpected format")
        return data
    except Exception as exc:
        print(f"WARNING: Could not read state file ({exc}). Starting fresh.", file=sys.stderr)
        return {"processed": {}}


def save_state(state: dict, state_path: str) -> None:
    """Atomically save state: write to a tmp file then rename."""
    tmp_path = state_path + ".tmp"
    with open(tmp_path, "w", encoding="utf-8") as fh:
        json.dump(state, fh, indent=2, ensure_ascii=False)
    os.replace(tmp_path, state_path)


# ---------------------------------------------------------------------------
# File discovery
# ---------------------------------------------------------------------------

def discover_jsonl_files(input_dir: str, skip_dirs: set) -> list:
    """
    Walk input_dir recursively, return sorted list of absolute paths to *.jsonl files.
    Prunes any subdirectory whose name is in skip_dirs.
    """
    found = []
    for root, dirs, files in os.walk(input_dir):
        dirs[:] = [d for d in dirs if d not in skip_dirs]
        for filename in files:
            if filename.endswith(".jsonl"):
                found.append(os.path.join(root, filename))
    return sorted(found)


def rel_key(filepath: str, input_dir: str) -> str:
    """
    Return a stable tracking key: relative path without .jsonl extension.
    Example: 'aade028c-.../subagents/agent-a95f6c5'
    """
    rel = os.path.relpath(filepath, input_dir)
    if rel.endswith(".jsonl"):
        rel = rel[:-6]
    return rel


# ---------------------------------------------------------------------------
# Content extraction (claude.command style)
# ---------------------------------------------------------------------------

def extract_user_text(content) -> str | None:
    """Extract text from user message content. Only plain strings are used."""
    if isinstance(content, str):
        text = content.strip()
        return text if text else None
    # List content (tool results etc.) — skip entirely to keep output clean
    return None


def extract_assistant_text(content) -> str | None:
    """Extract only text blocks from assistant message content list."""
    if not isinstance(content, list):
        return None
    parts = []
    for block in content:
        if not isinstance(block, dict):
            continue
        if block.get("type") == "text":
            t = block.get("text", "").strip()
            if t:
                parts.append(t)
        # thinking, tool_use, tool_result — skip entirely
    result = "".join(parts).strip()
    return result if result else None


def parse_record(record: dict) -> tuple | None:
    """
    Parse a single JSON record.
    Returns (date_str, role, message_text) or None if the row should be skipped.
    """
    rec_type = record.get("type")
    if rec_type not in ("user", "assistant"):
        return None

    timestamp_raw = record.get("timestamp", "")
    try:
        dt = datetime.fromisoformat(timestamp_raw.replace("Z", "+00:00"))
        date_str = dt.strftime("%Y-%m-%d %H:%M:%S UTC")
    except (ValueError, AttributeError):
        date_str = timestamp_raw

    msg = record.get("message", {})
    if not isinstance(msg, dict):
        return None

    content = msg.get("content", "")

    if rec_type == "user":
        text = extract_user_text(content)
        if not text:
            return None
        message_text = f"**Human:** {text}"
    else:  # assistant
        text = extract_assistant_text(content)
        if not text:
            return None
        message_text = f"**Assistant:** {text}"

    return date_str, rec_type, message_text


# ---------------------------------------------------------------------------
# File processor
# ---------------------------------------------------------------------------

def process_file(jsonl_path: str, session_id: str, csv_path: str) -> int:
    """
    Read a JSONL file and write rows to csv_path.
    Returns number of rows written.
    CSV columns: date, session_id, role, message
    """
    rows = []
    with open(jsonl_path, "r", encoding="utf-8") as fh:
        for line_num, line in enumerate(fh, start=1):
            line = line.strip()
            if not line:
                continue
            try:
                record = json.loads(line)
            except json.JSONDecodeError as exc:
                print(
                    f"WARNING: {os.path.basename(jsonl_path)} line {line_num}: "
                    f"malformed JSON ({exc}), skipping.",
                    file=sys.stderr,
                )
                continue
            parsed = parse_record(record)
            if parsed is None:
                continue
            date_str, role, message_text = parsed
            rows.append([date_str, session_id, role, message_text])

    with open(csv_path, "w", newline="", encoding="utf-8") as fh:
        writer = csv.writer(fh)
        writer.writerow(["date", "session_id", "role", "message"])
        writer.writerows(rows)

    return len(rows)


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main() -> None:
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    state = load_state(STATE_FILE)
    processed = state["processed"]

    all_files = discover_jsonl_files(INPUT_DIR, SKIP_DIRS)

    new_files = [
        fp for fp in all_files
        if rel_key(fp, INPUT_DIR) not in processed
    ]

    if not new_files:
        print("No new JSONL files found. Nothing to do.")
        return

    print(f"Found {len(new_files)} new file(s) to process.")

    existing_numbers = [
        int(v["output_file"].split("-")[0])
        for v in processed.values()
        if v.get("output_file", "") and v["output_file"].split("-")[0].isdigit()
    ]
    next_num = max(existing_numbers, default=0) + 1

    today = datetime.now(timezone.utc).strftime("%Y-%m-%d")

    results = []
    for jsonl_path in new_files:
        key = rel_key(jsonl_path, INPUT_DIR)
        session_id = os.path.basename(jsonl_path).replace(".jsonl", "")
        output_filename = f"{next_num}-{today}.csv"
        output_path = os.path.join(OUTPUT_DIR, output_filename)

        print(f"  Processing: {key} -> {output_filename} ...", end=" ", flush=True)
        try:
            rows_written = process_file(jsonl_path, session_id, output_path)
        except Exception as exc:
            print(f"ERROR: {exc}", file=sys.stderr)
            results.append((key, output_filename, 0, str(exc)))
            next_num += 1
            continue

        now_utc = datetime.now(timezone.utc).strftime("%Y-%m-%d %H:%M:%S UTC")
        processed[key] = {
            "output_file": output_filename,
            "processed_at": now_utc,
            "rows_written": rows_written,
        }
        save_state(state, STATE_FILE)

        print(f"{rows_written} rows")
        results.append((key, output_filename, rows_written, None))
        next_num += 1

    print()
    print("=" * 60)
    print(f"Summary: {len(new_files)} file(s) processed")
    print("-" * 60)
    for key, out_file, rows, err in results:
        name = os.path.basename(key)
        if err:
            print(f"  FAILED  {name:45s} -> {out_file}  ERROR: {err}")
        else:
            print(f"  OK      {name:45s} -> {out_file}  ({rows} rows)")
    print("=" * 60)


if __name__ == "__main__":
    main()
