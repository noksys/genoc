#!/usr/bin/env bash
# refresh-smart.sh — keep current resolution, switch Hz by power source
set -euo pipefail

XRANDR=${XRANDR:-xrandr}
ONLINE=1
for ac in /sys/class/power_supply/*/online; do
  [[ -f "$ac" ]] || continue
  if [[ "$(cat "$ac" 2>/dev/null || echo 1)" == "1" ]]; then ONLINE=1; break; else ONLINE=0; fi
done

if [[ "$ONLINE" == "1" ]]; then
  echo "🔌 AC power detected → prefer high refresh"
else
  echo "🔋 Battery detected → prefer low refresh"
fi

# Escolhe a saída: primária se existir, senão a 1ª conectada
OUTPUT="$($XRANDR --query | awk '/ connected primary/{print $1; found=1} END{if(!found) exit 0}')" || true
if [[ -z "${OUTPUT:-}" ]]; then
  OUTPUT="$($XRANDR --query | awk '/ connected/{print $1; exit}')"
fi
[[ -z "${OUTPUT:-}" ]] && { echo "❌ No connected display found"; exit 1; }

# Bloco do xrandr referente à saída escolhida
BLOCK="$($XRANDR --query | awk -v o="$OUTPUT" '
  $0 ~ "^"o" connected"{print; cap=1; next}
  cap && NF==0{exit}
  cap{print}
')"

[[ -n "${DEBUG:-}" ]] && { echo "── xrandr block for $OUTPUT ──"; echo "$BLOCK"; echo "──────────────────────────────"; }

# Resolução atual = linha que contém '*'
CURRENT_RES="$(printf '%s\n' "$BLOCK" | awk '/\*/{print $1; exit}')"
if [[ -z "${CURRENT_RES:-}" ]]; then
  # fallback: primeira linha de modo do bloco
  CURRENT_RES="$(printf '%s\n' "$BLOCK" | awk 'NR>1 && /^[[:space:]]*[0-9]/{print $1; exit}')"
fi
[[ -z "${CURRENT_RES:-}" ]] && { echo "⚠️  Could not detect current resolution for $OUTPUT"; exit 0; }

[[ -n "${DEBUG:-}" ]] && echo "Current resolution: $CURRENT_RES"

# Pega a linha da resolução atual
RES_LINE="$(printf '%s\n' "$BLOCK" | awk -v r="$CURRENT_RES" '$1==r{print; exit}')"

# Extrai TODOS os Hz dessa linha (campos 2..NF), limpando * e +
MODES="$(printf '%s\n' "$RES_LINE" | awk '
  {
    for (i=2; i<=NF; i++) {
      g=$i
      gsub(/[*+]/,"",g)
      gsub(/[^0-9.]/,"",g)   # remove qualquer coisa que não for dígito ou ponto
      if (g != "") print g
    }
  }
')"

if [[ -z "$MODES" ]]; then
  [[ -n "${DEBUG:-}" ]] && { echo "No modes parsed from line: $RES_LINE"; }
  echo "⚠️  No refresh rates found for ${OUTPUT} at ${CURRENT_RES}"
  exit 0
fi

[[ -n "${DEBUG:-}" ]] && { echo "Parsed Hz candidates:"; printf '  - %s\n' $MODES; }

# Decide alvo: maior no AC, menor na bateria
if [[ "$ONLINE" == "1" ]]; then
  TARGET="$(printf '%s\n' $MODES | sort -nr | head -n1)"
else
  # se existir 60.x, prefira; senão menor mesmo
  TARGET="$(printf '%s\n' $MODES | awk '/^60(\.0+)?$/{print; hit=1} END{if(!hit) exit 1}') " || true
  TARGET="${TARGET// }"
  if [[ -z "$TARGET" ]]; then
    TARGET="$(printf '%s\n' $MODES | sort -n | head -n1)"
  fi
fi

if [[ -n "${TARGET:-}" ]]; then
  echo "✅ Setting ${OUTPUT} → ${CURRENT_RES}@${TARGET}"
  $XRANDR --output "$OUTPUT" --mode "$CURRENT_RES" --rate "$TARGET"
else
  echo "⚠️  No suitable refresh rate found."
fi
