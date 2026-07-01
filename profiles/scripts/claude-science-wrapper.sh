# Embedded by writeShellApplication in genoc/profiles/dev.nix.
# set -euo pipefail is prepended automatically; steam-run is in PATH via runtimeInputs.
#
# Anthropic Claude Science: a self-contained CLI that runs a local daemon + web
# UI (`claude-science serve`). It is NOT an AppImage/Electron app — it's a
# foreign, dynamically-linked ELF, so on NixOS it needs an FHS loader; steam-run
# provides one. The binary lives under ~/app because `claude-science update`
# self-updates it in place, which a read-only Nix store cannot host.

bin="${HOME}/app/claude-science/claude-science"

if [ ! -x "$bin" ]; then
  echo "claude-science: binary not found (or not executable) at $bin" >&2
  echo "  Download the Linux build from https://claude.com/product/claude-science" >&2
  echo "  into that path, then: chmod +x \"$bin\"" >&2
  exit 1
fi

exec steam-run "$bin" "$@"
