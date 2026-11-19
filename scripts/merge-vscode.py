import json
from pathlib import Path
import sys


def unique_keys(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError()
        result[key] = value
    return result


def merge(current, incoming):
    for key, value in incoming.items():
        if isinstance(value, dict) and isinstance(current.get(key), dict):
            merge(current[key], value)
        else:
            current[key] = value


source, target, css = sys.argv[1:]
try:
    target = Path(target)
    appearance = json.loads(Path(source).read_text(encoding="utf-8"))
    # shortcut: strict JSON preserves settings values, use manual merge for JSONC with comments or trailing commas.
    current = (
        json.loads(target.read_text(encoding="utf-8"), object_pairs_hook=unique_keys)
        if target.exists()
        else {}
    )
    if not isinstance(current, dict):
        raise ValueError()
    imports = current.get("vscode_vibrancy.imports", [])
    if not isinstance(imports, list) or not all(isinstance(item, str) for item in imports):
        raise ValueError()
    merge(current, appearance)
    if css not in imports:
        imports.append(css)
    current["vscode_vibrancy.imports"] = imports
    print(json.dumps(current, indent=4, ensure_ascii=False, allow_nan=False))
except (OSError, ValueError):
    sys.exit("Expected a readable VS Code settings file with a strict JSON object and a valid imports array.")
