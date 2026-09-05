#!/bin/bash
# uninstall.sh - Remove Morphe Desktop
set -e

DIR="${HOME}/.local/share/morphe-desktop"
BIN="${HOME}/.local/bin/morphe"
DESKTOP="${HOME}/.local/share/applications/morphe-desktop.desktop"
ICON="${HOME}/.local/share/icons/morphe-desktop.png"

RED='\033[0;31m'; GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'
ok()  { echo -e "${GREEN}[✓]${NC} $*"; }
info(){ echo -e "${BLUE}[i]${NC} $*"; }

echo -e "${BLUE}━━━ Morphe Desktop Uninstaller ━━━${NC}"
echo ""

# Remove symlink
[ -L "$BIN" ] && rm "$BIN" && ok "Removed $BIN"

# Remove desktop entry
[ -f "$DESKTOP" ] && rm "$DESKTOP" && ok "Removed desktop entry"

# Remove icon
[ -f "$ICON" ] && rm "$ICON" && ok "Removed icon"

# Remove install dir
[ -d "$DIR" ] && rm -rf "$DIR" && ok "Removed $DIR"

echo ""
echo -e "${GREEN}━━━ Uninstalled ━━━${NC}"
echo ""
