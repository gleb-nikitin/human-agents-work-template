# Release Notes

## 2026-02-19
- Added Claude agent support across the template:
  - root `CLAUDE.md`
  - project-template `CLAUDE.md` files for `code` and `web`
  - policy validation now checks `CLAUDE.md` presence
- Added `claude.command` launcher script.
- `claude.command` now exports terminal Claude chat sessions to markdown logs in:
  - `$WORKSPACE_ROOT/human-docs/claude-chats/`
- Moved human policy/index docs into `human-docs/` and updated all canonical references.
