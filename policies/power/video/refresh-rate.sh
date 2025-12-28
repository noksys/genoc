#!/usr/bin/env bash
# Set panel refresh rate by power source (AC = high Hz, Battery = low Hz)
# - Keeps current resolution; only changes refresh.
# - Handles multiple outputs; prefers 60 Hz on battery (fallback to lowest).
# - Works under X11 via xrandr.

set -euo pipefail
shopt -s nullglob

export PATH="@PATH@:$PATH"

# --- Power detection ---------------------------------------------------------
on_ac() {
  for ps in /sys/class/power_supply/*; do
    [[ -d "$ps" ]] || continue
    local type=""
    if [[ -f "$ps/type" ]]; then type="$(<"$ps/type")"; fi
    case "$type" in
      Mains|USB|USB_C|Wireless)
        if [[ -f "$ps/online" ]]; then
          local online
          online="$(<"$ps/online")"
          if [[ "$online" = "1" ]]; then return 0; fi
        fi
        ;;
    esac
  done
  return 1
}

# --- XRANDR helpers ----------------------------------------------------------
get_connected_outputs() { xrandr --query | awk '/ connected/{print $1}'; }

get_current_res() {
  local out="$1"
  xrandr --query | awk -v o="$out" '
    $1==o { insec=1; next }
    insec && /^\s/ { if ($0 ~ /\*/) { print $1; exit } }
    insec && !/^\s/ { exit }
  '
}

get_rates_for_res() {
  local out="$1" res="$2"
  xrandr --query | awk -v o="$out" -v r="$res" '
    $1==o { insec=1; next }
    insec && /^\s/ {
      if ($1==r) {
        for (i=2; i<=NF; i++) { gsub("[*+]", "", $i); print $i }
      }
      next
    }
    insec && !/^\s/ { exit }
  '
}

choose_rate_ac() { awk 'BEGIN{m=0} {if ($1+0>m) m=$1} END{if (m>0) print m}'; }

choose_rate_bat() {
  awk '/^60(\.0+)?$/ { sixty=$1 } { if (min=="") min=$1; if ($1+0<min+0) min=$1 } END { if (sixty!="") print sixty; else print min }'
}

apply_rate() {
  local out="$1" res="$2" rate="$3"
  xrandr --output "$out" --mode "$res" --rate "$rate"
}

# --- Main --------------------------------------------------------------------
main() {
  if [[ -z "${DISPLAY-}" ]] || ! xrandr --query >/dev/null 2>&1; then
    echo "Skipping refresh rate: no X11 display detected."
    exit 0
  fi

  local prefer
  if on_ac; then
    echo "AC power detected; prefer high refresh."
    prefer="ac"
  else
    echo "Battery detected; prefer low refresh."
    prefer="bat"
  fi

  local outputs=""
  if ! outputs="$(get_connected_outputs)"; then outputs=""; fi
  [[ -n "$outputs" ]] || { echo "No connected outputs found."; exit 0; }

  while IFS= read -r out; do
    [[ -n "$out" ]] || continue
    local res=""
    res="$(get_current_res "$out")" || true
    [[ -n "$res" ]] || { echo "Could not get current resolution for $out"; continue; }

    local rates=""
    rates="$(get_rates_for_res "$out" "$res" | sort -u)" || true
    [[ -n "$rates" ]] || { echo "No rates found for $out $res"; continue; }

    local target=""
    if [[ "$prefer" = "ac" ]]; then
      target="$(printf '%s\n' "$rates" | choose_rate_ac)"
    else
      target="$(printf '%s\n' "$rates" | choose_rate_bat)"
    fi

    if [[ -n "$target" ]]; then
      echo "Setting $out to ${res}@${target}"
      apply_rate "$out" "$res" "$target" || echo "xrandr failed for $out"
    fi
  done <<<"$outputs"
}

main "$@"
