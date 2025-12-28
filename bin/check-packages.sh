#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

pkg_list="$tmp_dir/packages.txt"
missing_list="$tmp_dir/missing.txt"

python - "$root_dir" <<'PY' > "$pkg_list"
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
skip = ("/_archived/", "/modules/ui/desktop-entries/")

sys_re = re.compile(r"environment\.systemPackages\s*=\s*([^\[]*)\[(.*?)\];", re.S)
item_re = re.compile(r"[A-Za-z0-9_][A-Za-z0-9_.-]*")
quoted_re = re.compile(r'(?:pkgs\.)?([A-Za-z0-9_]+)\."([^"]+)"')

pkgs = set()

for path in root.rglob("*.nix"):
    s = str(path)
    if any(x in s for x in skip):
        continue
    text = path.read_text()
    for prelude, block in sys_re.findall(text):
        base_prefix = None
        if "with pkgs.kdePackages" in prelude:
            base_prefix = "kdePackages"
        elif "with pkgs.gnome" in prelude:
            base_prefix = "gnome"
        # strip line comments
        block = re.sub(r"#.*", "", block)
        for prefix, quoted in quoted_re.findall(block):
            if prefix == "pkgs":
                pkgs.add((quoted,))
            else:
                pkgs.add((prefix, quoted))
        block = quoted_re.sub("", block)

        for token in item_re.findall(block):
            if token.endswith("."):
                continue
            if token in {"with", "pkgs", "kdePackages", "gnome"}:
                continue
            if token in {"paisaPkg", "git-sh"} or token.startswith("fenix."):
                continue
            if token.startswith("pkgs."):
                token = token.split(".", 1)[1]
            if "." in token:
                pkgs.add(token)
                continue
            if base_prefix is not None:
                pkgs.add((base_prefix, token))
            else:
                pkgs.add(token)

normalized = set()
for pkg in pkgs:
    if isinstance(pkg, tuple):
        normalized.add(".".join(pkg))
    else:
        normalized.add(pkg)

for pkg in sorted(normalized):
    print(pkg)
PY

pkg_count="$(wc -l < "$pkg_list")"
echo "Checking ${pkg_count} packages..."

if [[ "$pkg_count" -gt 0 ]]; then
  nix_expr="$tmp_dir/check.nix"
  python - "$pkg_list" <<'PY' > "$nix_expr"
import json
import sys

paths = []
with open(sys.argv[1], "r", encoding="utf-8") as f:
    for raw in f:
        token = raw.strip()
        if not token:
            continue
        parts = [p for p in token.split(".") if p]
        if not parts:
            continue
        paths.append(parts)

payload = json.dumps(paths)
print("with import <nixpkgs> {};")
print("let names = builtins.fromJSON ''")
print(payload)
print("''; in builtins.filter (path: !(lib.hasAttrByPath path pkgs)) names")
PY

  nix eval --impure --json --expr "$(cat "$nix_expr")" > "$missing_list"
fi

if [[ -s "$missing_list" && "$(cat "$missing_list")" != "[]" ]]; then
  echo
  echo "Missing packages:"
  python - "$missing_list" <<'PY'
import json
import sys

with open(sys.argv[1], "r", encoding="utf-8") as f:
    items = json.load(f)

def fmt(path):
    return ".".join(path)

for name in sorted({fmt(path) for path in items}):
    print(name)
PY
  exit 1
fi

echo "All package names resolved in nixpkgs."
