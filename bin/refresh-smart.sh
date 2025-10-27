#!/usr/bin/env bash
# Set panel refresh rate by power source (AC = high Hz, Battery = low Hz)
# - Keeps current resolution; only changes refresh.
# - Handles multiple outputs; prefers 60 Hz on battery (fallback to lowest).
# - Works under X11 via xrandr.
set -euo pipefail
shopt -s nullglob  # if glob doesn't match, expand to empty rather than literal

# --- Power detection ---------------------------------------------------------
on_ac() {
  # Return 0 if any mains-like supply is online
  for ps in /sys/class/power_supply/*; do
    [[ -d "$ps" ]] || continue

    local type=""
    if [[ -f "$ps/type" ]]; then
      type="$(<"$ps/type")"
    fi

    case "$type" in
      Mains|USB|USB_C|Wireless)
        if [[ -f "$ps/online" ]]; then
          local online
          online="$(<"$ps/online")"
          if [[ "$online" = "1" ]]; then
            return 0
          fi
        fi
        ;;
    esac
  done
  return 1
}

# --- XRANDR helpers ----------------------------------------------------------
get_connected_outputs() {
  # Print connected outputs (one per line)
  xrandr --query | awk '/ connected/{print $1}'
}

get_current_res() {
  # Arg1: output -> prints current resolution (e.g., 2560x1600)
  local out="$1"
  xrandr --query | awk -v o="$out" '
    $1==o { insec=1; next }
    insec && /^\s/ {
      if ($0 ~ /\*/) { print $1; exit }
    }
    insec && !/^\s/ { exit }
  '
}

get_rates_for_res() {
  # Args: output, resolution -> prints available Hz for that resolution
  local out="$1" res="$2"
  xrandr --query | awk -v o="$out" -v r="$res" '
    $1==o { insec=1; next }
    insec && /^\s/ {
      if ($1==r) {
        for (i=2; i<=NF; i++) {
          gsub("[*+]", "", $i)
          print $i
        }
      }
      next
    }
    insec && !/^\s/ { exit }
  '
}

choose_rate_ac() {
  # Pick the highest Hz from stdin
  awk 'BEGIN{m=0} {if ($1+0>m) m=$1} END{if (m>0) print m}'
}

choose_rate_bat() {
  # Prefer exactly 60/60.0/60.00; else choose the lowest available
  awk '
    /^60(\.0+)?$/ { sixty=$1 }
    { if (min=="") min=$1; if ($1+0<min+0) min=$1 }
    END { if (sixty!="") print sixty; else print min }
  '
}

apply_rate() {
  # Args: output, resolution, rate
  local out="$1" res="$2" rate="$3"
  xrandr --output "$out" --mode "$res" --rate "$rate"
}

# --- Main --------------------------------------------------------------------
main() {
  local prefer
  if on_ac; then
    echo "🔌 AC power detected → prefer high refresh"
    prefer="ac"
  else
    echo "🔋 Battery detected → prefer low refresh"
    prefer="bat"
  fi

  local outputs=""
  if ! outputs="$(get_connected_outputs)"; then
    outputs=""
  fi
  [[ -n "$outputs" ]] || { echo "⚠  No connected outputs found."; exit 0; }

  # Iterate outputs line-by-line robustly
  while IFS= read -r out; do
    [[ -n "$out" ]] || continue

    local res=""
    res="$(get_current_res "$out")" || true
    [[ -n "$res" ]] || { echo "⚠  Could not get current resolution for $out"; continue; }

    local rates=""
    rates="$(get_rates_for_res "$out" "$res" | sort -u)" || true
    [[ -n "$rates" ]] || { echo "⚠  No rates found for $out $res"; continue; }

    if [[ "${DEBUG:-}" = "1" ]]; then
      echo "Parsed Hz candidates for $out $res:"
      printf '%s\n' "$rates" | sed 's/^/  - /'
    fi

    local target=""
    if [[ "$prefer" = "ac" ]]; then
      target="$(printf '%s\n' "$rates" | choose_rate_ac)"
    else
      target="$(printf '%s\n' "$rates" | choose_rate_bat)"
    fi

    if [[ -n "$target" ]]; then
      echo "✅ Setting $out → ${res}@${target}"
      if ! apply_rate "$out" "$res" "$target"; then
        echo "⚠  xrandr failed for $out"
      fi
    else
      echo "⚠  No suitable refresh rate found for $out"
    fi
  done <<<"$outputs"
}

main "$@"
