#!/bin/bash

# File Sorter - Cross-Platform Build Script
# This script builds executable versions of the File Sorter application

set -e  # Exit on any error

echo "🚀 Building File Sorter Application..."
echo "======================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if virtual environment is activated
if [[ "$VIRTUAL_ENV" == "" ]]; then
    print_warning "Virtual environment not detected. Attempting to activate..."
    if [ -f ".venv/bin/activate" ]; then
        source .venv/bin/activate
        print_success "Activated virtual environment"
    else
        print_error "No virtual environment found. Please create one first:"
        echo "python -m venv .venv"
        echo "source .venv/bin/activate"
        echo "pip install -r requirements.txt"
        exit 1
    fi
fi

# Check if required packages are installed
print_status "Checking dependencies..."
python -c "import customtkinter, tkinter" 2>/dev/null || {
    print_error "Required packages not found. Installing..."
    pip install -r requirements.txt
}

python -c "import PyInstaller" 2>/dev/null || {
    print_error "PyInstaller not found. Installing..."
    pip install pyinstaller>=5.0
}

print_success "All dependencies available"

# Clean previous builds
print_status "Cleaning previous builds..."
rm -rf build/ dist/ __pycache__/ *.pyc
rm -rf FileSorter-*/ 
print_success "Cleaned build directories"

# Build the application
print_status "Building GUI application..."
pyinstaller FileSorter.spec --clean --noconfirm

if [ $? -eq 0 ]; then
    print_success "GUI build completed successfully!"
else
    print_error "GUI build failed!"
    exit 1
fi

# Build CLI version separately
print_status "Building CLI application..."
pyinstaller main.py \
    --onefile \
    --name="file-sorter-cli" \
    --console \
    --clean \
    --noconfirm \
    --exclude-module tkinter \
    --exclude-module customtkinter \
    --exclude-module PIL

if [ $? -eq 0 ]; then
    print_success "CLI build completed successfully!"
else
    print_warning "CLI build failed, but GUI build succeeded"
fi

# Get system information for naming
OS_NAME=$(uname -s)
ARCH=$(uname -m)
VERSION="1.0.0"

case "$OS_NAME" in
    Linux*)     PLATFORM="linux";;
    Darwin*)    PLATFORM="macos";;
    CYGWIN*|MINGW*|MSYS*) PLATFORM="windows";;
    *)          PLATFORM="unknown";;
esac

# Create distribution directory
DIST_NAME="FileSorter-${VERSION}-${PLATFORM}-${ARCH}"
DIST_DIR="releases/${DIST_NAME}"

print_status "Creating distribution package..."
mkdir -p "$DIST_DIR"

# Copy executables
if [ -f "dist/FileSorter" ]; then
    cp "dist/FileSorter" "$DIST_DIR/"
elif [ -f "dist/FileSorter.exe" ]; then
    cp "dist/FileSorter.exe" "$DIST_DIR/"
fi

if [ -f "dist/file-sorter-cli" ]; then
    cp "dist/file-sorter-cli" "$DIST_DIR/"
elif [ -f "dist/file-sorter-cli.exe" ]; then
    cp "dist/file-sorter-cli.exe" "$DIST_DIR/"
fi

# Copy documentation and requirements
cp README.md "$DIST_DIR/" 2>/dev/null || echo "README.md not found"
cp requirements.txt "$DIST_DIR/" 2>/dev/null || echo "requirements.txt not found"

# Create installation instructions
cat > "$DIST_DIR/INSTALL.txt" << EOF
File Sorter - Installation Instructions
======================================

GUI Version:
- Double-click 'FileSorter' (Linux/macOS) or 'FileSorter.exe' (Windows)
- The application will start with a graphical interface

CLI Version:
- Run 'file-sorter-cli' (Linux/macOS) or 'file-sorter-cli.exe' (Windows) from terminal
- Follow the command-line prompts

System Requirements:
- No additional software required (standalone executables)
- Compatible with $PLATFORM ($ARCH)

For more information, see README.md

Version: $VERSION
Built on: $(date)
Platform: $PLATFORM-$ARCH
EOF

# Make executables... executable (Linux/macOS)
if [ "$PLATFORM" != "windows" ]; then
    chmod +x "$DIST_DIR/FileSorter" 2>/dev/null
    chmod +x "$DIST_DIR/file-sorter-cli" 2>/dev/null
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
else
    print_warning "No archiving tool found. Distribution folder created at releases/${DIST_NAME}/"
fi
cd ..

# Display results
echo ""
echo "🎉 Build Complete!"
echo "=================="
print_success "Executable files created in: releases/${DIST_NAME}/"
print_status "Files included:"
ls -la "releases/${DIST_NAME}/"

echo ""
print_status "To distribute your application:"
echo "1. Share the entire 'releases/${DIST_NAME}' folder or archive"
echo "2. Users can run the executables directly without installing Python"
echo "3. GUI version: Double-click FileSorter"
echo "4. CLI version: Run file-sorter-cli from terminal"

echo ""
print_success "Build script completed successfully!"