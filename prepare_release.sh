#!/bin/bash

# GitHub Release Preparation Script
# This script prepares release assets for upload to GitHub

set -e

echo "🚀 Preparing GitHub Release Assets..."
echo "===================================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
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

VERSION="1.0.0"
RELEASE_DIR="releases"

print_status "Checking existing releases..."

if [ ! -d "$RELEASE_DIR" ]; then
    mkdir -p "$RELEASE_DIR"
    print_status "Created releases directory"
fi

# List current releases
print_status "Current release assets:"
ls -la "$RELEASE_DIR"/ | grep -E '\.(zip|tar\.gz)$' || echo "No release archives found"

echo ""
print_status "Release Preparation Options:"
echo "1. Upload existing Linux build to GitHub"
echo "2. Build for current platform and prepare for upload"
echo "3. Create cross-platform build instructions"

echo ""
print_warning "To create a GitHub release, you'll need to:"
echo "1. Push your code to GitHub first"
echo "2. Create a release tag (e.g., v1.0.0)"
echo "3. Upload the release assets"

echo ""
print_status "Commands to create GitHub release:"
echo ""
echo "# 1. Commit and push your code"
echo "git add ."
echo "git commit -m 'Release v${VERSION}: File Sorter Pro with GUI and CLI'"
echo "git push origin main"
echo ""
echo "# 2. Create and push a tag"
echo "git tag -a v${VERSION} -m 'Release v${VERSION}'"
echo "git push origin v${VERSION}"
echo ""
echo "# 3. Then go to GitHub and create a release using the tag"
echo "# Upload these files as release assets:"

echo ""
print_success "Available release assets to upload:"
find "$RELEASE_DIR" -name "*.zip" -o -name "*.tar.gz" | while read file; do
    size=$(ls -lh "$file" | awk '{print $5}')
    echo "  📦 $(basename "$file") (${size})"
done

echo ""
print_status "GitHub Release Creation Steps:"
echo "1. Go to: https://github.com/Matthew-123-dev/File_sorting_script/releases"
echo "2. Click 'Create a new release'"
echo "3. Choose tag: v${VERSION}"
echo "4. Release title: 'File Sorter v${VERSION}'"
echo "5. Upload the zip files from releases/ directory"
echo "6. Add release notes (see below)"

echo ""
print_status "Suggested Release Notes:"
cat << 'EOF'

## File Sorter Pro v1.0.0

A modern, cross-platform file sorting application with both GUI and CLI interfaces.

### 🎯 Features
- **Modern GUI** with dark theme and real-time progress tracking
- **4 Sorting Methods**: File type, Date, Alphabetical, Size
- **Cross-platform**: Windows, macOS, and Linux support
- **Safety features**: Path checking and error handling
- **Both GUI and CLI** interfaces available

### 📦 Downloads
Choose the appropriate version for your operating system:

- **Linux (64-bit)**: FileSorter-1.0.0-linux-x86_64.zip
- **Windows (64-bit)**: FileSorter-1.0.0-windows-x86_64.zip (coming soon)
- **macOS (Intel)**: FileSorter-1.0.0-macos-x86_64.zip (coming soon)
- **macOS (Apple Silicon)**: FileSorter-1.0.0-macos-arm64.zip (coming soon)

### 🚀 Quick Start
1. Download the appropriate file for your OS
2. Extract the zip file
3. Run `FileSorter` (GUI) or `file-sorter-cli` (CLI)
4. No Python installation required!

### 📋 System Requirements
- **OS**: Windows 10+, macOS 10.14+, or Linux
- **RAM**: 256MB available memory
- **Storage**: 50MB free space

### 🐛 Bug Reports
Report issues at: https://github.com/Matthew-123-dev/File_sorting_script/issues

---
**Full Changelog**: https://github.com/Matthew-123-dev/File_sorting_script/commits/v1.0.0
EOF

echo ""
print_success "Release preparation complete!"
print_warning "Remember to test your application before creating the release!"

# Test the current build
if [ -f "$RELEASE_DIR/FileSorter-1.0.0-linux-x86_64.zip" ]; then
    echo ""
    print_status "Testing current Linux build..."
    cd "$RELEASE_DIR"
    if [ ! -d "FileSorter-1.0.0-linux-x86_64" ]; then
        unzip -q "FileSorter-1.0.0-linux-x86_64.zip"
    fi
    
    if [ -f "FileSorter-1.0.0-linux-x86_64/FileSorter" ]; then
        print_success "GUI executable found and ready"
    fi
    
    if [ -f "FileSorter-1.0.0-linux-x86_64/file-sorter-cli" ]; then
        print_success "CLI executable found and ready"
    fi
    
    cd ..
fi
