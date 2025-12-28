#!/usr/bin/env bash
set -euo pipefail

root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

pkg_list="$tmp_dir/packages.txt"
missing_list="$tmp_dir/missing.txt"

rg --glob '!_archived/**' --glob '!modules/ui/desktop-entries/**' -n "environment.systemPackages" "$root_dir" \
  | cut -d: -f1 \
  | sort -u \
  | while read -r file; do
      # Extract the package list block
      awk '
        /environment\\.systemPackages/ { inlist=1; next }
        inlist && /\\];/ { inlist=0; exit }
        inlist { print }
      ' "$file"
    done \
  | sed -E 's/#.*$//' \
  | tr -s '[:space:]' ' ' \
  | tr ' ' '\n' \
  | sed -E 's/^pkgs\\.//; s/^kdePackages\\.//; s/^gnome\\.//;' \
  | grep -E '^[A-Za-z0-9_][A-Za-z0-9_\\.-]*$' \
  | grep -vE '^(with|pkgs|kdePackages|gnome)$' \
  | sort -u > "$pkg_list"

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
