#!/bin/bash

# Remove omarchy-retroarch and put RetroArch's own config back.

set -euo pipefail

BIN_DIR="${BIN_DIR:-$HOME/.local/bin}"
HOOK_DIR="$HOME/.config/omarchy/hooks"

# Restore before removing the command — it owns the backup logic.
if command -v omarchy-retroarch-theme >/dev/null; then
  omarchy-retroarch-theme --restore || echo "Nothing to restore." >&2
fi

rm -f "$HOOK_DIR/theme-set.d/retroarch" "$HOOK_DIR/font-set.d/retroarch"
rm -f "$BIN_DIR/omarchy-retroarch-theme"
rm -rf "${SHARE_DIR:-$HOME/.local/share/omarchy-retroarch}"

echo "Removed the command and both hooks."
echo "RetroArch's pre-install config was restored if a backup existed"
echo "(kept at <retroarch config dir>/retroarch.cfg.pre-omarchy)."
