#!/bin/bash

# Enhanced Cross-Platform Build Script
# Supports building for multiple platforms with proper configurations

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${CYAN}$1${NC}"
}

VERSION="1.0.0"
CURRENT_OS=$(uname -s)

print_header "🌍 File Sorter Pro - Cross-Platform Build System"
print_header "================================================="

echo ""
print_status "Current platform: $CURRENT_OS"
print_status "Target version: $VERSION"

# Function to build for current platform
build_current_platform() {
    print_header "🔨 Building for Current Platform"
    
    # Check if virtual environment is activated
    if [[ "$VIRTUAL_ENV" == "" ]]; then
        print_warning "Virtual environment not detected. Attempting to activate..."
        if [ -f ".venv/bin/activate" ]; then
            source .venv/bin/activate
            print_success "Activated virtual environment"
        elif [ -f ".venv/Scripts/activate" ]; then
            source .venv/Scripts/activate
            print_success "Activated virtual environment (Windows)"
        else
            print_error "No virtual environment found. Please create one first."
            exit 1
        fi
    fi

    # Install/check dependencies
    print_status "Checking dependencies..."
    python -c "import customtkinter, tkinter" 2>/dev/null || {
        print_status "Installing required packages..."
        pip install -r requirements.txt
    }

    python -c "import PyInstaller" 2>/dev/null || {
        print_status "Installing PyInstaller..."
        pip install pyinstaller>=5.0
    }

    # Clean previous builds
    print_status "Cleaning previous builds..."
    rm -rf build/ dist/ *.spec 2>/dev/null || true

    # Determine platform-specific settings
    case "$CURRENT_OS" in
        Linux*)
            PLATFORM="linux"
            ARCH=$(uname -m)
            EXE_EXT=""
            GUI_ARGS="--windowed"
            ;;
        Darwin*)
            PLATFORM="macos"
            ARCH=$(uname -m)
            EXE_EXT=""
            GUI_ARGS="--windowed"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            PLATFORM="windows"
            ARCH="x86_64"
            EXE_EXT=".exe"
            GUI_ARGS="--windowed --console"
            ;;
        *)
            print_error "Unsupported platform: $CURRENT_OS"
            exit 1
            ;;
    esac

    print_status "Building for: $PLATFORM-$ARCH"

    # Build GUI version
    print_status "Building GUI application..."
    pyinstaller gui.py \
        --onefile \
        $GUI_ARGS \
        --name="FileSorter" \
        --add-data "main.py${PLATFORM == "windows" && echo ";" || echo ":"}." \
        --hidden-import customtkinter \
        --hidden-import tkinter \
        --hidden-import PIL \
        --hidden-import PIL._tkinter_finder \
        --clean \
        --noconfirm

    if [ $? -eq 0 ]; then
        print_success "GUI build completed!"
    else
        print_error "GUI build failed!"
        exit 1
    fi

    # Build CLI version
    print_status "Building CLI application..."
    pyinstaller main.py \
        --onefile \
        --name="file-sorter-cli" \
        --console \
        --clean \
        --noconfirm

    if [ $? -eq 0 ]; then
        print_success "CLI build completed!"
    else
        print_warning "CLI build failed, but GUI succeeded"
    fi

    # Create distribution package
    DIST_NAME="FileSorter-${VERSION}-${PLATFORM}-${ARCH}"
    DIST_DIR="releases/${DIST_NAME}"

    print_status "Creating distribution package: $DIST_NAME"
    mkdir -p "$DIST_DIR"

    # Copy executables
    if [ -f "dist/FileSorter${EXE_EXT}" ]; then
        cp "dist/FileSorter${EXE_EXT}" "$DIST_DIR/"
        print_success "Copied GUI executable"
    fi

    if [ -f "dist/file-sorter-cli${EXE_EXT}" ]; then
        cp "dist/file-sorter-cli${EXE_EXT}" "$DIST_DIR/"
        print_success "Copied CLI executable"
    fi

    # Copy documentation
    cp README.md "$DIST_DIR/" 2>/dev/null || echo "README.md not found"
    cp requirements.txt "$DIST_DIR/" 2>/dev/null || echo "requirements.txt not found"
    cp LICENSE "$DIST_DIR/" 2>/dev/null || echo "LICENSE not found"

    # Create installation instructions
    cat > "$DIST_DIR/INSTALL.txt" << EOF
File Sorter Pro - Installation Instructions
==========================================

GUI Version:
- Double-click 'FileSorter${EXE_EXT}' to start the graphical interface

CLI Version:
- Run './file-sorter-cli${EXE_EXT}' from terminal/command prompt

System Requirements:
- No additional software required (standalone executables)
- Compatible with $PLATFORM ($ARCH)

Version: $VERSION
Built on: $(date)
Platform: $PLATFORM-$ARCH
Author: Olagunju Matthew
Repository: https://github.com/Matthew-123-dev/File_sorting_script
EOF

    # Make executables executable (Unix-like systems)
    if [ "$PLATFORM" != "windows" ]; then
        chmod +x "$DIST_DIR/FileSorter" 2>/dev/null || true
        chmod +x "$DIST_DIR/file-sorter-cli" 2>/dev/null || true
    fi

    # Create archive
    print_status "Creating archive..."
    cd releases/
    if command -v zip >/dev/null 2>&1; then
        zip -r "${DIST_NAME}.zip" "$DIST_NAME/"
        print_success "Created ${DIST_NAME}.zip"
    elif command -v tar >/dev/null 2>&1; then
        tar -czf "${DIST_NAME}.tar.gz" "$DIST_NAME/"
        print_success "Created ${DIST_NAME}.tar.gz"
    fi
    cd ..

    # Display results
    echo ""
    print_header "🎉 Build Complete!"
    print_success "Platform: $PLATFORM-$ARCH"
    print_success "Distribution: releases/${DIST_NAME}/"
    
    echo ""
    print_status "Files created:"
    ls -la "releases/${DIST_NAME}/"
}

# Main execution
case "${1:-current}" in
    "current")
        build_current_platform
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [option]"
        echo ""
        echo "Options:"
        echo "  current    Build for current platform (default)"
        echo "  help       Show this help message"
        echo ""
        echo "For cross-platform builds, use GitHub Actions or build on target platforms."
        ;;
    *)
        print_error "Unknown option: $1"
        print_status "Use '$0 help' for usage information"
        exit 1
        ;;
esac
