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

echo "Backup created at: $backup_file"

cd /etc/nixos

if [[ ! -d "./genoc" ]]; then
  git clone git@github.com:noksys/genoc.git
  cd genoc
  git submodule update --init --recursive
  cd -
fi

./genoc/bin/setup-unstable-channel.sh
ln -s ./genoc/configuration.nix

cp ./genoc/custom_machine.example.nix ./custom_machine.nix
cp ./genoc/custom_vars.example.nix ./custom_vars.nix

cd -

echo
echo "*** ATTENTION! ***"
echo
echo "Now, edit the files:"
echo "'/etc/nixos/custom_machine.nix'"
echo "'/etc/nixos/custom_vars.nix'"
echo "to make your custom adjustments, and then run:"
echo "nixos-rebuild switch"
