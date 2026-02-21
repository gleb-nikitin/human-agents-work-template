#!/usr/bin/env python3
import argparse
import copy
import datetime as dt
import hashlib
import json
import shutil
import sys
from pathlib import Path

EXCLUDE_PROJECT_NAMES = {
    ".git",
    "node_modules",
    ".venv",
    "venv",
    "dist",
    "build",
    ".cache",
    "__pycache__",
    ".pytest_cache",
}


def fail(msg: str) -> None:
    print(f"Error: {msg}", file=sys.stderr)
    sys.exit(1)


def load_json_yaml(path: Path):
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        fail(f"missing standard file: {path}")
    except json.JSONDecodeError as exc:
        fail(f"invalid JSON/YAML in {path}: {exc}")


def validate_rel_path(path: str, field: str) -> None:
    if not isinstance(path, str) or not path:
        fail(f"{field}: path must be non-empty string")
    if path.startswith("/"):
        fail(f"{field}: absolute paths are forbidden: {path}")
    pure = Path(path.rstrip("/"))
    if any(part in {"", ".", ".."} for part in pure.parts):
        fail(f"{field}: invalid relative path: {path}")


def normalize_required_paths(required_paths):
    if not isinstance(required_paths, list):
        fail("required_paths must be a list")
    norm = []
    seen = set()
    for item in required_paths:
        if not isinstance(item, str):
            fail("required_paths entries must be strings")
        validate_rel_path(item, "required_paths")
        is_dir = item.endswith("/")
        rel = item.rstrip("/") if is_dir else item
        key = (rel, is_dir)
        if key in seen:
            continue
        seen.add(key)
        norm.append((rel, is_dir))
    return norm


def normalize_forbidden_paths(forbidden_paths):
    if not isinstance(forbidden_paths, list):
        fail("forbidden_paths must be a list")
    norm = []
    seen = set()
    for item in forbidden_paths:
        if not isinstance(item, str):
            fail("forbidden_paths entries must be strings")
        validate_rel_path(item, "forbidden_paths")
        rel = item.rstrip("/")
        if rel in seen:
            continue
        seen.add(rel)
        norm.append(rel)
    return norm


def normalize_file_templates(file_templates):
    if not isinstance(file_templates, dict):
        fail("file_templates must be an object")
    norm = {}
    for rel, spec in file_templates.items():
        if not isinstance(rel, str):
            fail("file_templates keys must be strings")
        validate_rel_path(rel, "file_templates")
        if isinstance(spec, str):
            norm[rel] = {"type": "literal", "value": spec}
            continue
        if not isinstance(spec, dict):
            fail(f"file_templates[{rel}] must be string or object")
        if "literal" in spec and "template_ref" in spec:
            fail(f"file_templates[{rel}] cannot contain both literal and template_ref")
        if "literal" in spec:
            literal = spec["literal"]
            if not isinstance(literal, str):
                fail(f"file_templates[{rel}].literal must be string")
            norm[rel] = {"type": "literal", "value": literal}
            continue
        if "template_ref" in spec:
            ref = spec["template_ref"]
            if not isinstance(ref, str) or not ref:
                fail(f"file_templates[{rel}].template_ref must be non-empty string")
            validate_rel_path(ref, f"file_templates[{rel}].template_ref")
            norm[rel] = {"type": "template_ref", "value": ref}
            continue
        fail(f"file_templates[{rel}] must include literal or template_ref")
    return norm


def canonical_for_hash(std):
    data = copy.deepcopy(std)
    data["standard_version"] = "__VERSION__"
    return data


def compute_standards_hash(code_std, web_std):
    canonical = {
        "hash_rules": "template-standards-hash-v1",
        "code": canonical_for_hash(code_std),
        "web": canonical_for_hash(web_std),
    }
    payload = json.dumps(canonical, sort_keys=True, separators=(",", ":"))
    return hashlib.sha256(payload.encode("utf-8")).hexdigest()


def resolve_template_content(spec, standards_dir: Path) -> str:
    if spec["type"] == "literal":
        return spec["value"]
    ref_path = standards_dir / spec["value"]
    if not ref_path.is_file():
        fail(f"template_ref missing: {ref_path}")
    return ref_path.read_text(encoding="utf-8")


def list_projects(domain_root: Path):
    projects = []
    if not domain_root.is_dir():
        return projects
    for child in sorted(domain_root.iterdir(), key=lambda p: p.name):
        if not child.is_dir():
            continue
        if child.name == "_project-template":
            continue
        if child.name in EXCLUDE_PROJECT_NAMES:
            continue
        projects.append(child)
    return projects


def load_state(state_file: Path):
    if not state_file.exists():
        return {}
    try:
        data = json.loads(state_file.read_text(encoding="utf-8"))
    except Exception:
        return {}
    return data if isinstance(data, dict) else {}


def write_state(state_file: Path, state: dict):
    state_file.parent.mkdir(parents=True, exist_ok=True)
    state_file.write_text(json.dumps(state, sort_keys=True, indent=2) + "\n", encoding="utf-8")


def build_plan_for_target(std, target: Path, target_kind: str, standards_dir: Path):
    required = normalize_required_paths(std["required_paths"])
    forbidden = normalize_forbidden_paths(std["forbidden_paths"])
    file_templates = normalize_file_templates(std.get("file_templates", {}))
    policy_rules = std.get("policy_rules", {})

    if isinstance(policy_rules, dict):
        scoped_key = "template_forbidden_paths" if target_kind == "template" else "project_forbidden_paths"
        scoped_forbidden = policy_rules.get(scoped_key, [])
        if scoped_forbidden:
            for rel in normalize_forbidden_paths(scoped_forbidden):
                if rel not in forbidden:
                    forbidden.append(rel)

    changes = []
    conflicts = []
    delete_ops = []
    mkdir_ops = set()
    write_ops = {}
    chmod_ops = set()

    for rel in forbidden:
        path = target / rel
        if path.exists() or path.is_symlink():
            delete_ops.append(path)
            changes.append(f"[{target_kind}] delete forbidden path: {path}")

    for rel, is_dir in required:
        path = target / rel
        if is_dir:
            if path.exists() and not path.is_dir():
                conflicts.append(f"[{target_kind}] required directory conflicts with existing file: {path}")
                continue
            if not path.exists():
                mkdir_ops.add(path)
                changes.append(f"[{target_kind}] create required directory: {path}")
            continue

        if path.exists() and path.is_dir():
            conflicts.append(f"[{target_kind}] required file conflicts with existing directory: {path}")
            continue

        if not path.exists():
            mkdir_ops.add(path.parent)
            if rel in file_templates:
                content = resolve_template_content(file_templates[rel], standards_dir)
            else:
                content = ""
            write_ops[path] = content
            changes.append(f"[{target_kind}] create required file: {path}")
            continue

        if path.suffix == ".sh":
            mode = path.stat().st_mode
            if mode & 0o111 == 0:
                chmod_ops.add(path)
                changes.append(f"[{target_kind}] set executable bit for script: {path}")

        if target_kind == "template" and rel in file_templates:
            desired = resolve_template_content(file_templates[rel], standards_dir)
            try:
                current = path.read_text(encoding="utf-8")
            except UnicodeDecodeError:
                conflicts.append(f"[{target_kind}] cannot decode template file as utf-8: {path}")
                continue
            if current != desired:
                write_ops[path] = desired
                changes.append(f"[{target_kind}] overwrite template file to standard: {path}")

    markers = policy_rules.get("agents_required_contains", []) if isinstance(policy_rules, dict) else []
    if markers:
        agents_path = target / "AGENTS.md"
        if agents_path.exists() and agents_path.is_file():
            content = agents_path.read_text(encoding="utf-8")
            for marker in markers:
                if marker not in content:
                    if target_kind == "template" and agents_path in write_ops:
                        desired = write_ops[agents_path]
                        if marker not in desired:
                            conflicts.append(f"[{target_kind}] AGENTS template content missing required marker: {marker}")
                    elif target_kind == "template":
                        conflicts.append(f"[{target_kind}] AGENTS missing required marker: {marker}")

    ops = {
        "delete": sorted(delete_ops, key=lambda p: str(p)),
        "mkdir": sorted(mkdir_ops, key=lambda p: str(p)),
        "write": [(p, write_ops[p]) for p in sorted(write_ops.keys(), key=lambda p: str(p))],
        "chmod": sorted(chmod_ops, key=lambda p: str(p)),
    }
    return changes, conflicts, ops


def apply_ops(ops):
    for path in ops["delete"]:
        if path.is_symlink() or path.is_file():
            path.unlink(missing_ok=True)
        elif path.exists():
            shutil.rmtree(path)
    for path in ops["mkdir"]:
        path.mkdir(parents=True, exist_ok=True)
    for path, content in ops["write"]:
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(content, encoding="utf-8")
        if path.suffix == ".sh":
            path.chmod(0o755)
    for path in ops["chmod"]:
        path.chmod(0o755)


def write_report(report_path: Path, *, status: str, mode: str, domain: str, version: str, version_valid: bool,
                 state_before: str, state_after: str, projects, changes, conflicts, gate_state_mismatch: bool):
    report_path.parent.mkdir(parents=True, exist_ok=True)
    lines = []
    lines.append("# Template Sync Last Run")
    lines.append("")
    lines.append(f"- timestamp: {dt.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    lines.append(f"- status: {status}")
    lines.append(f"- mode: {mode}")
    lines.append(f"- domain: {domain}")
    lines.append(f"- standard version: {version}")
    lines.append(f"- standards hash valid: {'yes' if version_valid else 'no'}")
    lines.append(f"- state hash before: {state_before or 'none'}")
    lines.append(f"- state hash after: {state_after or 'none'}")
    lines.append(f"- gate state mismatch: {'yes' if gate_state_mismatch else 'no'}")
    lines.append("")
    lines.append("## Projects Scanned")
    if projects:
        for p in projects:
            lines.append(f"- {p}")
    else:
        lines.append("- none")
    lines.append("")
    lines.append("## Changes Applied")
    if changes:
        for c in changes:
            lines.append(f"- {c}")
    else:
        lines.append("- none")
    lines.append("")
    lines.append("## Conflicts Requiring User Decision")
    if conflicts:
        for c in conflicts:
            lines.append(f"- {c}")
    else:
        lines.append("- none")
    lines.append("")
    report_path.write_text("\n".join(lines), encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description="Synchronize project templates and projects with standard docs.")
    parser.add_argument("--root", required=True)
    parser.add_argument("--domain", choices=["code", "web"], required=True)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--dry-run", action="store_true")
    mode.add_argument("--apply", action="store_true")
    args = parser.parse_args()

    root = Path(args.root).resolve()
    standards_dir = root / "docs" / "templates"
    report_path = root / "agent" / "reports" / "template-sync-last-run.md"
    state_file = root / "agent" / "reports" / "template-sync-state.json"

    code_std_path = standards_dir / "code-template-standard.yaml"
    web_std_path = standards_dir / "web-template-standard.yaml"
    version_path = standards_dir / "template-standards.version"

    code_std = load_json_yaml(code_std_path)
    web_std = load_json_yaml(web_std_path)

    for std, expected_domain, path in [
        (code_std, "code", code_std_path),
        (web_std, "web", web_std_path),
    ]:
        if not isinstance(std, dict):
            fail(f"standard must be object: {path}")
        for key in ["standard_version", "domain", "required_paths", "forbidden_paths", "file_templates", "policy_rules", "sync_rules"]:
            if key not in std:
                fail(f"missing key '{key}' in {path}")
        if std["domain"] != expected_domain:
            fail(f"domain mismatch in {path}: expected {expected_domain}")
        normalize_required_paths(std["required_paths"])
        normalize_forbidden_paths(std["forbidden_paths"])
        normalize_file_templates(std["file_templates"])

    if not version_path.is_file():
        fail(f"missing version file: {version_path}")
    version_value = version_path.read_text(encoding="utf-8").strip()
    if not version_value:
        fail(f"empty version file: {version_path}")

    computed_hash = compute_standards_hash(code_std, web_std)
    version_valid = (
        version_value == computed_hash
        and code_std.get("standard_version") == version_value
        and web_std.get("standard_version") == version_value
    )

    state = load_state(state_file)
    state_before = state.get(args.domain, "")
    state_after = state_before
    state_mismatch = state_before != version_value

    domain_std = code_std if args.domain == "code" else web_std
    template_dir = root / args.domain / "_project-template"
    domain_root = root / args.domain
    projects = list_projects(domain_root)

    all_changes = []
    all_conflicts = []
    plans = []

    if not template_dir.is_dir():
        all_conflicts.append(f"[template] missing template directory: {template_dir}")
    else:
        changes, conflicts, ops = build_plan_for_target(domain_std, template_dir, "template", standards_dir)
        all_changes.extend(changes)
        all_conflicts.extend(conflicts)
        plans.append(("template", template_dir, ops))

    for project in projects:
        changes, conflicts, ops = build_plan_for_target(domain_std, project, "project", standards_dir)
        all_changes.extend(changes)
        all_conflicts.extend(conflicts)
        plans.append(("project", project, ops))

    if not version_valid:
        all_conflicts.append(
            "standards version mismatch: template-standards.version must equal computed hash and both standard_version fields"
        )

    if args.apply and not all_conflicts:
        for _, _, ops in plans:
            apply_ops(ops)
        state[args.domain] = version_value
        state_after = version_value
        write_state(state_file, state)
        status = "success"
        write_report(
            report_path,
            status=status,
            mode="apply",
            domain=args.domain,
            version=version_value,
            version_valid=version_valid,
            state_before=state_before,
            state_after=state_after,
            projects=[str(p) for p in projects],
            changes=all_changes,
            conflicts=all_conflicts,
            gate_state_mismatch=state_mismatch,
        )
        print(f"template-sync: SUCCESS (domain={args.domain}, mode=apply, changes={len(all_changes)}, conflicts=0)")
        return

    if args.dry_run:
        dry_run_fail_reasons = []
        if all_changes:
            dry_run_fail_reasons.append("pending changes detected")
        if all_conflicts:
            dry_run_fail_reasons.append("conflicts detected")
        if state_mismatch:
            dry_run_fail_reasons.append("standards hash not applied for domain")

        if dry_run_fail_reasons:
            print(
                "template-sync: FAIL "
                f"(domain={args.domain}, mode=dry-run, changes={len(all_changes)}, conflicts={len(all_conflicts)}, "
                f"state_mismatch={'yes' if state_mismatch else 'no'})"
            )
            if state_mismatch:
                print(
                    f"hint: run 'bash {root / 'agent' / 'scripts' / 'template-sync.sh'} --domain {args.domain} --apply'"
                )
            sys.exit(1)

        print(f"template-sync: SUCCESS (domain={args.domain}, mode=dry-run, changes=0, conflicts=0)")
        return

    write_report(
        report_path,
        status="fail",
        mode="apply",
        domain=args.domain,
        version=version_value,
        version_valid=version_valid,
        state_before=state_before,
        state_after=state_after,
        projects=[str(p) for p in projects],
        changes=all_changes,
        conflicts=all_conflicts,
        gate_state_mismatch=state_mismatch,
    )
    print(
        "template-sync: FAIL "
        f"(domain={args.domain}, mode=apply, changes={len(all_changes)}, conflicts={len(all_conflicts)})"
    )
    sys.exit(1)


if __name__ == "__main__":
    main()
