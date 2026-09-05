#!/bin/bash
# install.sh - Install Morphe Desktop for Omarchy
set -e

DIR="${HOME}/.local/share/morphe-desktop"
BIN="${HOME}/.local/bin"
DESKTOP="${HOME}/.local/share/applications"
ICONS="${HOME}/.local/share/icons"

RED='\033[0;31m'; GREEN='\033[0;32m'; BLUE='\033[0;34m'; NC='\033[0m'
ok()  { echo -e "${GREEN}[✓]${NC} $*"; }
err() { echo -e "${RED}[✗]${NC} $*"; exit 1; }
info(){ echo -e "${BLUE}[i]${NC} $*"; }

echo -e "${BLUE}━━━ Morphe Desktop Installer ━━━${NC}"
echo ""

# 1. Java check
command -v java &>/dev/null || err "Java not found. Run: sudo pacman -S jdk21-openjdk"
v=$(java -version 2>&1 | head -1 | cut -d'"' -f2 | cut -d'.' -f1)
[ "$v" -ge 21 ] || err "Java 21+ required (found $v)"
ok "Java $v"

# 2. Create dirs
mkdir -p "$DIR/patches" "$BIN" "$DESKTOP" "$ICONS"
ok "Directories created"

# 3. Install CLI
cp bin/morphe "$DIR/morphe-cli"
chmod +x "$DIR/morphe-cli"
ln -sf "$DIR/morphe-cli" "$BIN/morphe"
ok "CLI installed → $BIN/morphe"

# 4. Download JAR
if [ ! -f "$DIR/morphe-desktop-all.jar" ]; then
    info "Downloading Morphe Desktop..."
    rel=$(curl -sf https://api.github.com/repos/MorpheApp/morphe-desktop/releases/latest | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)
    [ -n "$rel" ] || err "Could not fetch latest release"
    v="${rel#v}"
    curl -fL -o "$DIR/morphe-desktop-all.jar" \
        "https://github.com/MorpheApp/morphe-desktop/releases/download/${rel}/morphe-desktop-${v}-all.jar" --progress-bar
    ok "Downloaded $rel"
else
    ok "JAR already exists"
fi

# 5. Download patches
if [ ! -f "$DIR/patches/patches.mpp" ]; then
    info "Downloading patches..."
    rel=$(curl -sf https://api.github.com/repos/MorpheApp/morphe-patches/releases/latest | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)
    if [ -n "$rel" ]; then
        v="${rel#v}"
        curl -fL -o "$DIR/patches/patches.mpp" \
            "https://github.com/MorpheApp/morphe-patches/releases/download/${rel}/patches-${v}.mpp" --progress-bar
        ok "Patches downloaded"
    else
        echo "  ⚠ Could not download patches (optional)"
    fi
else
    ok "Patches already exist"
fi

# 6. Install icon
if [ -f "Morphe-icon.png" ]; then
    cp "Morphe-icon.png" "$ICONS/morphe-desktop.png"
    ok "Icon installed"
else
    info "Downloading icon..."
    curl -fL -o "$ICONS/morphe-desktop.png" \
        "https://raw.githubusercontent.com/MorpheApp/morphe-desktop/main/docs/images/main_readme/home_screen.png" 2>/dev/null \
        && ok "Icon downloaded" || echo "  ⚠ Could not download icon (optional)"
fi

# 7. Desktop entry
cat > "$DESKTOP/morphe-desktop.desktop" <<EOF
[Desktop Entry]
Name=Morphe Desktop
Comment=Android app patching tool
Exec=$DIR/morphe-cli gui
Icon=$ICONS/morphe-desktop.png
Terminal=false
Type=Application
Categories=Development;Utility;
EOF
ok "Desktop entry installed"

# 8. PATH check
if echo "$PATH" | grep -q ".local/bin"; then
    ok "PATH includes ~/.local/bin"
else
    echo ""
    echo "  ⚠ Add to ~/.zshrc:"
    echo "    export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

echo ""
echo -e "${GREEN}━━━ Installation Complete ━━━${NC}"
echo ""
echo "  Run:  morphe"
echo "  Help: morphe help"
echo ""
