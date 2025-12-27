#!/usr/bin/env nix-shell
#!nix-shell -p rsync git -i bash

if [[ "$EUID" -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

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

./genoc/bin/setup-unstable-channel.sh
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
