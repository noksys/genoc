#!/usr/bin/env nix-shell
#!nix-shell -p rsync git -i bash

if [[ "$EUID" -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

get_channel_url() {
  local name="$1"
  nix-channel --list | awk -v n="$name" '$1==n {print $2}'
}

channel_version_from_url() {
  local url="$1"
  if [[ "$url" =~ nixos-([0-9]{2}\.[0-9]{2})$ ]]; then
    echo "${BASH_REMATCH[1]}"
    return 0
  fi
  echo ""
  return 1
}

version_gt() {
  local a="$1" b="$2"
  [[ -z "$a" || -z "$b" ]] && return 1
  # Compare like 25.11 vs 24.11
  [[ "$(printf '%s\n' "$a" "$b" | sort -V | tail -n1)" == "$a" ]] && [[ "$a" != "$b" ]]
}

ensure_channel() {
  local name="$1"
  local expected_url="$2"
  local current_url
  current_url="$(get_channel_url "$name")"

  if [[ -z "$current_url" ]]; then
    echo "Adding channel: $name -> $expected_url"
    nix-channel --add "$expected_url" "$name"
    return 0
  fi

  if [[ "$current_url" != "$expected_url" ]]; then
    if [[ "$name" == "nixos" ]]; then
      local expected_ver current_ver
      expected_ver="$(channel_version_from_url "$expected_url")"
      current_ver="$(channel_version_from_url "$current_url")"
      if [[ -n "$current_ver" && -n "$expected_ver" ]] && version_gt "$current_ver" "$expected_ver"; then
        echo "Your nixos channel ($current_ver) is newer than Genoc expects ($expected_ver)."
        echo "Please update Genoc before installing. Aborting to avoid downgrade."
        exit 1
      fi
    fi

    echo "Channel '$name' points to:"
    echo "  current:  $current_url"
    echo "  expected: $expected_url"
    read -r -p "Replace it with expected? [y/N] " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
      nix-channel --add "$expected_url" "$name"
    else
      echo "Keeping current channel for $name."
    fi
  fi
}

timestamp=$(date +%Y%m%d_%H%M%S)
backup_dir="/etc/nixos/backup/${timestamp}"

mkdir -p "$backup_dir"
rsync -aP --exclude 'backup' -l /etc/nixos/ $backup_dir

echo "Backup created at: $backup_dir"

cd /etc/nixos

if [[ ! -d "./genoc" ]]; then
  git clone https://github.com/noksys/genoc.git
  cd genoc
  git submodule update --init --recursive
  cd -
fi

ensure_channel "nixos" "https://nixos.org/channels/nixos-25.11"
ensure_channel "nixos-hardware" "https://github.com/NixOS/nixos-hardware/archive/master.tar.gz"
ensure_channel "nixos-unstable" "https://nixos.org/channels/nixos-unstable"

ln -sfn ./genoc/configuration.nix

if [[ ! -f ./custom_machine.nix ]]; then
  cp ./genoc/custom_machine.example.nix ./custom_machine.nix
else
  echo "custom_machine.nix already exists; leaving as is."
fi

if [[ ! -f ./custom_vars.nix ]]; then
  cp ./genoc/custom_vars.example.nix ./custom_vars.nix
else
  echo "custom_vars.nix already exists; leaving as is."
fi

cd -

echo
echo "*** ATTENTION! ***"
echo
echo "Please, read README to know how to use my personal public binary cache."
echo
echo "Now, edit the files:"
echo
echo "/etc/nixos/custom_machine.nix"
echo "/etc/nixos/custom_vars.nix"
echo
echo "to make your custom adjustments, and then run:"
echo
echo "nixos-rebuild switch"
echo
