#!/bin/bash

# Manual Cross-Platform Build Script
# Use this if GitHub Actions fails

set -e

echo "🔧 Manual Build Script for File Sorter Pro"
echo "=========================================="

# Check if we're in a virtual environment
if [[ "$VIRTUAL_ENV" == "" ]]; then
    echo "⚠️  Virtual environment not active. Activating..."
    if [ -f ".venv/bin/activate" ]; then
        source .venv/bin/activate
    else
        echo "❌ No virtual environment found. Creating one..."
        python -m venv .venv
        source .venv/bin/activate
    fi
fi

echo "✅ Using virtual environment: $VIRTUAL_ENV"

# Install dependencies
echo "📦 Installing dependencies..."
pip install -q customtkinter>=5.2.0 pyinstaller>=5.0

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf build/ dist/ *.spec

# Create GUI spec file
echo "📝 Creating GUI spec file..."
cat > gui_manual.spec << 'EOF'
# -*- mode: python ; coding: utf-8 -*-

block_cipher = None

a = Analysis(
    ['gui.py'],
    pathex=[],
    binaries=[],
    datas=[('main.py', '.')],
    hiddenimports=[
        'customtkinter',
        'tkinter',
        'PIL._tkinter_finder'
    ],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        'matplotlib',
        'numpy',
        'scipy',
        'pandas'
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='FileSorter',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
EOF

# Create CLI spec file
echo "📝 Creating CLI spec file..."
cat > cli_manual.spec << 'EOF'
# -*- mode: python ; coding: utf-8 -*-

block_cipher = None

a = Analysis(
    ['main.py'],
    pathex=[],
    binaries=[],
    datas=[],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        'tkinter',
        'customtkinter',
        'PIL'
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.zipfiles,
    a.datas,
    [],
    name='file-sorter-cli',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
EOF

# Build executables
echo "🔨 Building GUI executable..."
pyinstaller gui_manual.spec --clean --noconfirm

echo "🔨 Building CLI executable..."
pyinstaller cli_manual.spec --clean --noconfirm

# Check if builds succeeded
if [ ! -f "dist/FileSorter" ] && [ ! -f "dist/FileSorter.exe" ]; then
    echo "❌ GUI build failed!"
    exit 1
fi

if [ ! -f "dist/file-sorter-cli" ] && [ ! -f "dist/file-sorter-cli.exe" ]; then
    echo "⚠️  CLI build failed, but continuing..."
fi

# Determine platform
OS_NAME=$(uname -s)
ARCH=$(uname -m)
VERSION="1.0.2"

case "$OS_NAME" in
    Linux*)     PLATFORM="linux" && EXE_EXT="";;
    Darwin*)    PLATFORM="macos" && EXE_EXT="";;
    CYGWIN*|MINGW*|MSYS*) PLATFORM="windows" && EXE_EXT=".exe";;
    *)          PLATFORM="unknown" && EXE_EXT="";;
esac

# Create distribution
DIST_NAME="FileSorter-${VERSION}-${PLATFORM}-${ARCH}"
DIST_DIR="releases/${DIST_NAME}"

echo "📦 Creating distribution: $DIST_NAME"
mkdir -p "$DIST_DIR"

# Copy executables
cp "dist/FileSorter${EXE_EXT}" "$DIST_DIR/" 2>/dev/null || echo "⚠️  GUI executable not found"
cp "dist/file-sorter-cli${EXE_EXT}" "$DIST_DIR/" 2>/dev/null || echo "⚠️  CLI executable not found"

# Copy documentation
cp README.md "$DIST_DIR/" 2>/dev/null || echo "⚠️  README.md not found"
cp requirements.txt "$DIST_DIR/" 2>/dev/null || echo "⚠️  requirements.txt not found"
cp LICENSE "$DIST_DIR/" 2>/dev/null || echo "⚠️  LICENSE not found"

# Create install instructions
cat > "$DIST_DIR/INSTALL.txt" << EOF
File Sorter Pro v${VERSION}
==========================

Installation Instructions:

GUI Version:
- Double-click 'FileSorter${EXE_EXT}' to start the application

CLI Version:
- Run './file-sorter-cli${EXE_EXT}' from terminal/command prompt

System Requirements:
- No Python installation required (standalone executable)
- Compatible with ${PLATFORM} (${ARCH})

Author: Olagunju Matthew
Email: olagunjunifemi6@gmail.com
Repository: https://github.com/Matthew-123-dev/File_sorting_script

Built on: $(date)
Platform: ${PLATFORM}-${ARCH}
EOF

# Make executables executable (Unix-like systems)
if [ "$PLATFORM" != "windows" ]; then
    chmod +x "$DIST_DIR/FileSorter" 2>/dev/null || true
    chmod +x "$DIST_DIR/file-sorter-cli" 2>/dev/null || true
fi

# Create archive
echo "🗜️  Creating archive..."
cd releases/
if command -v zip >/dev/null 2>&1; then
    zip -r "${DIST_NAME}.zip" "${DIST_NAME}/" >/dev/null
    echo "✅ Created ${DIST_NAME}.zip"
elif command -v tar >/dev/null 2>&1; then
    tar -czf "${DIST_NAME}.tar.gz" "${DIST_NAME}/" 2>/dev/null
    echo "✅ Created ${DIST_NAME}.tar.gz"
fi
cd ..

# Cleanup
echo "🧹 Cleaning up spec files..."
rm -f gui_manual.spec cli_manual.spec

# Display results
echo ""
echo "🎉 Manual Build Complete!"
echo "========================"
echo "Platform: ${PLATFORM}-${ARCH}"
echo "Distribution: releases/${DIST_NAME}/"
echo ""
echo "Files created:"
ls -la "releases/${DIST_NAME}/"

echo ""
echo "📤 To upload manually to GitHub:"
echo "1. Go to: https://github.com/Matthew-123-dev/File_sorting_script/releases"
echo "2. Edit the latest release (v${VERSION})"
echo "3. Upload: releases/${DIST_NAME}.zip"

echo ""
echo "✅ Manual build completed successfully!"
