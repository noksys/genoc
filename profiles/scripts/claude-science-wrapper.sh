# Embedded by writeShellApplication in genoc/profiles/dev.nix.
# set -euo pipefail is prepended automatically; socat is in PATH via runtimeInputs.
#
# Anthropic Claude Science: a Bun-compiled CLI that runs a local daemon + web UI
# (`claude-science serve`). It is a foreign dynamic ELF, but nix-ld already
# provides the loader system-wide, so it runs directly -- no steam-run/FHS.
# In fact it must: the tool creates its OWN Linux sandboxes (namespaces + socat
# bridges) to run code, so nesting it inside an FHS namespace (steam-run) would
# break that. We only put the tools it shells out to (socat) on PATH. The binary
# lives under ~/app because `claude-science update` rewrites it in place, which a
# read-only Nix store can't host.

bin="${HOME}/app/claude-science/claude-science"

if [ ! -x "$bin" ]; then
  echo "claude-science: binary not found (or not executable) at $bin" >&2
  echo "  Download the Linux build from https://claude.com/product/claude-science" >&2
  echo "  into that path, then: chmod +x \"$bin\"" >&2
  exit 1
fi

exec "$bin" "$@"
