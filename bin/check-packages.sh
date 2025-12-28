#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

pkg_list="$tmp_dir/packages.txt"
missing_list="$tmp_dir/missing.txt"

python - <<'PY' "$root_dir" > "$pkg_list"
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
skip = ("/_archived/", "/modules/ui/desktop-entries/")

sys_re = re.compile(r"environment\\.systemPackages\\s*=\\s*[^\\[]*\\[(.*?)\\];", re.S)
item_re = re.compile(r"[A-Za-z0-9_][A-Za-z0-9_.-]*")

pkgs = set()

for path in root.rglob("*.nix"):
    s = str(path)
    if any(x in s for x in skip):
        continue
    text = path.read_text()
    for block in sys_re.findall(text):
        # strip line comments
        block = re.sub(r"#.*", "", block)
        for token in item_re.findall(block):
            if token.startswith(("pkgs.", "kdePackages.", "gnome.")):
                token = token.split(".", 1)[1]
            if token in {"with", "pkgs", "kdePackages", "gnome"}:
                continue
            pkgs.add(token)

for pkg in sorted(pkgs):
    print(pkg)
PY

echo "Checking $(wc -l < "$pkg_list") packages..."

while read -r pkg; do
  if ! nix eval --impure --raw --expr "with import <nixpkgs> {}; builtins.hasAttr \"${pkg}\" pkgs" >/dev/null 2>&1; then
    echo "$pkg" >> "$missing_list"
    continue
  fi
  has_attr="$(nix eval --impure --raw --expr "with import <nixpkgs> {}; builtins.hasAttr \"${pkg}\" pkgs")"
  if [[ "$has_attr" != "true" ]]; then
    echo "$pkg" >> "$missing_list"
  fi
done < "$pkg_list"

if [[ -s "$missing_list" ]]; then
  echo
  echo "Missing packages:"
  sort -u "$missing_list"
  exit 1
fi

echo "All package names resolved in nixpkgs."
