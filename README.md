# Good Enough NixOS Configuration (GENOC).

I made this repository to store my own NixOS configurations, but it might be very useful for you as a beginner to have a starting point.

For advanced users, it could be an opportunity to keep their configurations more organized.

If you have any improvement suggestions, don't hesitate: fork the repository and submit a Pull Request.

## Concepts

This repo is organized around three layers. Prefer `profiles`, add `modules` as needed, and pick `policies` carefully.

- **Modules**: Focused feature blocks, usually in tiers like `base`, `tools`, or `full`, for one domain or capability.
- **Policies**: Mutually-exclusive choices that define system behavior (bootloader, desktop, power, firewall, SSH, shells).
- **Profiles**: Curated bundles of modules for a specific persona or workflow (development, business, creative, gaming, etc.).

## Installation
First, perform a fresh installation of NixOS.

Then, run:

```bash
curl -s https://raw.githubusercontent.com/noksys/genoc/main/bin/install-genoc.sh | sudo bash
```

Or:

```bash
nix-shell -p git
sudo su
cd /etc/nixos
git clone git@github.com:noksys/genoc.git
./genoc/bin/install-genoc.sh
```

Follow the on-screen instructions.

You can safely run this on an existing NixOS installation. All files inside `/etc/nixos` will be backed up to `/etc/nixos/backup/${timestamp}`.

### What the installer does

- Clones this repo into `/etc/nixos/genoc`
- Creates a symlink `/etc/nixos/configuration.nix -> /etc/nixos/genoc/configuration.nix`
- Copies `custom_machine.example.nix` and `custom_vars.example.nix` if they do not exist
- Adds the `nixos-unstable` channel (for newer packages when needed)

### Post-install checklist

- Edit `/etc/nixos/custom_vars.nix` (password hashes, hostname, timezone, etc.)
- Edit `/etc/nixos/custom_machine.nix` and **import your `hardware-configuration.nix`**
- Run `nixos-rebuild switch`

Tip: generate password hashes with `mkpasswd -m sha-512` (package `whois`) or another compatible tool.

Note: the smart refresh-rate policy uses X11 `xrandr`, so it will no-op on Wayland-only sessions.

## Using Binary Cache (Cachix)

- Install the package `cachix`
- Run: `cachix use noksys`
