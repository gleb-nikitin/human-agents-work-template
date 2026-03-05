#!/usr/bin/env python3
"""
Simplified template sync engine.
Compares projects directly against _project-template/ directory.
Reads docs/template-standard.yaml for required/forbidden paths and policy rules.
"""

import argparse
import sys
from pathlib import Path

try:
    import yaml  # type: ignore
except ModuleNotFoundError:
    yaml = None


def _extract_block(lines: list[str], key: str) -> list[str]:
    start = None
    for i, line in enumerate(lines):
        if line.strip() == f"{key}:":
            start = i + 1
            break
    if start is None:
        return []

    block = []
    for line in lines[start:]:
        if not line.strip():
            continue
        if not line.startswith(" "):
            break
        block.append(line.rstrip("\n"))
    return block


def _extract_list_from_block(block: list[str], indent: int = 2) -> list[str]:
    prefix = " " * indent + "- "
    items = []
    for line in block:
        if line.startswith(prefix):
            items.append(line[len(prefix):].strip())
    return items


def _extract_scalar(lines: list[str], key: str) -> str | None:
    prefix = f"{key}:"
    for line in lines:
        stripped = line.strip()
        if stripped.startswith(prefix):
            value = stripped[len(prefix):].strip().strip('"')
            return value
    return None


def _load_standard_without_yaml(standard_path: Path) -> dict:
    lines = standard_path.read_text(encoding="utf-8").splitlines()
    policy_block = _extract_block(lines, "policy_rules")
    sync_block = _extract_block(lines, "sync_rules")

    data = {
        "standard_version": _extract_scalar(lines, "standard_version") or "unknown",
        "template_dir": _extract_scalar(lines, "template_dir") or "_project-template",
        "required_paths": _extract_list_from_block(_extract_block(lines, "required_paths")),
        "forbidden_paths": _extract_list_from_block(_extract_block(lines, "forbidden_paths")),
        "policy_rules": {
            "agents_required_sections": _extract_list_from_block(
                _extract_block(policy_block, "agents_required_sections"), indent=4
            ),
            "agents_must_reference_shared": _extract_list_from_block(
                _extract_block(policy_block, "agents_must_reference_shared"), indent=4
            ),
        },
        "sync_rules": {},
    }

    for line in sync_block:
        if ":" not in line:
            continue
        if line.lstrip().startswith("- "):
            continue
        key, value = line.split(":", 1)
        data["sync_rules"][key.strip()] = value.strip()

    return data


def load_standard(workspace_root: Path) -> dict:
    standard_path = workspace_root / "docs" / "template-standard.yaml"
    if not standard_path.exists():
        print(f"Error: standard file not found: {standard_path}")
        sys.exit(1)
    if yaml is not None:
        with open(standard_path, encoding="utf-8") as f:
            return yaml.safe_load(f)
    return _load_standard_without_yaml(standard_path)


def find_projects(workspace_root: Path, domain: str) -> list[Path]:
    projects = []
    domains = ["code", "web"] if domain == "all" else [domain]
    for d in domains:
        domain_dir = workspace_root / d
        if domain_dir.is_dir():
            for entry in sorted(domain_dir.iterdir()):
                if entry.is_dir() and not entry.name.startswith("_"):
                    projects.append(entry)
    return projects


def check_required_paths(project: Path, required: list[str]) -> list[str]:
    missing = []
    for req in required:
        target = project / req
        if req.endswith("/"):
            if not target.is_dir():
                missing.append(req)
        else:
            if not target.is_file():
                missing.append(req)
    return missing


def check_forbidden_paths(project: Path, forbidden: list[str]) -> list[str]:
    found = []
    for fb in forbidden:
        target = project / fb
        if target.exists():
            found.append(fb)
    return found


def check_policy_rules(project: Path, rules: dict) -> list[str]:
    issues = []
    agents_file = project / "AGENTS.md"
    if not agents_file.exists():
        issues.append("AGENTS.md missing")
        return issues

    content = agents_file.read_text()

    for section in rules.get("agents_required_sections", []):
        if section not in content:
            issues.append(f"AGENTS.md missing section: {section}")

    for ref in rules.get("agents_must_reference_shared", []):
        if ref not in content:
            issues.append(f"AGENTS.md must reference: {ref}")

    return issues


def fix_required_paths(project: Path, template: Path, missing: list[str]) -> list[str]:
    fixed = []
    for req in missing:
        target = project / req
        if req.endswith("/"):
            target.mkdir(parents=True, exist_ok=True)
            fixed.append(f"created dir: {req}")
        else:
            source = template / req
            if source.exists():
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_text(source.read_text())
                if req.endswith(".sh"):
                    target.chmod(0o755)
                fixed.append(f"created from template: {req}")
            else:
                target.parent.mkdir(parents=True, exist_ok=True)
                target.touch()
                fixed.append(f"created empty: {req}")
    return fixed


def fix_forbidden_paths(project: Path, found: list[str]) -> list[str]:
    removed = []
    for fb in found:
        target = project / fb
        if target.is_file():
            target.unlink()
            removed.append(f"removed: {fb}")
        elif target.is_dir():
            import shutil
            shutil.rmtree(target)
            removed.append(f"removed dir: {fb}")
    return removed


def sync_project(project: Path, template: Path, standard: dict, apply: bool) -> dict:
    result = {"project": str(project), "issues": [], "fixes": []}

    required = standard.get("required_paths", [])
    forbidden = standard.get("forbidden_paths", [])
    policy = standard.get("policy_rules", {})

    missing = check_required_paths(project, required)
    found_forbidden = check_forbidden_paths(project, forbidden)
    policy_issues = check_policy_rules(project, policy)

    for m in missing:
        result["issues"].append(f"MISSING: {m}")
    for f in found_forbidden:
        result["issues"].append(f"FORBIDDEN: {f}")
    for p in policy_issues:
        result["issues"].append(f"POLICY: {p}")

    if apply and missing:
        fixes = fix_required_paths(project, template, missing)
        result["fixes"].extend(fixes)
    if apply and found_forbidden:
        fixes = fix_forbidden_paths(project, found_forbidden)
        result["fixes"].extend(fixes)

    return result


def main():
    parser = argparse.ArgumentParser(description="Template sync engine")
    parser.add_argument("--dry-run", action="store_true", help="Report only, no changes")
    parser.add_argument("--apply", action="store_true", help="Fix issues")
    parser.add_argument("--domain", default="all", choices=["code", "web", "all"])
    args = parser.parse_args()

    if not args.dry_run and not args.apply:
        print("Error: specify --dry-run or --apply")
        sys.exit(1)

    script_dir = Path(__file__).resolve().parent
    workspace_root = script_dir.parent.parent
    template_dir = workspace_root / "_project-template"
    standard = load_standard(workspace_root)

    projects = find_projects(workspace_root, args.domain)

    if not projects:
        print(f"No projects found for domain: {args.domain}")
        return

    total_issues = 0
    total_fixes = 0

    for project in projects:
        result = sync_project(project, template_dir, standard, apply=args.apply)
        name = Path(result["project"]).name
        issues = result["issues"]
        fixes = result["fixes"]

        if issues or fixes:
            print(f"\n{name}:")
            for issue in issues:
                print(f"  {issue}")
            for fix in fixes:
                print(f"  FIXED: {fix}")

        total_issues += len(issues)
        total_fixes += len(fixes)

    print(f"\nProjects: {len(projects)}  Issues: {total_issues}  Fixes: {total_fixes}")
    if total_issues > 0 and not args.apply:
        print("Run with --apply to fix.")


if __name__ == "__main__":
    main()
