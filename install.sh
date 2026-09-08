#!/bin/bash

# Install omarchy-retroarch: the command, and the hooks that keep RetroArch in
# step with `omarchy theme set` and `omarchy font set`.

set -euo pipefail

SRC_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
HOOK_DIR="$HOME/.config/omarchy/hooks"

command -v omarchy-theme-color >/dev/null ||
  { echo "This needs Omarchy (omarchy-theme-color not found)." >&2; exit 1; }

missing=()
for dep in magick python3 fc-match; do
  command -v "$dep" >/dev/null || missing+=("$dep")
done
if ((${#missing[@]})); then
  echo "Missing: ${missing[*]}" >&2
  echo "Install them first, e.g.: sudo pacman -S imagemagick python fontconfig" >&2
  exit 1
fi

SHARE_DIR="${SHARE_DIR:-$HOME/.local/share/omarchy-retroarch}"

mkdir -p "$BIN_DIR" "$HOOK_DIR/theme-set.d" "$HOOK_DIR/font-set.d" "$SHARE_DIR"

install -m 755 "$SRC_DIR/bin/omarchy-retroarch-theme" "$BIN_DIR/omarchy-retroarch-theme"
install -m 755 "$SRC_DIR/hooks/theme-set.d/retroarch" "$HOOK_DIR/theme-set.d/retroarch"
install -m 755 "$SRC_DIR/hooks/font-set.d/retroarch" "$HOOK_DIR/font-set.d/retroarch"
install -m 644 "$SRC_DIR/share/retromarchy.svg" "$SHARE_DIR/retromarchy.svg"

echo "Installed:"
echo "  $BIN_DIR/omarchy-retroarch-theme"
echo "  $HOOK_DIR/theme-set.d/retroarch"
echo "  $HOOK_DIR/font-set.d/retroarch"
echo "  $SHARE_DIR/retromarchy.svg"

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) echo; echo "Note: $BIN_DIR is not on your PATH — the hooks will not find the command." >&2 ;;
esac

echo
echo "Now run:  omarchy-retroarch-theme"
