import os
import time
import re
from pathlib import Path
import shutil
from typing import List, Dict, Callable, Optional, Tuple

class FileSorterApp:
    """
    A file sorting application that can organize files by type, date, alphabetically, or size.
    Designed to be GUI-friendly with callback support for progress updates.
    """
    
    # Available sorting methods
    SORTING_METHODS = {
        'By File Type': 'sort_by_file_type',
        'By Date': 'sort_by_date', 
        'Alphabetically': 'sort_alphabetically',
        'By Size': 'sort_by_size'
    }
    
    def __init__(self, progress_callback: Optional[Callable[[str], None]] = None):
        """
        Initialize the FileSorter application.
        
        Args:
            progress_callback: Optional function to call with progress messages for GUI updates
        """
        self.progress_callback = progress_callback or self._default_progress_callback
        self.file_list = []
        self.folder_path = ""
        
    def _default_progress_callback(self, message: str):
        """Default progress callback that prints to console."""
        print(message)
        
    def _log_progress(self, message: str):
        """Log progress using the callback."""
        if self.progress_callback:
            self.progress_callback(message)

    def validate_folder_path(self, folder_path: str) -> bool:
        """
        Validate if the folder path exists and is accessible.
        
        Args:
            folder_path: Path to validate
            
        Returns:
            bool: True if valid, False otherwise
        """
        if not folder_path or not folder_path.strip():
            self._log_progress('Error: No folder path provided.')
            return False
            
        if not os.path.exists(folder_path):
            self._log_progress('Error: Path does not exist or is invalid!')
            return False
            
        if not os.path.isdir(folder_path):
            self._log_progress('Error: Path is not a directory!')
            return False
            
        self._log_progress('Path validated successfully.')
        return True

    def scan_files(self, folder_path: str) -> List[Dict]:
        """
        Scan folder and generate list of all files with metadata.
        
        Args:
            folder_path: Path to scan
            
        Returns:
            List of file dictionaries with metadata
        """
        file_list = []
        try:
            for root, dirs, files in os.walk(folder_path):
                for filename in files:
                    file_path = os.path.join(root, filename)
                    try:
                        file_list.append({
                                'filepath': file_path,
                                'filename': os.path.basename(file_path),
                                'modified_time': os.path.getmtime(file_path),
                                'file_extension': os.path.splitext(file_path)[1],
                                'size': os.path.getsize(file_path)
                            })
                    except (OSError, PermissionError) as e:
                        self._log_progress(f'Warning: Could not access file {file_path}: {e}')
                        continue
        except (OSError, PermissionError) as e:
            self._log_progress(f'Error accessing folder {folder_path}: {e}')
            return []

        return file_list

    def delete_empty_folders(self, folder_path: str):
        """Delete empty folders in the directory tree."""
        for dirpath, dirs, files in os.walk(folder_path, topdown=False):
            if not dirs and not files:
                try:
                    os.rmdir(dirpath)
                    self._log_progress(f'Deleted empty folder: {dirpath}')
                except OSError as e:
                    self._log_progress(f'Error deleting folder: {e}')

    def sort_by_file_type(self, folder_path: str, file_list: List[Dict]) -> bool:
        """
        Sort files by their file extensions.
        
        Args:
            folder_path: Target directory path
            file_list: List of file dictionaries
            
        Returns:
            bool: True if successful, False otherwise
        """
        try:
            self._log_progress('Sorting by file type...')
            file_extensions = [file['file_extension'] for file in file_list]
            
            unique_extensions = set(file_extensions)
            unique_extensions.discard('')  # Remove empty string for files with no extension
            self._log_progress(f'Unique file extensions found: {unique_extensions}')
            
            self._log_progress('Moving files to respective folders...')
            total_files = len(file_list)
            processed_files = 0
            
            # Create No_Extension folder
            no_ext_folder = os.path.join(folder_path, 'No_Extension')
            os.makedirs(no_ext_folder, exist_ok=True)
            
            # Create extension folders
            for ext in unique_extensions:
                ext_folder = os.path.join(folder_path, ext.lstrip('.'))
                os.makedirs(ext_folder, exist_ok=True)
            
            # Process each file
            for file in file_list:
                try:
                    if file['file_extension']:  # File has extension
                        target_folder = os.path.join(folder_path, file['file_extension'].lstrip('.'))
                        target = os.path.join(target_folder, file['filename'])
                        folder_name = file['file_extension'].lstrip('.')
                    else:  # File has no extension
                        target = os.path.join(no_ext_folder, file['filename'])
                        folder_name = 'No_Extension'
                    
                    # Only move if not already in correct location
                    if Path(file['filepath']).parent != Path(target).parent:
                        shutil.move(file['filepath'], str(target))
                        file['filepath'] = str(target)
                        processed_files += 1
                        self._log_progress(f'Progress: {processed_files}/{total_files} - Moved {file["filename"]} to {folder_name}/')
                        
                except (OSError, PermissionError, shutil.Error) as e:
                    self._log_progress(f'Warning: Could not move {file["filename"]}: {e}')
                    continue
            
            self._log_progress(f'Files moved successfully. Processed {processed_files} out of {total_files} files.')
            self._log_progress('Deleting empty folders...')
            self.delete_empty_folders(folder_path)
            return True
            
        except Exception as e:
            self._log_progress(f'Error during file type sorting: {e}')
            return False

    def sort_by_date(self, folder_path: str, file_list: List[Dict]) -> bool:
        """
        Sort files by their creation date.
        
        Args:
            folder_path: Target directory path
            file_list: List of file dictionaries
            
        Returns:
            bool: True if successful, False otherwise
        """
        try:
            self._log_progress('Sorting by date...')
            date_to_files = {}
            
            for file in file_list:
                creation_time = os.path.getctime(file['filepath'])
                readable_time = time.ctime(creation_time)
                file_date = readable_time[4:7] + '_' + readable_time[-4:]
                if file_date not in date_to_files:
                    date_to_files[file_date] = []
                date_to_files[file_date].append(file)
            
            unique_dates = set(date_to_files.keys())
            self._log_progress(f'Unique dates found: {unique_dates}')
            self._log_progress('Moving files to respective folders...')
            
            total_files = len(file_list)
            processed_files = 0
            
            for date, files in date_to_files.items():
                date_folder = os.path.join(folder_path, date)
                os.makedirs(date_folder, exist_ok=True)
                for file in files:
                    try:
                        target = os.path.join(date_folder, file['filename'])
                        target_path = Path(target)
                        if Path(file['filepath']).parent != target_path.parent:
                            shutil.move(file['filepath'], str(target))
                            file['filepath'] = str(target)
                            processed_files += 1
                            self._log_progress(f'Progress: {processed_files}/{total_files} - Moved {file["filename"]} to {date}/')
                    except (OSError, PermissionError, shutil.Error) as e:
                        self._log_progress(f'Warning: Could not move {file["filename"]}: {e}')
                        continue
            
            self._log_progress(f'Files moved successfully. Processed {processed_files} out of {total_files} files.')
            self._log_progress('Deleting empty folders...')
            self.delete_empty_folders(folder_path)
            return True
            
        except Exception as e:
            self._log_progress(f'Error during date sorting: {e}')
            return False

    def sort_alphabetically(self, folder_path: str, file_list: List[Dict]) -> bool:
        """
        Sort files alphabetically by their first character.
        
        Args:
            folder_path: Target directory path
            file_list: List of file dictionaries
            
        Returns:
            bool: True if successful, False otherwise
        """
        try:
            self._log_progress('Sorting alphabetically...')
            file_names = [file['filename'] for file in file_list]
            
            alphabet_list = []
            for file_name in file_names:
                first_char = file_name[0].upper()
                if first_char not in alphabet_list:
                    alphabet_list.append(first_char)
            
            alphabet_list = sorted(alphabet_list)
            self._log_progress(f'Unique starting characters found: {alphabet_list}')
            self._log_progress('Moving files to respective folders...')
            
            total_files = len(file_list)
            processed_files = 0
            
            # Create folders for each character
            for char in alphabet_list:
                char_folder = os.path.join(folder_path, char)
                os.makedirs(char_folder, exist_ok=True)
            
            for file in file_list:
                try:
                    first_char = file['filename'][0].upper()
                    char_folder = os.path.join(folder_path, first_char)
                    target = os.path.join(char_folder, file['filename'])
                    target_path = Path(target)
                    
                    if Path(file['filepath']).parent != target_path.parent:
                        shutil.move(file['filepath'], str(target))
                        file['filepath'] = str(target)
                        processed_files += 1
                        self._log_progress(f'Progress: {processed_files}/{total_files} - Moved {file["filename"]} to {first_char}/')
                except (OSError, PermissionError, shutil.Error) as e:
                    self._log_progress(f'Warning: Could not move {file["filename"]}: {e}')
                    continue
            
            self._log_progress(f'Files moved successfully. Processed {processed_files} out of {total_files} files.')
            self._log_progress('Deleting empty folders...')
            self.delete_empty_folders(folder_path)
            return True
            
        except Exception as e:
            self._log_progress(f'Error during alphabetical sorting: {e}')
            return False

    def sort_by_size(self, folder_path: str, file_list: List[Dict]) -> bool:
        """
        Sort files by their size.
        
        Args:
            folder_path: Target directory path
            file_list: List of file dictionaries
            
        Returns:
            bool: True if successful, False otherwise
        """
        try:
            self._log_progress('Sorting by file size...')
            
            def classify_file_size(size):
                KB = 1024; MB = KB * 1024; GB = MB * 1024
                if size < 10 * KB:
                    return 'Tiny (<10KB)'
                elif size < 1 * MB:
                    return 'Small (10KB-1MB)'
                elif size < 100 * MB:
                    return 'Medium (1MB-100MB)'
                elif size < 1 * GB:
                    return 'Large (100MB-1GB)'
                else:
                    return 'Huge (>1GB)'

            total_files = len(file_list)
            processed_files = 0
            
            # Get all categories and create folders
            categories = set()
            for file in file_list:
                categories.add(classify_file_size(file['size']))
            
            for category in categories:
                category_folder = os.path.join(folder_path, category)
                os.makedirs(category_folder, exist_ok=True)
            
            for file in file_list:
                try:
                    category = classify_file_size(file['size'])
                    category_folder = os.path.join(folder_path, category)
                    target = os.path.join(category_folder, file['filename'])
                    target_path = Path(target)
                    
                    if Path(file['filepath']).parent != target_path.parent:
                        shutil.move(file['filepath'], str(target))
                        file['filepath'] = str(target)
                        processed_files += 1
                        self._log_progress(f'Progress: {processed_files}/{total_files} - Moved {file["filename"]} to {category}/')
                except (OSError, PermissionError, shutil.Error) as e:
                    self._log_progress(f'Warning: Could not move {file["filename"]}: {e}')
                    continue
            
            self._log_progress(f'Files moved successfully. Processed {processed_files} out of {total_files} files.')
            self._log_progress('Deleting empty folders...')
            self.delete_empty_folders(folder_path)
            return True
            
        except Exception as e:
            self._log_progress(f'Error during size sorting: {e}')
            return False

    def sort_files(self, folder_path: str, sorting_method: str) -> bool:
        """
        Main method to sort files using the specified method.
        
        Args:
            folder_path: Path to the folder to sort
            sorting_method: One of the keys from SORTING_METHODS
            
        Returns:
            bool: True if sorting was successful, False otherwise
        """
        # Validate inputs
        if not self.validate_folder_path(folder_path):
            return False
        
        if sorting_method not in self.SORTING_METHODS:
            self._log_progress(f'Error: Invalid sorting method "{sorting_method}"')
            return False
        
        # Scan files
        self._log_progress('Scanning files...')
        file_list = self.scan_files(folder_path)
        
        if not file_list:
            self._log_progress('No files found in the specified folder or unable to access files.')
            return False
        
        self._log_progress(f'Found {len(file_list)} files to sort.')
        
        # Execute sorting method
        method_name = self.SORTING_METHODS[sorting_method]
        method = getattr(self, method_name)
        success = method(folder_path, file_list)
        
        if success:
            self._log_progress('Sorting operation completed successfully!')
        else:
            self._log_progress('Sorting operation failed.')
            
        return success

    @staticmethod
    def get_available_sorting_methods() -> List[str]:
        """Get list of available sorting methods."""
        return list(FileSorterApp.SORTING_METHODS.keys())

# CLI Interface Functions (for backward compatibility)
def select_sorting_method():
    """CLI function to select sorting method."""
    sorting_options = FileSorterApp.get_available_sorting_methods()
    print('Select a sorting method:')
    for i, option in enumerate(sorting_options, start=1):
        print(f'{i}. {option}')
    
    try:
        choice = int(input('Enter the number corresponding to your choice: '))
        if 1 <= choice <= len(sorting_options):
            return sorting_options[choice - 1]
        else:
            print('Invalid choice. Please try again.')
            return select_sorting_method()
    except ValueError:
        print('Please enter a valid number.')
        return select_sorting_method()
    except KeyboardInterrupt:
        print('\nOperation cancelled by user.')
        exit(0)


def main():
    """Main function for CLI usage."""
    try:
        # Get user input
        sorting_method = select_sorting_method()
        folder_path = input('Type in your desired folder path: ').strip()
        
        # Create FileSorter instance
        sorter = FileSorterApp()
        
        # Sort files
        success = sorter.sort_files(folder_path, sorting_method)
        
        if not success:
            print('Sorting operation failed. Please check the error messages above.')
            exit(1)

    except KeyboardInterrupt:
        print('\nOperation cancelled by user.')
        exit(0)
    except Exception as e:
        print(f'Unexpected error: {e}')
        exit(1)


if __name__ == '__main__':
    main()

        

        

