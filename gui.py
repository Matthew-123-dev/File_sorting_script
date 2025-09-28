import customtkinter as ctk
import tkinter as tk
from tkinter import filedialog, messagebox
import threading
import os
from main import FileSorterApp

# Set appearance mode and color theme
ctk.set_appearance_mode("dark")  # Modes: "System" (standard), "Dark", "Light"
ctk.set_default_color_theme("blue")  # Themes: "blue" (standard), "green", "dark-blue"

class FileSorterGUI:
    def __init__(self):
        self.root = ctk.CTk()
        self.root.title("File Sorter")
        self.root.geometry("900x800")
        self.root.resizable(True, True)
        
        # Initialize the sorting app
        self.sorter = FileSorterApp(progress_callback=self.update_progress)
        self.is_sorting = False
        
        # Create the GUI elements
        self.create_widgets()
        
    def create_widgets(self):
        """Create and arrange all GUI widgets."""
        
        # Main title
        title_label = ctk.CTkLabel(
            self.root,
            text="File Sorter",
            font=ctk.CTkFont(size=24, weight="bold")
        )
        title_label.pack(pady=(20, 10))
        
        # Subtitle
        subtitle_label = ctk.CTkLabel(
            self.root,
            text="Organize your files by type, date, alphabetically, or size",
            font=ctk.CTkFont(size=14),
            text_color="gray"
        )
        subtitle_label.pack(pady=(0, 20))
        
        # Main frame
        main_frame = ctk.CTkFrame(self.root)
        main_frame.pack(padx=20, pady=10, fill="both", expand=True)
        
        # Folder selection section
        folder_frame = ctk.CTkFrame(main_frame)
        folder_frame.pack(padx=20, pady=(10, 10), fill="x")
        
        folder_label = ctk.CTkLabel(
            folder_frame,
            text="Select Folder to Sort:",
            font=ctk.CTkFont(size=16, weight="bold")
        )
        folder_label.pack(pady=(10, 5))
        
        # Folder path entry and browse button frame
        path_frame = ctk.CTkFrame(folder_frame)
        path_frame.pack(padx=15, pady=(0, 10), fill="x")
        
        self.folder_path_var = tk.StringVar()
        self.folder_entry = ctk.CTkEntry(
            path_frame,
            textvariable=self.folder_path_var,
            placeholder_text="Click 'Browse' to select a folder...",
            font=ctk.CTkFont(size=12),
            height=35
        )
        self.folder_entry.pack(side="left", padx=(10, 5), pady=10, fill="x", expand=True)
        
        self.browse_button = ctk.CTkButton(
            path_frame,
            text="Browse",
            command=self.browse_folder,
            width=100,
            height=35
        )
        self.browse_button.pack(side="right", padx=(5, 10), pady=10)
        
        # Sorting method selection
        method_frame = ctk.CTkFrame(main_frame)
        method_frame.pack(padx=20, pady=(0, 10), fill="x")
        
        method_label = ctk.CTkLabel(
            method_frame,
            text="Choose Sorting Method:",
            font=ctk.CTkFont(size=16, weight="bold")
        )
        method_label.pack(pady=(10, 5))
        
        # Get available sorting methods
        self.sorting_methods = FileSorterApp.get_available_sorting_methods()
        self.method_var = tk.StringVar(value=self.sorting_methods[0])
        
        self.method_dropdown = ctk.CTkOptionMenu(
            method_frame,
            variable=self.method_var,
            values=self.sorting_methods,
            font=ctk.CTkFont(size=12),
            dropdown_font=ctk.CTkFont(size=12),
            width=300,
            height=35
        )
        self.method_dropdown.pack(pady=(0, 10))
        
        # File info frame
        info_frame = ctk.CTkFrame(main_frame)
        info_frame.pack(padx=20, pady=(0, 10), fill="x")
        
        self.file_count_label = ctk.CTkLabel(
            info_frame,
            text="Select a folder to see file count",
            font=ctk.CTkFont(size=12),
            text_color="gray"
        )
        self.file_count_label.pack(pady=5)
        
        # Control buttons frame
        button_frame = ctk.CTkFrame(main_frame)
        button_frame.pack(padx=20, pady=(0, 10), fill="x")
        
        buttons_container = ctk.CTkFrame(button_frame)
        buttons_container.pack(pady=10)
        
        self.preview_button = ctk.CTkButton(
            buttons_container,
            text="Preview Files",
            command=self.preview_files,
            width=150,
            height=40,
            font=ctk.CTkFont(size=14)
        )
        self.preview_button.pack(side="left", padx=(0, 10))
        
        self.sort_button = ctk.CTkButton(
            buttons_container,
            text="Start Sorting",
            command=self.start_sorting,
            width=150,
            height=40,
            font=ctk.CTkFont(size=14, weight="bold")
        )
        self.sort_button.pack(side="left", padx=(10, 0))
        
        # Progress section (give it more space)
        progress_frame = ctk.CTkFrame(main_frame)
        progress_frame.pack(padx=20, pady=(0, 10), fill="both", expand=True)
        
        progress_label = ctk.CTkLabel(
            progress_frame,
            text="Progress:",
            font=ctk.CTkFont(size=14, weight="bold")
        )
        progress_label.pack(pady=(15, 5))
        
        # Progress bar
        self.progress_bar = ctk.CTkProgressBar(progress_frame, width=500)
        self.progress_bar.pack(padx=20, pady=(5, 10))
        self.progress_bar.set(0)
        
        # Progress text area
        self.progress_text = ctk.CTkTextbox(
            progress_frame,
            height=500,
            font=ctk.CTkFont(size=11),
            wrap="word"
        )
        self.progress_text.pack(padx=20, pady=(0, 10), fill="both", expand=True)
        
        # Status bar
        self.status_label = ctk.CTkLabel(
            self.root,
            text="Ready",
            font=ctk.CTkFont(size=11),
            text_color="gray"
        )
        self.status_label.pack(side="bottom", padx=10, pady=5, anchor="w")
        
    def browse_folder(self):
        """Open folder selection dialog."""
        folder_path = filedialog.askdirectory(
            title="Select folder to sort",
            initialdir=os.path.expanduser("~")
        )
        
        if folder_path:
            self.folder_path_var.set(folder_path)
            self.update_file_count()
            self.progress_text.delete("1.0", "end")
            self.progress_text.insert("1.0", f"Selected folder: {folder_path}\n")
            self.status_label.configure(text=f"Selected: {os.path.basename(folder_path)}")
            
    def update_file_count(self):
        """Update the file count display."""
        folder_path = self.folder_path_var.get()
        if folder_path and os.path.exists(folder_path):
            try:
                file_list = self.sorter.scan_files(folder_path)
                count = len(file_list)
                self.file_count_label.configure(
                    text=f"Found {count} files in selected folder",
                    text_color="white" if count > 0 else "gray"
                )
            except Exception as e:
                self.file_count_label.configure(
                    text=f"Error reading folder: {str(e)}",
                    text_color="red"
                )
        else:
            self.file_count_label.configure(
                text="Select a folder to see file count",
                text_color="gray"
            )
    
    def preview_files(self):
        """Preview files that will be sorted."""
        folder_path = self.folder_path_var.get()
        if not folder_path:
            messagebox.showwarning("No Folder", "Please select a folder first.")
            return
        
        if not self.sorter.validate_folder_path(folder_path):
            messagebox.showerror("Invalid Folder", "Selected folder is not valid or accessible.")
            return
        
        try:
            file_list = self.sorter.scan_files(folder_path)
            if not file_list:
                messagebox.showinfo("No Files", "No files found in the selected folder.")
                return
            
            # Create preview window
            preview_window = ctk.CTkToplevel(self.root)
            preview_window.title("File Preview")
            preview_window.geometry("700x500")
            preview_window.transient(self.root)
            
            # Preview content
            preview_label = ctk.CTkLabel(
                preview_window,
                text=f"Preview: {len(file_list)} files found",
                font=ctk.CTkFont(size=16, weight="bold")
            )
            preview_label.pack(pady=10)
            
            preview_text = ctk.CTkTextbox(preview_window, wrap="word")
            preview_text.pack(padx=20, pady=10, fill="both", expand=True)
            
            # Show file information
            preview_content = f"Folder: {folder_path}\n"
            preview_content += f"Total files: {len(file_list)}\n"
            preview_content += f"Sorting method: {self.method_var.get()}\n\n"
            preview_content += "Files to be processed:\n" + "="*50 + "\n"
            
            for i, file in enumerate(file_list[:20], 1):  # Show first 20 files
                size_kb = file['size'] / 1024
                preview_content += f"{i:2d}. {file['filename']:<30} ({size_kb:.1f} KB)\n"
            
            if len(file_list) > 20:
                preview_content += f"... and {len(file_list) - 20} more files\n"
            
            preview_text.insert("1.0", preview_content)
            preview_text.configure(state="disabled")
            
        except Exception as e:
            messagebox.showerror("Error", f"Error previewing files: {str(e)}")
    
    def start_sorting(self):
        """Start the file sorting process in a separate thread."""
        if self.is_sorting:
            messagebox.showinfo("Already Sorting", "Sorting is already in progress.")
            return
        
        folder_path = self.folder_path_var.get()
        if not folder_path:
            messagebox.showwarning("No Folder", "Please select a folder first.")
            return
            
        method = self.method_var.get()
        
        # Confirm action
        result = messagebox.askyesno(
            "Confirm Sorting",
            f"Are you sure you want to sort files in:\n{folder_path}\n\nUsing method: {method}",
            icon="question"
        )
        
        if result:
            # Disable buttons during sorting
            self.is_sorting = True
            self.sort_button.configure(text="Sorting...", state="disabled")
            self.browse_button.configure(state="disabled")
            self.preview_button.configure(state="disabled")
            self.method_dropdown.configure(state="disabled")
            
            # Clear progress
            self.progress_text.delete("1.0", "end")
            self.progress_bar.set(0)
            
            # Start sorting in a separate thread
            thread = threading.Thread(
                target=self.sort_files_thread,
                args=(folder_path, method),
                daemon=True
            )
            thread.start()
    
    def sort_files_thread(self, folder_path, method):
        """Run sorting in a separate thread to prevent GUI freezing."""
        try:
            success = self.sorter.sort_files(folder_path, method)
            
            # Update GUI in main thread
            self.root.after(0, self.sorting_complete, success)
            
        except Exception as e:
            self.root.after(0, self.sorting_error, str(e))
    
    def sorting_complete(self, success):
        """Handle sorting completion."""
        self.is_sorting = False
        
        # Re-enable buttons
        self.sort_button.configure(text="Start Sorting", state="normal")
        self.browse_button.configure(state="normal")
        self.preview_button.configure(state="normal")
        self.method_dropdown.configure(state="normal")
        
        if success:
            self.progress_bar.set(1.0)
            self.status_label.configure(text="Sorting completed successfully!")
            messagebox.showinfo("Success", "Files have been sorted successfully!")
        else:
            self.status_label.configure(text="Sorting failed!")
            messagebox.showerror("Error", "Sorting failed. Check the progress log for details.")
            
        # Update file count
        self.update_file_count()
    
    def sorting_error(self, error_message):
        """Handle sorting errors."""
        self.is_sorting = False
        
        # Re-enable buttons
        self.sort_button.configure(text="Start Sorting", state="normal")
        self.browse_button.configure(state="normal")
        self.preview_button.configure(state="normal")
        self.method_dropdown.configure(state="normal")
        
        self.status_label.configure(text="Sorting failed!")
        messagebox.showerror("Error", f"An error occurred during sorting:\n{error_message}")
    
    def update_progress(self, message):
        """Update progress display (called from FileSorterApp)."""
        # This method is called from the sorting thread, so we need to use after()
        self.root.after(0, self._update_progress_gui, message)
    
    def _update_progress_gui(self, message):
        """Update progress GUI elements (runs in main thread)."""
        # Add message to progress text
        self.progress_text.insert("end", message + "\n")
        self.progress_text.see("end")  # Scroll to bottom
        
        # Update progress bar based on message content
        if "Progress:" in message:
            try:
                # Extract progress numbers (e.g., "Progress: 5/20")
                progress_part = message.split("Progress:")[1].split("-")[0].strip()
                current, total = map(int, progress_part.split("/"))
                progress_value = current / total
                self.progress_bar.set(progress_value)
            except (ValueError, IndexError):
                pass  # Ignore if can't parse progress
        
        # Update status
        if "Error:" in message or "Warning:" in message:
            self.status_label.configure(text="Issues encountered during sorting")
        elif "Scanning files..." in message:
            self.status_label.configure(text="Scanning files...")
        elif "Moving files" in message:
            self.status_label.configure(text="Moving files...")
        elif "Deleting empty folders" in message:
            self.status_label.configure(text="Cleaning up...")
    
    def run(self):
        """Start the GUI application."""
        self.root.mainloop()


def main():
    """Main function to run the GUI application."""
    app = FileSorterGUI()
    app.run()


if __name__ == "__main__":
    main()
