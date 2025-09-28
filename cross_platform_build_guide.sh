#!/bin/bash

# Cross-Platform Build Guide for File Sorter Pro
# This script provides instructions for building on different platforms

echo "🌍 Cross-Platform Build Guide for File Sorter Pro"
echo "================================================="

cat << 'EOF'

## Method 1: Build on Each Platform (Recommended)

### 🪟 Windows Build
1. **Setup Windows Environment:**
   - Install Python 3.7+ from python.org
   - Install Git for Windows
   
2. **Clone and Build:**
   ```cmd
   git clone https://github.com/Matthew-123-dev/File_sorting_script.git
   cd File_sorting_script
   python -m venv .venv
   .venv\Scripts\activate
   pip install -r requirements.txt
   pip install pyinstaller>=5.0
   ```

3. **Build Windows Executable:**
   ```cmd
   pyinstaller gui.py ^
     --onefile ^
     --windowed ^
     --name="FileSorter" ^
     --add-data "main.py;." ^
     --hidden-import customtkinter ^
     --hidden-import tkinter ^
     --clean ^
     --noconfirm

   pyinstaller main.py ^
     --onefile ^
     --name="file-sorter-cli" ^
     --console ^
     --clean ^
     --noconfirm
   ```

### 🍎 macOS Build
1. **Setup macOS Environment:**
   ```bash
   # Install Homebrew if not already installed
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   
   # Install Python and Git
   brew install python git
   ```

2. **Clone and Build:**
   ```bash
   git clone https://github.com/Matthew-123-dev/File_sorting_script.git
   cd File_sorting_script
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   pip install pyinstaller>=5.0
   ```

3. **Build macOS Executable:**
   ```bash
   pyinstaller gui.py \
     --onefile \
     --windowed \
     --name="FileSorter" \
     --add-data "main.py:." \
     --hidden-import customtkinter \
     --hidden-import tkinter \
     --clean \
     --noconfirm

   pyinstaller main.py \
     --onefile \
     --name="file-sorter-cli" \
     --console \
     --clean \
     --noconfirm
   ```

## Method 2: Cross-Compilation (Advanced)

### Using GitHub Actions (Automated)
Create automated builds for all platforms using GitHub Actions.

### Using Docker (Complex)
Build Windows executables using Wine in Docker containers.

## Method 3: Virtual Machines
- Use VirtualBox or VMware to run Windows/macOS
- Build directly on those systems

EOF

echo ""
echo "🚀 Quick Start for Current Platform Detection:"

# Detect current platform
case "$(uname -s)" in
    Linux*)     
        echo "✅ Current Platform: Linux"
        echo "You've already built for Linux!"
        echo ""
        echo "To build for other platforms:"
        echo "1. Windows: Need Windows machine or VM"
        echo "2. macOS: Need macOS machine or VM"
        ;;
    Darwin*)    
        echo "✅ Current Platform: macOS"
        echo "You can build for macOS right now!"
        echo ""
        echo "Run: ./build_cross_platform.sh macos"
        ;;
    CYGWIN*|MINGW*|MSYS*) 
        echo "✅ Current Platform: Windows"
        echo "You can build for Windows right now!"
        echo ""
        echo "Run: ./build_cross_platform.sh windows"
        ;;
    *)          
        echo "❓ Platform: Unknown"
        ;;
esac

echo ""
echo "💡 Recommended Approach:"
echo "1. Use GitHub Actions for automated cross-platform builds"
echo "2. Or ask friends/community with different OS to build"
echo "3. Or use cloud VMs (AWS, Azure, GCP)"
