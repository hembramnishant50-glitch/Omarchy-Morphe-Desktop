# Morphe Desktop - Omarchy Integration

This directory contains files to integrate Morphe Desktop with Omarchy Linux.

## Files

- `morphe-desktop.desktop` - Desktop entry for application menu
- `morphe` - Wrapper script for easy command-line access

## Installation

Run the installation script from the project root:

```bash
./install-omarchy.sh
```

## Quick Start

After installation:

```bash
# Start GUI
morphe

# Patch an APK
morphe patch youtube.apk

# Install patched APK
morphe install youtube-patched.apk

# Show help
morphe help
```

## Documentation

See [docs/OMARCHY.md](../docs/OMARCHY.md) for detailed instructions.
