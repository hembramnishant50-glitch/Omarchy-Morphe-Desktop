#!/bin/bash
# Morphe Desktop - Installation script for Omarchy (user-space, no sudo)
# This script installs Morphe Desktop to ~/.local and sets up the environment

set -e

# Configuration
INSTALL_DIR="${HOME}/.local/share/morphe-desktop"
BIN_DIR="${HOME}/.local/bin"
DATA_DIR="${HOME}/.local/share/morphe-desktop/data"
CONFIG_DIR="${HOME}/.config/morphe-desktop"
DESKTOP_FILE_DIR="${HOME}/.local/share/applications"
ICON_DIR="${HOME}/.local/share/icons"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status()   { echo -e "${BLUE}[Morphe]${NC} $1"; }
print_success()  { echo -e "${GREEN}[Morphe]${NC} $1"; }
print_warning()  { echo -e "${YELLOW}[Morphe]${NC} $1"; }
print_error()    { echo -e "${RED}[Morphe]${NC} $1"; }

check_java() {
    if ! command -v java &>/dev/null; then
        print_error "Java not found. Install Java 21+:"
        print_error "  sudo pacman -S jdk21-openjdk"
        exit 1
    fi
    JAVA_VERSION=$(java -version 2>&1 | head -n 1 | cut -d'"' -f2 | cut -d'.' -f1)
    if [ "$JAVA_VERSION" -lt 21 ]; then
        print_error "Java 21+ required (found Java $JAVA_VERSION)"
        exit 1
    fi
    print_success "Java $JAVA_VERSION detected"
}

create_directories() {
    print_status "Creating directories..."
    mkdir -p "$INSTALL_DIR" "$INSTALL_DIR/patches" "$DATA_DIR" "$CONFIG_DIR" "$DESKTOP_FILE_DIR" "$ICON_DIR" "$BIN_DIR"
    print_success "Directories created"
}

download_morphe() {
    print_status "Fetching latest Morphe Desktop release..."
    LATEST_RELEASE=$(curl -s https://api.github.com/repos/MorpheApp/morphe-desktop/releases/latest | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)
    if [ -z "$LATEST_RELEASE" ]; then
        print_error "Could not fetch latest release"; exit 1
    fi
    VERSION="${LATEST_RELEASE#v}"
    JAR_URL="https://github.com/MorpheApp/morphe-desktop/releases/download/${LATEST_RELEASE}/morphe-desktop-${VERSION}-all.jar"
    print_status "Downloading Morphe Desktop $LATEST_RELEASE..."
    curl -L -o "$INSTALL_DIR/morphe-desktop-all.jar" "$JAR_URL" --progress-bar
    chmod +x "$INSTALL_DIR/morphe-desktop-all.jar"
    print_success "Downloaded $LATEST_RELEASE"
}

install_files() {
    print_status "Installing wrapper and desktop entry..."
    cp omarchy/morphe "$INSTALL_DIR/morphe"
    chmod +x "$INSTALL_DIR/morphe"
    cp omarchy/morphe-desktop.desktop "$DESKTOP_FILE_DIR/"
    ln -sf "$INSTALL_DIR/morphe" "$BIN_DIR/morphe"
    print_success "Files installed"
}

download_patches() {
    print_status "Downloading latest patches..."
    LATEST_RELEASE=$(curl -s https://api.github.com/repos/MorpheApp/morphe-patches/releases/latest | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)
    if [ -z "$LATEST_RELEASE" ]; then
        print_warning "Could not fetch patches — download manually from https://github.com/MorpheApp/morphe-patches/releases/latest"
        return
    fi
    VERSION="${LATEST_RELEASE#v}"
    PATCHES_URL="https://github.com/MorpheApp/morphe-patches/releases/download/${LATEST_RELEASE}/patches-${VERSION}.mpp"
    curl -L -o "$INSTALL_DIR/patches/patches.mpp" "$PATCHES_URL" --progress-bar
    print_success "Patches downloaded"
}

create_update_script() {
    cat > "$INSTALL_DIR/update.sh" << 'SCRIPT'
#!/bin/bash
set -e
INSTALL_DIR="${HOME}/.local/share/morphe-desktop"
PATCHES_DIR="$INSTALL_DIR/patches"
echo "Updating patches..."
LATEST=$(curl -s https://api.github.com/repos/MorpheApp/morphe-patches/releases/latest | grep -o '"tag_name": "[^"]*"' | cut -d'"' -f4)
if [ -n "$LATEST" ]; then
    V="${LATEST#v}"
    curl -L -o "$PATCHES_DIR/patches.mpp" "https://github.com/MorpheApp/morphe-patches/releases/download/${LATEST}/patches-${V}.mpp" --progress-bar
    echo "Patches updated to $LATEST"
else
    echo "Could not fetch latest release"
fi
SCRIPT
    chmod +x "$INSTALL_DIR/update.sh"
}

show_summary() {
    echo ""
    echo -e "${GREEN}======================================${NC}"
    echo -e "${GREEN} Morphe Desktop Installed!${NC}"
    echo -e "${GREEN}======================================${NC}"
    echo ""
    echo "  Install dir : $INSTALL_DIR"
    echo "  Binary      : $BIN_DIR/morphe"
    echo ""
    echo "  Commands:"
    echo "    morphe              Launch GUI"
    echo "    morphe patch <apk>  Patch an APK"
    echo "    morphe install <apk> Install via ADB"
    echo "    morphe update       Update patches"
    echo "    morphe help         Show all commands"
    echo ""
    echo "  Make sure $BIN_DIR is in your PATH."
    echo "  Add to ~/.zshrc:  export PATH=\"\$HOME/.local/bin:\$PATH\""
}

main() {
    echo -e "${BLUE}======================================${NC}"
    echo -e "${BLUE} Morphe Desktop Installer (Omarchy)${NC}"
    echo -e "${BLUE}======================================${NC}"
    echo ""

    check_java
    create_directories
    download_morphe
    install_files
    download_patches
    create_update_script
    show_summary
}

main "$@"
