# File Sorter Pro

A modern, user-friendly GUI application for organizing and sorting files by type, date, alphabetically, or size.

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

### Prerequisites
- Python 3.7 or higher
- tkinter (usually comes with Python, or install with `sudo apt install python3-tk` on Ubuntu/Debian)

### Setup
1. Clone or download this repository
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Usage

### GUI Application (Recommended)
Run the GUI version:
```bash
python gui.py
# or
python run_gui.py
```

### Command Line Interface
For CLI usage:
```bash
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

## License

This project is open source. Feel free to modify and distribute.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.
