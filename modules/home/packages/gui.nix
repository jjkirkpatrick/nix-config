# ======================================================================
# GUI APPLICATIONS AND DESKTOP UTILITIES
# ======================================================================
# This module defines graphical user interface (GUI) applications and
# desktop utilities that provide a complete desktop environment experience.
# These applications cover productivity, entertainment, development, and
# system management needs in a modern Wayland-based desktop environment.
#
# Focus areas:
# - Privacy-focused applications where possible
# - Wayland-native applications for best performance
# - Open-source alternatives to proprietary software
# - Integration with the Dark Space theme and Hyprland compositor
# ======================================================================

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # ========================================
    # WEB BROWSERS
    # ========================================
    # Privacy-focused browsers with enhanced security features
    
    brave                    # Privacy-focused Chromium-based browser
                            # - Built-in ad blocking and tracker protection
                            # - Tor integration for private browsing
                            # - BAT (Basic Attention Token) rewards system
                            # - Chromium compatibility for web development
                            # - HTTPS Everywhere and fingerprinting protection
    
    # ========================================
    # MEDIA PLAYERS AND ENTERTAINMENT
    # ========================================
    # Versatile media players for various formats and use cases
    
    vlc                      # Universal media player with extensive codec support
                            # - Plays virtually any audio/video format
                            # - Network streaming capabilities (HTTP, RTSP, etc.)
                            # - DVD/Blu-ray playback support
                            # - Audio/video filters and effects
                            # - Cross-platform and highly reliable
    
    mpv                      # Lightweight, scriptable media player
                            # - Minimal interface with keyboard-driven controls
                            # - High-quality video rendering and scaling
                            # - Extensive configuration options
                            # - GPU acceleration and hardware decoding
                            # - Preferred for keyboard-centric workflows
    
    # ========================================
    # FILE MANAGEMENT
    # ========================================
    # Graphical file managers for desktop file operations
    
    nemo                     # Feature-rich file manager (Cinnamon's default)
                            # - Dual-pane option for efficient file operations
                            # - Customizable toolbar and sidebar
                            # - Plugin support for extended functionality
                            # - Good Wayland compatibility
                            # - Thumbnail generation and file previews
    
    # ========================================
    # IMAGE VIEWING AND EDITING
    # ========================================
    # Tools for viewing and basic image manipulation
    
    viewnior                 # Fast and simple image viewer
                            # - Lightweight with minimal resource usage
                            # - Supports common image formats
                            # - Slideshow functionality
                            # - Basic image operations (rotate, zoom)
                            # - Good integration with file managers
    
    # ========================================
    # OFFICE AND PRODUCTIVITY SUITE
    # ========================================
    # Complete office suite for document creation and editing
    
    libreoffice              # Complete open-source office suite
                            # - Writer (word processing)
                            # - Calc (spreadsheets)
                            # - Impress (presentations)
                            # - Draw (vector graphics)
                            # - Base (database management)
                            # - Microsoft Office compatibility
    
    #obsidian                 # Advanced note-taking and knowledge management
                            # - Markdown-based note system
                            # - Graph view for note relationships
                            # - Plugin ecosystem for extensibility
                            # - Local storage with optional sync
                            # - Currently commented out (can be enabled)
    
    # ========================================
    # COMMUNICATION PLATFORMS
    # ========================================
    # Applications for chat, voice, and video communication
    
    discord                  # Popular gaming and community chat platform
                            # - Text, voice, and video chat
                            # - Screen sharing and streaming
                            # - Community servers and direct messaging
                            # - Integration with gaming and development communities
                            # - Rich presence and custom status
    
    # ========================================
    # DEVELOPMENT ENVIRONMENTS
    # ========================================
    # Code editors and integrated development environments
    
    
    
    code-cursor              # AI-powered code editor
                            # - Cursor-based AI assistance for coding
                            # - Advanced code completion and generation
                            # - Integration with large language models
                            # - Modern development workflow optimization

    # ========================================
    # SYSTEM UTILITIES AND CONTROL
    # ========================================
    # GUI tools for system configuration and management
    
    pavucontrol              # PulseAudio volume control GUI
                            # - Advanced audio device management
                            # - Per-application volume control
                            # - Input/output device selection
                            # - Stream routing and configuration
                            # - Essential for complex audio setups
    
    pamixer                  # Command-line PulseAudio mixer
                            # - Scriptable audio control
                            # - Volume adjustment from terminal
                            # - Integration with keybindings and scripts
                            # - Complementary to pavucontrol
    
    blueman                  # Bluetooth device manager
                            # - GUI for Bluetooth device pairing
                            # - Connection management and profiles
                            # - File transfer capabilities
                            # - Audio device configuration
                            # - System tray integration
    
    playerctl                # Media player control utility
                            # - Universal media player control
                            # - Keyboard shortcut integration
                            # - Support for MPRIS-compliant players
                            # - Scriptable media control
                            # - Works with Spotify, VLC, browsers, etc.
    
    gammastep                # Blue light filter for eye strain reduction
                            # - Automatic color temperature adjustment
                            # - Location-based sunrise/sunset scheduling
                            # - Customizable color temperature ranges
                            # - Wayland-compatible alternative to redshift
                            # - Reduces eye strain during night usage
    
    jq                       # JSON processor for GUI scripts
                            # - Parse configuration files and API responses
                            # - Essential for modern GUI automation
                            # - Integration with system scripts
    
    jaq                      # Rust-based JSON processor (faster jq alternative)
                            # - Performance-optimized JSON processing
                            # - Drop-in replacement for jq
                            # - Better for high-performance scripting
    
    socat                    # Socket communication utility
                            # - Network socket manipulation
                            # - Pipe and file descriptor management
                            # - Essential for system integration scripts
                            # - Debugging network communications
    
    networkmanager           # Network connection management
                            # - GUI network configuration
                            # - WiFi, Ethernet, VPN management
                            # - Connection profiles and automation
                            # - Essential for desktop networking
    
    # ========================================
    # ARCHIVE MANAGEMENT
    # ========================================
    # GUI tools for handling compressed files and archives
    
    file-roller              # Archive manager with GUI interface
                            # - Extract and create various archive formats
                            # - Drag-and-drop file operations
                            # - Password-protected archive support
                            # - Integration with file managers
                            # - Support for ZIP, TAR, 7Z, RAR, and more
    
    # ========================================
    # DOCUMENT VIEWERS
    # ========================================
    # Specialized viewers for different document formats
    
    evince                   # Multi-format document viewer
                            # - PDF, PostScript, DjVu, TIFF, DVI support
                            # - Annotation and form filling capabilities
                            # - Full-screen presentation mode
                            # - Search and navigation features
                            # - Print and export functionality
    
    # ========================================
    # GAMING AND ENTERTAINMENT
    # ========================================
    # Games and gaming-related utilities
    
    #steam                    # Digital game distribution platform
                            # - Extensive game library access
                            # - Cloud saves and achievements
                            # - Steam Workshop for mods
                            # - Proton for Windows game compatibility
                            # - Handled separately in gaming configuration
    
    runelite                 # Enhanced Old School RuneScape client
                            # - Third-party client with quality-of-life improvements
                            # - Plugin system for additional features
                            # - Performance optimizations
                            # - Enhanced user interface
    
    # ========================================
    # SCREENSHOT AND ANNOTATION TOOLS
    # ========================================
    # Tools for capturing and editing screenshots
    
    grim                     # Wayland-native screenshot capture tool
                            # - Full screen and region capture
                            # - Output to file or clipboard
                            # - Integration with Wayland compositors
                            # - High-quality image capture
    
    slurp                    # Screen area selection tool for Wayland
                            # - Interactive region selection
                            # - Works with grim for partial screenshots
                            # - Precise pixel-level selection
                            # - Essential for screenshot workflows
    
    swappy                   # Screenshot annotation and editing
                            # - Add text, arrows, and shapes to screenshots
                            # - Blur sensitive information
                            # - Quick editing before sharing
                            # - Integration with screenshot tools
    
    # ========================================
    # CLIPBOARD MANAGEMENT
    # ========================================
    # Advanced clipboard functionality beyond basic copy/paste
    
    wl-clipboard             # Wayland clipboard utilities
                            # - Copy/paste operations in Wayland
                            # - Command-line clipboard access
                            # - Essential for clipboard automation
                            # - Replaces X11 clipboard tools
    
    cliphist                 # Clipboard history manager
                            # - Persistent clipboard history
                            # - Search and select from previous clips
                            # - Text and image clipboard support
                            # - Privacy-aware clipboard management
    
    # ========================================
    # FONT MANAGEMENT
    # ========================================
    # Tools for managing and organizing system fonts
    
    font-manager             # GUI font management utility
                            # - Install and organize font collections
                            # - Font preview and comparison
                            # - Manage font activation/deactivation
                            # - Font information and metadata viewing
                            # - Essential for design and typography work
    
    # ========================================
    # SYSTEM MONITORING
    # ========================================
    # GUI applications for system performance monitoring
    
    mission-center           # Modern system monitor with beautiful interface
                            # - Real-time system resource monitoring
                            # - CPU, memory, disk, and network usage
                            # - Process management with detailed information
                            # - Modern UI design with graphs and charts
                            # - Alternative to traditional system monitors
    
    # ========================================
    # DESKTOP WIDGETS AND CUSTOMIZATION
    # ========================================
    # Tools for desktop appearance and functionality
    
    waybar                   # Highly customizable Wayland status bar
                            # - System information display (CPU, memory, time)
                            # - Workspace indicators and window titles
                            # - Custom modules and widgets
                            # - Themeable with CSS styling
                            # - Integration with Wayland compositors
    
    streamdeck-ui            # Elgato Stream Deck configuration utility
                            # - Program Stream Deck buttons and functions
                            # - Custom macros and shortcuts
                            # - Integration with system functions
                            # - Productivity enhancement for content creators
    
     
    # ========================================
    # MUSIC AND AUDIO APPLICATIONS
    # ========================================
    # Applications for music streaming and audio management


    spotify                  # Popular music streaming service
                            # - Access to millions of songs and podcasts
                            # - Playlist creation and sharing
                            # - Cross-device synchronization
                            # - Social features and music discovery
    
    spotifyd                 # Lightweight Spotify daemon
                            # - Spotify Connect client daemon
                            # - Remote control from other devices
                            # - Lower resource usage than full client
                            # - Headless Spotify playback


    # ========================================
    # UTILITY APPLICATIONS
    # ========================================
    # Miscellaneous tools for various desktop tasks
    
    zenity                   # Create GUI dialogs from shell scripts
                            # - File selection, message boxes, progress bars
                            # - Integration between CLI and GUI
                            # - Scripting with user interaction
                            # - Essential for automated workflows
    
    # ========================================
    # GAMING OPTIMIZATION
    # ========================================
    # Tools to enhance gaming performance and experience
    
    gamemode                 # Gaming performance optimization daemon
                            # - Automatic system optimization for games
                            # - CPU governor and priority adjustments
                            # - GPU performance mode activation
                            # - Reduces system latency during gaming
                            # - Integration with Steam and other launchers
    
    # ========================================
    # VIRTUALIZATION MANAGEMENT
    # ========================================
    # GUI tools for managing virtual machines
    
    virt-manager             # Virtual machine management interface
                            # - Create and manage QEMU/KVM virtual machines
                            # - Hardware configuration and resource allocation
                            # - VM lifecycle management (start, stop, clone)
                            # - Network and storage configuration
                            # - Essential for development and testing
    
    # ========================================
    # PASSWORD MANAGEMENT
    # ========================================
    # GUI applications for secure password storage
    
    bitwarden-desktop        # Cross-platform password manager
                            # - Encrypted password vault with cloud sync
                            # - Secure password generation
                            # - Multi-factor authentication support
                            # - Browser integration for auto-fill
                            # - Secure note and document storage
    
    # ========================================
    # THEME AND CUSTOMIZATION
    # ========================================
    # Visual customization tools and themes
    
    rose-pine-hyprcursor     # Rose Pine cursor theme for Hyprland
                            # - Beautiful cursor theme matching Rose Pine colors
                            # - Consistent with overall theme aesthetic
                            # - Hyprland-optimized cursor rendering
                            # - Part of the Dark Space theme integration

    # ========================================
    # WAYLAND DESKTOP ENVIRONMENT INTEGRATION
    # ========================================
    # Essential components for a complete Wayland desktop experience
    
    hyprpaper                # Wallpaper utility for Hyprland compositor
                            # - Dynamic wallpaper management
                            # - Multiple monitor support
                            # - Efficient image loading and display
                            # - Integration with Wayland compositors
    
    kitty                    # Primary terminal emulator
                            # - GPU-accelerated rendering
                            # - Advanced features (tabs, splits, images)
                            # - Excellent font rendering and Unicode support
                            # - Highly configurable and themeable
    
    libnotify                # Desktop notification library
                            # - Send notifications from applications
                            # - Integration with desktop notification systems
                            # - Essential for system and application alerts
    
    mako                     # Lightweight notification daemon for Wayland
                            # - Display desktop notifications
                            # - Customizable appearance and behavior
                            # - Low resource usage
                            # - Essential for desktop environment feedback
    
    qt5.qtwayland            # Qt5 Wayland platform plugin
                            # - Enable Qt5 applications on Wayland
                            # - Proper window management and input handling
                            # - Essential for Qt-based GUI applications
    
    qt6.qtwayland            # Qt6 Wayland platform plugin
                            # - Enable Qt6 applications on Wayland
                            # - Future-proof support for newer Qt applications
                            # - Improved Wayland integration over Qt5
    
    swayidle                 # Idle management daemon for Wayland
                            # - Automatic screen locking and power management
                            # - Customizable idle actions
                            # - Battery life optimization
                            # - Security through automatic locking
    
    swaylock-effects         # Enhanced screen locker with visual effects
                            # - Secure screen locking with customization
                            # - Blur effects and custom backgrounds
                            # - Integration with idle management
                            # - Security with visual appeal
    
    wlogout                  # Logout menu for Wayland
                            # - Graphical logout/shutdown interface
                            # - Session management options
                            # - Integration with Wayland session management
                            # - User-friendly power management
    
    wofi                     # Application launcher for Wayland
                            # - Dmenu-like application launcher
                            # - Customizable appearance and behavior
                            # - Fast application searching and launching
                            # - Integration with Wayland compositors
 ];

  # ============================================================
  # GUI APPLICATIONS CONFIGURATION NOTES
  # ============================================================
  # This package collection provides:
  # - Complete desktop environment functionality
  # - Privacy-focused alternatives to mainstream applications
  # - Wayland-native applications for optimal performance
  # - Integration with the Dark Space theme
  # - Support for productivity, entertainment, and development
  #
  # Application Selection Philosophy:
  # - Open-source applications preferred over proprietary
  # - Wayland compatibility for modern desktop experience
  # - Privacy and security considerations
  # - Performance and resource efficiency
  # - Integration with terminal-based workflows
  #
  # These applications work together to create a cohesive
  # desktop environment that balances functionality, privacy,
  # and aesthetic appeal while maintaining excellent performance
  # on the Wayland display server.
}
