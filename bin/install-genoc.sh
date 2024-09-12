#!/usr/bin/env nix-shell
#!nix-shell -p zip git -i bash

if [[ "$EUID" -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

timestamp=$(date +%Y%m%d_%H%M%S)

backup_dir="/etc/nixos/backup"
backup_file="${backup_dir}/${timestamp}_nixconf_backup.zip"

mkdir -p "$backup_dir"
zip -r "$backup_file" /etc/nixos/*

echo "Backup created at: $backup_file"

"${BASH_SOURCE%/*}/setup-unstable-channel.sh"

cd /etc/nixos

if [[ ! -d "./genoc" ]]; then
  git clone git@github.com:noksys/genoc.git
  cd genoc
  git submodule update --init --recursive
  cd -
fi

ln -s ./genoc/configuration.nix

cp ./genoc/custom_machine.example.nix ./custom_machine.nix
cp ./genoc/custom_vars.example.nix ./custom_vars.nix

cd -

echo "Now, edit the files '/etc/nixos/custom_machine.nix' and '/etc/nixos/custom_vars.nix' to make your custom adjustments, and then run: nixos-rebuild switch"
