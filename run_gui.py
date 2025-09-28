#!/usr/bin/env python3
"""
File Sorter - GUI Launcher
A modern file sorting application with a beautiful GUI interface.
"""

import sys
import os

# Add current directory to path so we can import our modules
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

try:
    from gui import main
    main()
except ImportError as e:
    print(f"Error: Missing dependencies. Please install required packages:")
    print(f"pip install -r requirements.txt")
    print(f"\nError details: {e}")
    sys.exit(1)
except Exception as e:
    print(f"Error starting File Sorter: {e}")
    sys.exit(1)
