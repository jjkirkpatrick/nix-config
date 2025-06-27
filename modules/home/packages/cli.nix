# ======================================================================
# CLI TOOLS AND UTILITIES PACKAGE CONFIGURATION
# ======================================================================
# This module defines command-line interface (CLI) tools and utilities that
# enhance the terminal experience and provide modern alternatives to
# traditional Unix commands. These tools focus on improved performance,
# better output formatting, and enhanced functionality.
#
# Philosophy: Replace legacy Unix tools with modern Rust/Go alternatives
# that provide better defaults, colored output, and superior performance.
# Also includes essential development tools and system utilities.
# ======================================================================

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # ========================================
    # ENHANCED SYSTEM TOOLS
    # ========================================
    # Modern replacements for traditional Unix commands with improved
    # performance, better output formatting, and additional features
    
    ripgrep                  # Modern grep replacement written in Rust
                            # - Faster than grep with better defaults
                            # - Respects .gitignore files automatically
                            # - Unicode support and multiline matching
                            # - Used as 'rg' command, aliased to 'grep'
    
    fd                       # Modern find replacement written in Rust
                            # - Simpler syntax than traditional find
                            # - Faster execution with parallel processing
                            # - Respects .gitignore by default
                            # - Better Unicode and regex support
    
    eza                      # Modern ls replacement with enhanced features
                            # - Tree view, Git status integration
                            # - Icons, colors, and better formatting
                            # - Shows file metadata in readable format
                            # - Replaces both 'ls' and 'tree' functionality
    
    bat                      # Enhanced cat with syntax highlighting
                            # - Automatic language detection and highlighting
                            # - Line numbers and Git integration
                            # - Paging support for large files
                            # - Works seamlessly as a 'cat' replacement
    
    fzf                      # Command-line fuzzy finder
                            # - Interactive filtering for any list
                            # - Integrates with shell history, file selection
                            # - Powers completion in ZSH configuration
                            # - Essential for modern CLI workflows
    
    zoxide                   # Smart cd command that learns your habits
                            # - Tracks frequently visited directories
                            # - Jump to directories with partial names
                            # - Integrated with ZSH via programs.zoxide
                            # - Provides 'z' command for quick navigation
    
    btop                     # Modern system monitor with better interface
                            # - Real-time CPU, memory, network, and disk usage
                            # - Mouse support and customizable interface
                            # - Process tree and detailed system information
                            # - Visually superior to traditional 'top'
    
    htop                     # Interactive process viewer (fallback/alternative)
                            # - More user-friendly than default 'top'
                            # - Tree view, search, and easy process management
                            # - Kept alongside btop for compatibility
    
    tree                     # Directory structure visualization (classic)
                            # - ASCII art directory trees
                            # - Useful for documentation and understanding structure
                            # - Complemented by eza's --tree option
    
    du-dust                  # Modern disk usage analyzer
                            # - Visual representation of disk usage
                            # - Faster than traditional 'du' command
                            # - Better output formatting with colors
                            # - Helps identify large files and directories
    
    duf                      # Modern df replacement for disk free space
                            # - Colored output with better formatting
                            # - Shows usage percentages and mount points
                            # - More readable than traditional 'df'
    
    # ========================================
    # FILE MANAGEMENT UTILITIES
    # ========================================
    # Essential tools for file operations, type detection, and manipulation
    
    file                     # File type detection and identification
                            # - Determines file types by content analysis
                            # - Essential for scripts and automation
                            # - Works with binary and text files
    
    unzip                    # ZIP archive extraction utility
                            # - Extract .zip files created on various systems
                            # - Cross-platform compatibility
                            # - Essential for downloading and extracting packages
    
    zip                      # ZIP archive creation utility
                            # - Create compressed archives for sharing
                            # - Cross-platform format widely supported
                            # - Useful for backups and file distribution
    
    p7zip                    # 7-Zip archive support (7z, rar, etc.)
                            # - Handle various archive formats
                            # - High compression ratios
                            # - Essential for handling diverse archive types
    
    rsync                    # Advanced file synchronization and transfer
                            # - Efficient incremental file transfers
                            # - Network and local synchronization
                            # - Essential for backups and deployments
                            # - Delta compression for large files
    
    # ========================================
    # NETWORK TOOLS AND UTILITIES
    # ========================================
    # Essential networking tools for downloads, diagnostics, and monitoring
    
    wget                     # Command-line web downloader
                            # - Download files from web servers
                            # - Resume interrupted downloads
                            # - Recursive website downloading
                            # - Essential for automation scripts
    
    curl                     # Versatile HTTP client and transfer tool
                            # - HTTP/HTTPS requests with full control
                            # - API testing and web service interaction
                            # - Support for various protocols (FTP, SFTP, etc.)
                            # - JSON data posting and header manipulation
    
    nmap                     # Network discovery and security auditing
                            # - Port scanning and network mapping
                            # - Service detection and OS fingerprinting
                            # - Network security assessment
                            # - Essential for network troubleshooting
    
    bandwhich                # Network utilization monitor by process
                            # - See which processes are using network
                            # - Real-time bandwidth usage per application
                            # - Helps identify network-heavy applications
                            # - Modern alternative to traditional network tools
    
    # ========================================
    # DEVELOPMENT TOOLS
    # ========================================
    # Essential tools for software development and version control
    
    git                      # Distributed version control system
                            # - Industry standard for code versioning
                            # - Branching, merging, and collaboration
                            # - Essential for any development workflow
                            # - Integrated with development environments
    
    gh                       # Official GitHub CLI tool
                            # - Manage GitHub repositories from terminal
                            # - Create issues, pull requests, releases
                            # - Streamlines GitHub workflow integration
                            # - Authentication and repository management
    
    jq                       # JSON processor and query language
                            # - Parse, filter, and transform JSON data
                            # - Essential for API responses and configuration
                            # - Powerful query syntax for complex operations
                            # - Scripting and automation with JSON
    
    yq                       # YAML processor (similar to jq for YAML)
                            # - Parse and manipulate YAML configuration files
                            # - Convert between YAML, JSON, and other formats
                            # - Essential for Kubernetes and configuration management
                            # - Complementary to jq for different data formats
    
    delta                    # Enhanced git diff viewer
                            # - Syntax-highlighted git diffs with better formatting
                            # - Side-by-side comparisons
                            # - Line-level and word-level highlighting
                            # - Improved readability for code reviews
    
    lazygit                  # Terminal UI for git operations
                            # - Visual git interface in the terminal
                            # - Interactive staging, committing, and branching
                            # - Faster than command-line git for complex operations
                            # - Great for visual learners and git beginners
    
    claude-code              # Claude AI coding assistant CLI
                            # - AI-powered code assistance and generation
                            # - Integration with development workflows
                            # - Code explanation and optimization suggestions
    
    # ========================================
    # TEXT PROCESSING TOOLS
    # ========================================
    # Advanced text manipulation and processing utilities
    
    gnused                   # GNU stream editor for text manipulation
                            # - Pattern-based text transformation
                            # - Essential for shell scripts and automation
                            # - Regular expression support
                            # - In-place file editing capabilities
    
    gawk                     # GNU AWK for advanced text processing
                            # - Pattern scanning and data extraction
                            # - Mathematical operations on text data
                            # - Report generation and data formatting
                            # - Essential for log analysis and data processing
    
    # ========================================
    # SYSTEM MONITORING AND PROCESS MANAGEMENT
    # ========================================
    # Tools for monitoring system resources and managing processes
    
    lsof                     # List open files and network connections
                            # - Show which files are opened by which processes
                            # - Network connection monitoring
                            # - Essential for system debugging
                            # - Identify file locks and resource usage
    
    pstree                   # Display processes in a tree format
                            # - Visual representation of process relationships
                            # - Understand parent-child process hierarchies
                            # - Useful for debugging and system analysis
    
    killall                  # Terminate processes by name
                            # - Kill processes without knowing PID
                            # - Pattern-based process termination
                            # - Safer than 'kill -9' for cleanup
                            # - Essential for process management scripts
    
    # ========================================
    # TERMINAL UTILITIES AND MULTIPLEXERS
    # ========================================
    # Tools that enhance terminal functionality and session management
    
    direnv                   # Automatic environment variable management
                            # - Load environment variables per directory
                            # - Project-specific PATH and configuration
                            # - Integration with development environments
                            # - Automatic activation/deactivation on cd
    
    starship                 # Cross-shell prompt with rich information
                            # - Fast, customizable prompt
                            # - Git status, language versions, system info
                            # - Alternative to Powerlevel10k for other shells
                            # - Highly configurable with TOML configuration
    
    # ========================================
    # ARCHIVE AND COMPRESSION TOOLS
    # ========================================
    # Additional archive handling utilities
    
    gnutar                   # GNU tar archiver
                            # - Create and extract tar archives
                            # - Essential for Unix/Linux file distribution
                            # - Supports various compression formats
                            # - Backup and deployment tool
    
    gzip                     # GNU compression utility
                            # - Fast compression for individual files
                            # - Standard Unix compression format
                            # - Used with tar for .tar.gz archives
                            # - Essential for log rotation and backups
    
    # ========================================
    # PASSWORD AND SECURITY MANAGEMENT
    # ========================================
    # Secure password storage and management
    
    pass                     # The standard Unix password manager
                            # - Encrypted password storage using GPG
                            # - Command-line password retrieval
                            # - Git integration for password database sync
                            # - Scriptable and automation-friendly
    
    # ========================================
    # MEDIA PROCESSING TOOLS
    # ========================================
    # Powerful tools for multimedia content manipulation
    
    ffmpeg                   # Complete multimedia framework
                            # - Video/audio conversion and processing
                            # - Format support for virtually all media types
                            # - Command-line video editing and optimization
                            # - Essential for media automation and conversion
    
    imagemagick              # Image manipulation and conversion suite
                            # - Resize, convert, and edit images
                            # - Batch processing capabilities
                            # - Support for 200+ image formats
                            # - Essential for image automation and optimization
    
    # ========================================
    # SYSTEM INFORMATION AND BENCHMARKING
    # ========================================
    # Tools for system information display and performance testing
    
    neofetch                 # System information display with ASCII art
                            # - Beautiful system info with distro logo
                            # - Hardware, software, and theme information
                            # - Customizable output and colors
                            # - Great for screenshots and system showcasing
    
    fastfetch                # Faster alternative to neofetch
                            # - Similar functionality with better performance
                            # - Reduced startup time and resource usage
                            # - More configuration options
                            # - Better for scripting and automation
    
    hyperfine                # Command-line benchmarking tool
                            # - Measure and compare command execution times
                            # - Statistical analysis of performance
                            # - Multiple runs with variance calculation
                            # - Essential for performance optimization
    
    # ========================================
    # WAYLAND/GUI INTEGRATION TOOLS
    # ========================================
    # Tools that bridge CLI and GUI environments, especially for Wayland
    
    hyprpaper                # Wallpaper utility for Hyprland compositor
                            # - Dynamic wallpaper management
                            # - Multiple monitor support
                            # - Efficient image loading and display
                            # - Integration with Wayland compositors
    
    kitty                    # GPU-accelerated terminal emulator
                            # - Fast rendering with GPU acceleration
                            # - Advanced features like tabs, splits, images
                            # - Excellent font rendering and Unicode support
                            # - Primary terminal emulator for this configuration
    
    libnotify                # Desktop notification library
                            # - Send notifications from command line
                            # - Integration with desktop notification systems
                            # - Essential for script notifications
                            # - Used by notify-send command
    
    mako                     # Lightweight notification daemon for Wayland
                            # - Display desktop notifications
                            # - Customizable appearance and behavior
                            # - Low resource usage
                            # - Essential for Wayland desktop environment
    
    qt5.qtwayland            # Qt5 Wayland platform plugin
                            # - Enable Qt5 applications on Wayland
                            # - Proper window management and input handling
                            # - Essential for Qt-based applications
    
    qt6.qtwayland            # Qt6 Wayland platform plugin
                            # - Enable Qt6 applications on Wayland
                            # - Future-proof support for newer Qt applications
                            # - Improved Wayland integration over Qt5
    
    swayidle                 # Idle management daemon for Wayland
                            # - Automatic screen locking and power management
                            # - Customizable idle actions
                            # - Integration with screen lockers
                            # - Battery life optimization
    
    swaylock-effects         # Screen locker with visual effects
                            # - Secure screen locking with customization
                            # - Blur effects and custom backgrounds
                            # - Integration with idle management
                            # - Enhanced security and visual appeal
    
    wlogout                  # Logout menu for Wayland
                            # - Graphical logout/shutdown interface
                            # - Session management options
                            # - Integration with Wayland session
                            # - User-friendly power management
    
    wl-clipboard             # Wayland clipboard utilities
                            # - Copy/paste operations in Wayland
                            # - Command-line clipboard access
                            # - Essential for clipboard automation
                            # - Replaces xclip/xsel for Wayland
    
    wofi                     # Application launcher for Wayland
                            # - Dmenu-like application launcher
                            # - Customizable appearance and behavior
                            # - Fast application searching and launching
                            # - Integration with Wayland compositors
    
    waybar                   # Customizable status bar for Wayland
                            # - Display system information and status
                            # - Modular design with custom widgets
                            # - Integration with Wayland compositors
                            # - Highly configurable appearance and functionality
  ];

  # ============================================================
  # CLI TOOLS CONFIGURATION NOTES
  # ============================================================
  # This package collection provides:
  # - Modern alternatives to traditional Unix tools
  # - Enhanced development workflow support
  # - Comprehensive system monitoring and management
  # - Wayland desktop environment integration
  # - Network and security utilities
  # - Media processing capabilities
  #
  # Package Selection Philosophy:
  # - Prefer Rust/Go tools for performance and safety
  # - Choose tools with better defaults and output
  # - Include both modern and classic tools for compatibility
  # - Focus on developer productivity and system administration
  # - Ensure Wayland compatibility for GUI integration
  #
  # These tools work together to create a powerful CLI environment
  # that enhances productivity while maintaining Unix philosophy.
}



