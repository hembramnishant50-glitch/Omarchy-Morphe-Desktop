# Morphe Desktop for Omarchy

This guide provides instructions for installing and using Morphe Desktop on Omarchy Linux.

## Prerequisites

Before installing Morphe Desktop, ensure you have:

1. **Java 21 or later**
   ```bash
   # Install Java 21
   sudo pacman -S jdk21-openjdk
   
   # Or visit: https://adoptium.net/temurin/releases/?version=21
   ```

2. **Android Debug Bridge (ADB)** - Optional, for direct device installation
   ```bash
   sudo pacman -S android-tools
   ```

3. **Git** - For cloning the repository
   ```bash
   sudo pacman -S git
   ```

## Installation

### Quick Install

1. Clone the repository:
   ```bash
   git clone https://github.com/MorpheApp/morphe-desktop.git
   cd morphe-desktop
   ```

2. Run the installation script:
   ```bash
   chmod +x install-omarchy.sh
   ./install-omarchy.sh
   ```

3. Follow the on-screen instructions.

### Manual Install

1. Build the project:
   ```bash
   chmod +x gradlew
   ./gradlew shadowJar
   ```

2. Create installation directory:
   ```bash
   sudo mkdir -p /opt/morphe-desktop
   ```

3. Copy the built JAR:
   ```bash
   sudo cp build/libs/morphe-desktop-*-all.jar /opt/morphe-desktop/morphe-desktop-all.jar
   ```

4. Copy the wrapper script:
   ```bash
   sudo cp omarchy/morphe /opt/morphe-desktop/morphe
   sudo chmod +x /opt/morphe-desktop/morphe
   ```

5. Create symlink:
   ```bash
   sudo ln -sf /opt/morphe-desktop/morphe /usr/local/bin/morphe
   ```

6. Install desktop entry:
   ```bash
   cp omarchy/morphe-desktop.desktop ~/.local/share/applications/
   ```

## Usage

### Running Morphe Desktop

**GUI Mode:**
```bash
morphe
# or
morphe gui
```

**CLI Mode:**
```bash
morphe cli [args]
```

**Patching an APK:**
```bash
morphe patch <apk-file> [patches-file] [output-dir]
```

**Installing via ADB:**
```bash
morphe install <patched-apk-file>
```

**Showing Help:**
```bash
morphe help
```

### Desktop Integration

After installation, Morphe Desktop will appear in your application menu. You can:

1. Launch it from the application menu
2. Use keyboard shortcut (if configured)
3. Run from terminal: `morphe`

### Drag and Drop

You can drag and drop APK files onto the Morphe Desktop window to patch them.

## Configuration

### Configuration Files

- **Installation directory:** `/opt/morphe-desktop/`
- **Configuration directory:** `~/.config/morphe-desktop/`
- **Data directory:** `~/.local/share/morphe-desktop/`

### Patches

Patches are automatically downloaded during installation. To update patches:

```bash
morphe update
```

Or manually download from: https://github.com/MorpheApp/morphe-patches/releases/latest

## Troubleshooting

### Java Issues

If you encounter Java-related errors:

1. Check Java version:
   ```bash
   java -version
   ```

2. Ensure Java 21 or later is installed:
   ```bash
   sudo pacman -S jdk21-openjdk
   ```

### ADB Issues

If ADB doesn't work:

1. Check if ADB is installed:
   ```bash
   adb version
   ```

2. Restart ADB server:
   ```bash
   adb kill-server
   adb start-server
   ```

3. Check USB connection:
   ```bash
   adb devices
   ```

### Permission Issues

If you encounter permission errors:

1. Ensure you have write permissions to the data directory:
   ```bash
   chmod -R u+rw ~/.local/share/morphe-desktop
   ```

2. For ADB, ensure your user is in the `plugdev` group:
   ```bash
   sudo usermod -aG plugdev $USER
   ```

## Updating

To update Morphe Desktop:

1. Pull latest changes:
   ```bash
   cd morphe-desktop
   git pull
   ```

2. Rebuild and reinstall:
   ```bash
   ./install-omarchy.sh
   ```

Or use the update script:
```bash
morphe update
```

## Uninstalling

To uninstall Morphe Desktop:

1. Remove installation directory:
   ```bash
   sudo rm -rf /opt/morphe-desktop
   ```

2. Remove symlink:
   ```bash
   sudo rm /usr/local/bin/morphe
   ```

3. Remove desktop entry:
   ```bash
   rm ~/.local/share/applications/morphe-desktop.desktop
   ```

4. Remove data and configuration:
   ```bash
   rm -rf ~/.local/share/morphe-desktop
   rm -rf ~/.config/morphe-desktop
   ```

## Omarchy Integration

### Keybindings

You can add custom keybindings to launch Morphe Desktop. Edit `~/.config/hypr/bindings.lua`:

```lua
-- Launch Morphe Desktop
o.bind("SUPER", "m", function()
    os.execute("morphe &")
end)
```

### Window Rules

Add window rules for Morphe Desktop in `~/.config/hypr/windowrules.lua`:

```lua
-- Morphe Desktop window rules
rule {
    class = "Morphe Desktop",
    float = true,
    center = true,
    size = { 800, 600 }
}
```

### Autostart

To start Morphe Desktop on login, add to `~/.config/hypr/autostart.lua`:

```lua
-- Start Morphe Desktop on login (optional)
-- os.execute("morphe &")
```

## Support

- **Documentation:** `/docs/`
- **Issues:** https://github.com/MorpheApp/morphe-desktop/issues
- **Community:** https://www.reddit.com/r/MorpheApp

## License

Morphe Desktop is licensed under the GNU General Public License v3.0. See [LICENSE](LICENSE) for details.
