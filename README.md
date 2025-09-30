# File Sorter 

A modern, cross-platform file sorting application with both GUI and CLI interfaces. Organize your files efficiently by type, date, alphabetically, or size with a beautiful dark-themed interface.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Python](https://img.shields.io/badge/python-3.7+-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey.svg)

**Author:** Olagunju Matthew  
**Contact:** olagunjunifemi6@gmail.com  
**Repository:** https://github.com/Matthew-123-dev/File_sorting_script

## Features

### 🎨 Modern GUI Interface
- **Dark theme** with clean, professional design
- **Real-time progress tracking** with progress bar and detailed logs
- **File preview** functionality to see what will be sorted
- **Intuitive controls** with clear labeling and helpful messages

### 📁 Sorting Methods
1. **By File Type**: Organizes files into folders based on their extensions (pdf, jpg, txt, etc.)
2. **By Date**: Groups files by creation date (Mon_YYYY format)
3. **Alphabetically**: Sorts files into folders by first letter (A, B, C, etc.)
4. **By Size**: Categorizes files by size (Tiny, Small, Medium, Large, Huge)

### 🛡️ Safety Features
- **Path checking**: Only moves files if they're not already in the correct location
- **Error handling**: Continues operation even if some files can't be moved
- **Preview mode**: See what will happen before making changes
- **Progress tracking**: Real-time updates on sorting progress
- **Empty folder cleanup**: Automatically removes empty folders after sorting

## Installation

### Option 1: Download Pre-built Executables

**📦 Pre-built executables are now available on the [Releases page](https://github.com/Matthew-123-dev/File_sorting_script/releases)**

Currently available:
- ✅ **Linux (64-bit)**: Ready for download
- ✅ **Windows (64-bit)**: Ready for download
- 🔄 **macOS (Intel/Apple Silicon)**: Coming soon

In order to run the application, follow these steps:
1. Go to the [Releases page](https://github.com/Matthew-123-dev/File_sorting_script/releases)
2. Download the appropriate version for your operating system
3. Extract the downloaded zip file
4. Run the application directly (no Python installation required!)

### Option 2: Install from Source

**For developers or users who want to run from source:**

#### Prerequisites
- **Python 3.7 or higher**
- **Git** (to clone the repository)

#### Platform-Specific Setup

<details>
<summary><b>🪟 Windows</b></summary>

1. **Install Python**:
   - Download from [python.org](https://www.python.org/downloads/)
   - During installation, check "Add Python to PATH"

2. **Install Git**:
   - Download from [git-scm.com](https://git-scm.com/download/win)

3. **Clone and Setup**:
   ```cmd
   git clone https://github.com/Matthew-123-dev/File_sorting_script.git
   cd File_sorting_script
   python -m venv .venv
   .venv\Scripts\activate
   pip install -r requirements.txt
   ```

4. **Run the Application**:
   ```cmd
   python gui.py
   ```

</details>

<details>
<summary><b>🍎 macOS</b></summary>

1. **Install Python and Git**:
   ```bash
   # Using Homebrew (recommended)
   brew install python git
   
   # Or download Python from python.org
   ```

2. **Clone and Setup**:
   ```bash
   git clone https://github.com/Matthew-123-dev/File_sorting_script.git
   cd File_sorting_script
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```

3. **Run the Application**:
   ```bash
   python gui.py
   ```

</details>

<details>
<summary><b>🐧 Linux</b></summary>

1. **Install Prerequisites**:
   ```bash
   # Ubuntu/Debian
   sudo apt update
   sudo apt install python3 python3-pip python3-venv python3-tk git
   
   # Fedora/CentOS/RHEL
   sudo dnf install python3 python3-pip python3-tkinter git
   
   # Arch Linux
   sudo pacman -S python python-pip tk git
   ```

2. **Clone and Setup**:
   ```bash
   git clone https://github.com/Matthew-123-dev/File_sorting_script.git
   cd File_sorting_script
   python3 -m venv .venv
   source .venv/bin/activate
   pip install -r requirements.txt
   ```

3. **Run the Application**:
   ```bash
   python gui.py
   ```

</details>

### Option 3: Build Your Own Executable

**To create your own executable for distribution:**

1. Follow the "Install from Source" steps above
2. Install PyInstaller:
   ```bash
   pip install pyinstaller>=5.0
   ```
3. Build the executable:
   ```bash
   ./build_app.sh    # Linux/macOS
   build_app.bat     # Windows (if available)
   ```
4. Find your executable in the `releases/` directory

## Usage

### Pre-built Executable (Easiest)
1. **Download** the appropriate executable for your platform
2. **Extract** the zip file
3. **Run**:
   - **GUI Version**: Double-click `FileSorter` (or `FileSorter.exe` on Windows)
   - **CLI Version**: Open terminal/command prompt and run `./file-sorter-cli` (or `file-sorter-cli.exe` on Windows)

### From Source Code
```bash
# Activate virtual environment first (if using)
source .venv/bin/activate  # Linux/macOS
# or
.venv\Scripts\activate     # Windows

# GUI Application (Recommended)
python gui.py
# or
python run_gui.py

# Command Line Interface
python main.py
```

## How to Use the GUI

1. **Select Folder**: Click "Browse" to choose the folder you want to sort
2. **Choose Method**: Select your preferred sorting method from the dropdown
3. **Preview Files** (Optional): Click "Preview Files" to see what files will be processed
4. **Start Sorting**: Click "Start Sorting" to begin the process
5. **Monitor Progress**: Watch the progress bar and log for real-time updates

## File Structure

```
File_sorting_script/
├── main.py           # Core FileSorterApp class and CLI interface
├── gui.py            # Modern CustomTkinter GUI interface
├── run_gui.py        # GUI launcher script
├── requirements.txt  # Python dependencies
├── README.md         # This file
└── test.py          # Original CLI version (for reference)
```

## GUI Features Explained

### Main Interface
- **Title Section**: Application name and description
- **Folder Selection**: Browse and select the folder to sort
- **Method Selection**: Choose from 4 sorting methods
- **File Count**: Shows how many files are in the selected folder
- **Control Buttons**: Preview and start sorting operations
- **Progress Section**: Real-time progress bar and detailed log
- **Status Bar**: Current operation status

### Progress Tracking
The application provides detailed progress information:
- **File scanning progress**: Shows when files are being discovered
- **Move operations**: Individual file movements with progress count
- **Error handling**: Warnings for files that can't be processed
- **Completion status**: Final summary of operations

### Safety Measures
- **Confirmation dialog**: Asks for confirmation before starting
- **Non-destructive**: Only moves files, never deletes
- **Path validation**: Ensures target folder exists and is writable
- **Error recovery**: Continues operation even if some files fail

## Sorting Methods Details

### By File Type
- Creates folders named after file extensions (without the dot)
- Files without extensions go to "No_Extension" folder
- Examples: `pdf/`, `jpg/`, `txt/`, `No_Extension/`

### By Date
- Uses file creation time to determine date
- Creates folders in "Mon_YYYY" format
- Examples: `Jan_2024/`, `Dec_2023/`

### Alphabetically  
- Creates folders for each starting letter
- Case-insensitive sorting
- Examples: `A/`, `B/`, `C/`, `1/`

### By Size
- **Tiny**: < 10KB
- **Small**: 10KB - 1MB  
- **Medium**: 1MB - 100MB
- **Large**: 100MB - 1GB
- **Huge**: > 1GB

## Troubleshooting

### Common Issues

**GUI won't start**:
- Ensure tkinter is installed: `sudo apt install python3-tk` (Linux)
- Install CustomTkinter: `pip install customtkinter`

**Permission errors**:
- Ensure you have write permissions to the target folder
- Try running with elevated privileges if necessary

**Files not moving**:
- Check if files are already in the correct location
- Verify folder permissions
- Check the progress log for specific error messages

### Error Messages
- **"No Folder"**: Select a folder before starting
- **"Invalid Folder"**: Chosen path doesn't exist or isn't accessible
- **"Already Sorting"**: Wait for current operation to complete
- **File-specific warnings**: Individual files that couldn't be processed

## Development

### Code Structure
The application uses a clean separation between GUI and logic:

- **`FileSorterApp`**: Core sorting logic with callback support
- **`FileSorterGUI`**: CustomTkinter-based user interface
- **Threading**: GUI operations run in separate thread to prevent freezing

### Extending the Application
To add new sorting methods:
1. Add the method name to `SORTING_METHODS` dictionary in `FileSorterApp`
2. Implement the sorting method in `FileSorterApp` class
3. The GUI will automatically detect and include the new method

## System Requirements

### Minimum Requirements
- **OS**: Windows 10+, macOS 10.14+, or Linux (most distributions)
- **RAM**: 256MB available memory
- **Storage**: 50MB free space
- **Display**: 1024x768 resolution or higher

### For Source Installation
- **Python**: 3.7 or higher
- **Libraries**: customtkinter, tkinter (usually included with Python)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Olagunju Matthew

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## Support

- **Issues**: [GitHub Issues](https://github.com/Matthew-123-dev/File_sorting_script/issues)
- **Email**: olagunjunifemi6@gmail.com
- **Discussions**: [GitHub Discussions](https://github.com/Matthew-123-dev/File_sorting_script/discussions)

## Contributing

Contributions are welcome! Here's how you can help:

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** your changes: `git commit -m 'Add some amazing feature'`
4. **Push** to the branch: `git push origin feature/amazing-feature`
5. **Open** a Pull Request

### Development Setup
```bash
git clone https://github.com/Matthew-123-dev/File_sorting_script.git
cd File_sorting_script
python -m venv .venv
source .venv/bin/activate  # or .venv\Scripts\activate on Windows
pip install -r requirements.txt
pip install -e .  # Install in development mode
```

## Changelog

### Version 1.0.0 (2025-09-28)
- Initial release
- GUI interface with CustomTkinter
- CLI interface
- Four sorting methods (type, date, alphabetical, size)
- Cross-platform executables
- Progress tracking and error handling

## Roadmap

- [ ] Drag and drop file selection
- [ ] Custom sorting rules
- [ ] Batch processing multiple folders
- [ ] Integration with cloud storage services
- [ ] Dark/Light theme toggle
- [ ] Localization support

---

**Made with ❤️ by Olagunju Matthew**
