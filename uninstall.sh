#!/bin/bash
# uninstall.sh - Remove Morphe Desktop (works from any directory)
set -e

DIR="${HOME}/.local/share/morphe-desktop"
BIN="${HOME}/.local/bin/morphe"
DESKTOP="${HOME}/.local/share/applications/morphe-desktop.desktop"
ICON="${HOME}/.local/share/icons/morphe-desktop.png"

RED='\033[0;31m'; GREEN='\033[0;32m'; BLUE='\033[0;34m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok()   { echo -e "${GREEN}[✓]${NC} $*"; }
info() { echo -e "${BLUE}[i]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }

echo -e "${BLUE}━━━ Morphe Desktop Uninstaller ━━━${NC}"
echo ""
echo "This will remove:"
echo "  $BIN"
echo "  $DESKTOP"
echo "  $ICON"
echo "  $DIR"
echo ""
read -p "Continue? [y/N] " -r ans
[[ "$ans" =~ ^[Yy]$ ]] || { info "Cancelled"; exit 0; }
echo ""

removed=0
if [ -L "$BIN" ] || [ -f "$BIN" ]; then rm -f "$BIN" && ok "Removed $BIN" && removed=1; else warn "Not found: $BIN"; fi
if [ -f "$DESKTOP" ]; then rm -f "$DESKTOP" && ok "Removed desktop entry" && removed=1; else warn "Not found: desktop entry"; fi
if [ -f "$ICON" ]; then rm -f "$ICON" && ok "Removed icon" && removed=1; else warn "Not found: icon"; fi
if [ -d "$DIR" ]; then rm -rf "$DIR" && ok "Removed $DIR" && removed=1; else warn "Not found: $DIR"; fi

# refresh desktop DB so menu updates immediately
update-desktop-database "${HOME}/.local/share/applications" 2>/dev/null || true
gtk-update-icon-cache -f "${HOME}/.local/share/icons" 2>/dev/null || true

echo ""
if [ "$removed" -eq 1 ]; then
    echo -e "${GREEN}━━━ Uninstalled ━━━${NC}"
else
    echo -e "${YELLOW}━━━ Nothing to remove — already uninstalled ━━━${NC}"
fi
echo ""
echo "Tip: morphe uninstall  — also works from anywhere"
echo ""
