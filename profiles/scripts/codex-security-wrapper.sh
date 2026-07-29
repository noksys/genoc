# Embedded by writeShellApplication in genoc/profiles/dev.nix.
# set -euo pipefail is prepended automatically; nodejs is in PATH via runtimeInputs.
#
# Wraps: npx -y @openai/codex-security@latest
#
# NOTE: the SCOPED name is mandatory. The unscoped `codex-security` on npm is an
# empty typosquat placeholder unaffiliated with OpenAI — never drop the @openai/.
#
# Auto-recovery: if npx exits non-zero due to ENOTEMPTY (cache corrupted by
# CTRL+C during a prior install), clears ~/.npm/_npx and retries once.

pkg="@openai/codex-security@latest"
cache="${NPM_CONFIG_CACHE:-${HOME}/.npm}"
log_dir="${cache}/_logs"

_newest_log() {
  local dir="$1" newest="" f mtime best=0
  for f in "${dir}"/*.log; do
    [[ -f "$f" ]] || continue
    mtime=$(stat -c %Y "$f" 2>/dev/null) || continue
    if [[ "$mtime" -gt "$best" ]]; then best=$mtime; newest=$f; fi
  done
  printf '%s' "$newest"
}

prev_log=$(_newest_log "$log_dir")

_s=0
npx -y "$pkg" "$@" || _s=$?

if [[ "$_s" -ne 0 && "$_s" -ne 130 ]]; then
  new_log=$(_newest_log "$log_dir")
  if [[ "$new_log" != "$prev_log" && -n "$new_log" ]] \
     && grep -q "ENOTEMPTY" "$new_log" 2>/dev/null; then
    echo "[npx] Corrupted cache (ENOTEMPTY). Clearing ${cache}/_npx and retrying..." >&2
    rm -rf "${cache}/_npx/"
    exec npx -y "$pkg" "$@"
  fi
fi

exit "$_s"
