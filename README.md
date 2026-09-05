<div align="center"> 
<picture>
    <source
      width="512px"
      media="(prefers-color-scheme: dark)"
      srcset="https://raw.githubusercontent.com/MorpheApp/.github/refs/heads/main/profile/assets/morphe-wordmark/morphe_wordmark_dark.svg"
    />
    <img 
      width="512px"
      src="https://raw.githubusercontent.com/MorpheApp/.github/refs/heads/main/profile/assets/morphe-wordmark/morphe_wordmark_light.svg"
    />
</picture>
<br>
</div>

<h1 align="center">Morphe Desktop</h1>

<p align="center">
  <b>Android App Patcher — CLI + GUI</b><br>
  Patch & install Android apps on Linux with one command
</p>

<p align="center">
  <a href="https://github.com/hembramnishant50-glitch/morphe-desktop"><img src="https://img.shields.io/badge/Fork-Omarchy%20Ready-2ea44f?style=for-the-badge" alt="Omarchy Ready"></a>
  <a href="https://github.com/MorpheApp/morphe-desktop"><img src="https://img.shields.io/badge/Upstream-MorpheApp-8A2BE2?style=for-the-badge" alt="Upstream"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-GPL--3.0-blue?style=for-the-badge" alt="License"></a>
</p>

<p align="center">
  <a href="#-omarchy-quick-start-">Omarchy Install</a> •
  <a href="#-usage">Usage</a> •
  <a href="#-getting-started">Getting Started</a> •
  <a href="docs/OMARCHY.md">Omarchy Docs</a> •
  <a href="docs/documentation.md">Full Docs</a>
</p>

---

## 📑 Table of Contents

- [About](#about)
- [⚡ Omarchy Quick Start — 30 Second Install](#-omarchy-quick-start--30-second-install)
- [📋 Prerequisites](#-prerequisites)
- [📦 Installation](#-installation)
- [🚀 Usage](#-usage)
- [🖥️ Desktop Integration — Omarchy / Hyprland](#️-desktop-integration--omarchy--hyprland)
- [📁 File Locations](#-file-locations)
- [🔄 Updating & Uninstalling](#-updating--uninstalling)
- [🛠️ Troubleshooting](#️-troubleshooting)
- [📖 Getting Started — GUI & CLI (Upstream)](#-getting-started--gui--cli-upstream)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

---

## About

**Morphe Desktop** is a command-line and GUI app that uses [Morphe Patcher](https://github.com/MorpheApp/morphe-patcher) to patch Android APKs.

- **CLI** based on [ReVanced CLI](https://github.com/ReVanced/revanced-cli)
- **GUI** built with Compose Desktop (Skiko) by the Morphe team
- Supports `*.apk` / `*.apkm` / `*.xapk` / `*.apks`
- Install patched APKs directly via ADB
- This fork adds **one-command Omarchy/Arch Linux integration** — no manual JAR handling

> **Upstream:** [MorpheApp/morphe-desktop](https://github.com/MorpheApp/morphe-desktop)

---

## ⚡ Omarchy Quick Start — 30 Second Install

```bash
# 1. Clone
git clone https://github.com/hembramnishant50-glitch/morphe-desktop.git
cd morphe-desktop

# 2. Install (downloads latest JAR + patches, sets up CLI + app menu)
./install.sh

# 3. Run
morphe              # → opens GUI
morphe help         # → shows all commands
```

That's it. Morphe appears in your **Omarchy app menu** and as the `morphe` command everywhere.

<details>
<summary><b>What does <code>install.sh</code> do?</b></summary>

- Checks Java 21+
- Downloads latest `morphe-desktop-*-all.jar` from GitHub Releases
- Downloads latest `patches-*.mpp`
- Installs CLI to `~/.local/bin/morphe` (symlink to `~/.local/share/morphe-desktop/morphe-cli`)
- Copies `Morphe-icon.png` → `~/.local/share/icons/morphe-desktop.png`
- Creates desktop entry → `~/.local/share/applications/morphe-desktop.desktop`
- No `sudo` needed — fully user-space (`~/.local`)

</details>

---

## 📋 Prerequisites

| Requirement | Command | Notes |
|-------------|---------|-------|
| **Java 21+** | `sudo pacman -S jdk21-openjdk` | `java -version` must show 21+ |
| **Git** | `sudo pacman -S git` | To clone |
| **ADB** *(optional)* | `sudo pacman -S android-tools` | Only for `morphe install` to device |
| **curl** | `sudo pacman -S curl` | For downloading releases |

Check before installing:
```bash
java -version      # should be 21+
adb version        # optional
```

---

## 📦 Installation

### Option A — Automatic (Recommended)

```bash
git clone https://github.com/hembramnishant50-glitch/morphe-desktop.git
cd morphe-desktop
chmod +x install.sh
./install.sh
```

Output on success:
```
[✓] Java 26
[✓] Directories created
[✓] CLI installed → /home/nishant/.local/bin/morphe
[✓] Downloaded v1.15.0
[✓] Patches downloaded
[✓] Icon installed
[✓] Desktop entry installed
[✓] PATH includes ~/.local/bin
━━━ Installation Complete ━━━
  Run:  morphe
  Help: morphe help
```

### Option B — Manual

```bash
chmod +x gradlew
./gradlew shadowJar
mkdir -p ~/.local/share/morphe-desktop/patches
cp build/libs/morphe-desktop-*-all.jar ~/.local/share/morphe-desktop/morphe-desktop-all.jar
cp bin/morphe ~/.local/share/morphe-desktop/morphe-cli
ln -sf ~/.local/share/morphe-desktop/morphe-cli ~/.local/bin/morphe
cp Morphe-icon.png ~/.local/share/icons/morphe-desktop.png
cp omarchy/morphe-desktop.desktop ~/.local/share/applications/
# then manually download patches-*.mpp to ~/.local/share/morphe-desktop/patches/
```

### Verify

```bash
which morphe          # → /home/nishant/.local/bin/morphe
morphe version        # → Morphe Desktop v1.15.0
morphe help
```

If `morphe: command not found`, add to `~/.zshrc` or `~/.bashrc`:
```bash
export PATH="$HOME/.local/bin:$PATH"
```
Then `source ~/.zshrc` or reopen terminal.

---

## 🚀 Usage

### Launch

```bash
morphe              # GUI (default)
morphe gui          # GUI explicit
morphe gui my.apk   # GUI with file pre-loaded (drag & drop also works)
```

You can also launch from **Omarchy app launcher** → search “Morphe”.

### Patch an APK

```bash
# Simplest — uses auto-downloaded patches
morphe patch youtube.apk

# Explicit patches / output
morphe patch youtube.apk ~/.local/share/morphe-desktop/patches/patches.mpp ./out/

# Via CLI directly
morphe cli patch -p patches.mpp app.apk
```

**Output:** `youtube-patched.apk` in current dir (or `out/` if specified).

### Install to Device via ADB

```bash
# 1. Enable USB debugging on phone, connect via USB
adb devices           # should list your device

# 2. Install
morphe install youtube-patched.apk
# or
adb install youtube-patched.apk
```

### All Commands

| Command | Description |
|---------|-------------|
| `morphe` / `morphe gui` | Launch GUI |
| `morphe cli [args]` | Run upstream CLI directly (`java -jar ...`) |
| `morphe patch <apk> [patches] [out]` | Patch APK |
| `morphe install <apk>` | Install via ADB |
| `morphe update` | Update patches to latest |
| `morphe uninstall` | Uninstall from anywhere |
| `morphe version` | Show version |
| `morphe help` | Show help |

### Update Patches Only

```bash
morphe update
# downloads latest https://github.com/MorpheApp/morphe-patches/releases/latest
# → ~/.local/share/morphe-desktop/patches/patches.mpp
```

### Example Workflow — YouTube

```bash
# 1. Download APK from APK Mirror
# 2. Patch
morphe patch com.google.android.youtube.apk

# 3. Install
morphe install com.google.android.youtube-patched.apk
```

---

## 🖥️ Desktop Integration — Omarchy / Hyprland

### App Menu

After `install.sh`, **Morphe Desktop** appears in the Omarchy launcher automatically.
If icon doesn’t show immediately: `omarchy restart shell` or log out/in.

### Keybinding — Super+M

Add to `~/.config/hypr/bindings.lua`:

```lua
o.bind("SUPER", "m", function()
    os.execute("morphe &")
end)
```

### Window Rule — Floating & Centered

Add to `~/.config/hypr/windowrules.lua`:

```lua
rule {
    class = "Morphe Desktop",
    float = true,
    center = true,
    size = { 900, 650 },
}
```

### Autostart (optional)

`~/.config/hypr/autostart.lua`:
```lua
-- os.execute("morphe &")  -- uncomment to launch at login
```

Validate Hyprland config after edits:
```bash
hyprctl reload && hyprctl configerrors
```

---

## 📁 File Locations

| What | Path |
|------|------|
| CLI | `~/.local/bin/morphe` → `~/.local/share/morphe-desktop/morphe-cli` |
| JAR | `~/.local/share/morphe-desktop/morphe-desktop-all.jar` |
| Patches | `~/.local/share/morphe-desktop/patches/patches.mpp` |
| GUI data / Skiko + JNA cache | `~/.local/share/morphe-desktop/morphe-data/` |
| Config | `~/.local/share/morphe-desktop/morphe-data/config.json` |
| Desktop entry | `~/.local/share/applications/morphe-desktop.desktop` |
| Icon | `~/.local/share/icons/morphe-desktop.png` |

---

## 🔄 Updating & Uninstalling

### Update Everything

```bash
cd morphe-desktop
git pull
./install.sh          # re-downloads latest JAR + patches
# or just patches:
morphe update
```

### Uninstall — 3 Ways (all work from anywhere)

**Way 1 — Recommended (works from any folder, no clone needed):**
```bash
morphe uninstall
# → asks [y/N], removes:
#   ~/.local/bin/morphe
#   ~/.local/share/applications/morphe-desktop.desktop
#   ~/.local/share/icons/morphe-desktop.png
#   ~/.local/share/morphe-desktop/
```

**Way 2 — From clone:**
```bash
cd ~/Projects/morphe-desktop
./uninstall.sh
# or
~/Projects/morphe-desktop/uninstall.sh
```

**Way 3 — Manual (if `morphe` is already deleted):**
```bash
rm -f ~/.local/bin/morphe
rm -f ~/.local/share/applications/morphe-desktop.desktop
rm -f ~/.local/share/icons/morphe-desktop.png
rm -rf ~/.local/share/morphe-desktop
update-desktop-database ~/.local/share/applications/
```

> [!NOTE]
> If you ran `rm ~/.local/bin/morphe` already, `morphe uninstall` won’t work — use Way 2 or 3.

---

## 🛠️ Troubleshooting

<details>
<summary><b>Java errors</b></summary>

```bash
java -version
# need 21+
sudo pacman -S jdk21-openjdk
# if multiple JDKs: archlinux-java status && sudo archlinux-java set java-21-openjdk
```

</details>

<details>
<summary><b><code>morphe: command not found</code></b></summary>

```bash
echo $PATH | grep -q ".local/bin" || echo 'Add to ~/.zshrc: export PATH="$HOME/.local/bin:$PATH"'
source ~/.zshrc
which morphe
```

</details>

<details>
<summary><b>ADB not working</b></summary>

```bash
adb version || sudo pacman -S android-tools
adb kill-server; adb start-server
adb devices   # must list device; enable USB debugging on phone
# Permission denied? → sudo usermod -aG plugdev $USER  (then relogin)
```

</details>

<details>
<summary><b>GUI doesn’t open / Skiko download fails</b></summary>

- First launch needs internet — it downloads `skiko-*` + `jna` to `morphe-data/`
- Check: `ls ~/.local/share/morphe-desktop/morphe-data/`
- Delete cache and retry: `rm -rf ~/.local/share/morphe-desktop/morphe-data/libs && morphe gui`
- Logs: GUI prints to terminal when launched via `morphe gui`

</details>

<details>
<summary><b>Icon not showing in menu</b></summary>

```bash
gtk-update-icon-cache -f ~/.local/share/icons/
update-desktop-database ~/.local/share/applications/
omarchy restart shell
```

</details>

Full logs: `morphe gui` in terminal shows all INFO/DEBUG.
More help: [docs/OMARCHY.md](docs/OMARCHY.md) • [docs/documentation.md](docs/documentation.md)

---

## 📖 Getting Started — GUI & CLI (Upstream)

The sections below are the original Morphe guide for first-time patching.

Morphe runs in two modes: **CLI** (terminal) and **GUI** (double-click / `morphe`).

> [!TIP]
> First time? Use **GUI**. Once comfortable, try CLI.

### First Run — GUI

Quick mode (default):

1. Run `morphe` — home screen opens:

   ![Home](docs/images/main_readme/home_screen.png)

   > **First launch only:** GUI fetches Skiko + JNA to `morphe-data/libs/` (once, ~40 MB). Afterwards works offline.

2. Drag & drop `*.apk` / `*.apkm` / `*.xapk` / `*.apks` → click **Patch**:

   ![Selected](docs/images/main_readme/app_selected.png)

3. Watch progress:

   ![Patching](docs/images/main_readme/patching.png)

4. Result screen → copy APK to device or install via ADB:

   ![Success](docs/images/main_readme/success.png)

   Switch to **Expert mode** in Settings for patch selection, sources, signing.

### First Run — CLI (without wrapper)

If you prefer raw JAR:

```bash
java -jar morphe-desktop-*-all.jar patch -p patches-*.mpp your_app.apk
# → your_app-patched.apk
# Logs: Loading patches → Decoding manifest → Aligning → Signing → Saved to ...
```

With wrapper (`morphe`) this is just `morphe patch your_app.apk`.

More: [docs/documentation.md](docs/documentation.md)

---

## 🤝 Contributing

Thanks for considering contributing. See [CONTRIBUTING.md](CONTRIBUTING.md).

---

## 📄 License

Licensed under **GPL-3.0** with Section 7 conditions:

- **Attribution (7b):** Preserve all notices/disclaimers
- **Name & Branding (7c & 7e):** Derivative works must use distinct branding — “Morphe” name/logos may not be used (e.g., *Morphe Plus* is prohibited)

See [LICENSE](LICENSE) and [NOTICE](NOTICE).

---

<p align="center">
  <sub>Omarchy fork by <a href="https://github.com/hembramnishant50-glitch">hembramnishant50-glitch</a> • Upstream by <a href="https://github.com/MorpheApp">MorpheApp</a></sub>
</p>
