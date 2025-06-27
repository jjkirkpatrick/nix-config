# ======================================================================
# ROFI APPLICATION LAUNCHER CONFIGURATION
# ======================================================================
# Rofi is a window switcher, application launcher, and dmenu replacement
# for Wayland/X11. This configuration sets up Rofi with a custom theme
# and optimized settings for the Dark Space desktop environment.
#
# Features configured:
# - Application launcher with icon support
# - Window switcher for multitasking
# - Command runner for quick commands
# - Custom Dark Space theme integration
# - Fuzzy search for better usability
# ======================================================================

{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;            # Wayland-compatible version of Rofi
    
    # ============================================================
    # VISUAL CONFIGURATION
    # ============================================================
    # Configure appearance to match the Dark Space theme
    
    font = "JetBrains Mono 16";             # Consistent font with terminal and other apps
    terminal = "kitty";                     # Terminal to use when launching terminal apps
    theme = ./themes/dark-space/rofi.rasi;  # Custom Dark Space theme file
    
    # ============================================================
    # ROFI BEHAVIOR AND FEATURES
    # ============================================================
    # Configure Rofi's functionality and user interface behavior
    
    extraConfig = {
      # ========================================
      # Available Modes
      # ========================================
      modi = "run,drun,window";             # Enable run commands, desktop apps, and window switching
      
      # ========================================
      # Display Configuration
      # ========================================
      lines = 5;                           # Number of lines to display in the list
      cycle = false;                       # Don't cycle through results (more predictable)
      
      # ========================================
      # Icon and Visual Settings
      # ========================================
      show-icons = true;                   # Display application icons (better visual recognition)
      icon-theme = "Papirus-dark";         # Dark icon theme matching the overall aesthetic
      drun-display-format = "{icon} {name}"; # Show icon and name for desktop applications
      
      # ========================================
      # Window Positioning and Behavior
      # ========================================
      location = 0;                        # Center the window on screen
      disable-history = true;              # Don't save search history (privacy and cleanliness)
      hide-scrollbar = true;               # Clean look without scrollbar
      
      # ========================================
      # Mode Display Names
      # ========================================
      # Custom names for each mode with icons for visual distinction
      display-drun = " Apps ";            # Desktop applications with app icon
      display-run = " Run ";              # Command runner with terminal icon
      display-window = " Window ";        # Window switcher with window icon
      
      # ========================================
      # Interface Layout
      # ========================================
      sidebar-mode = true;                 # Show mode selector sidebar for easy switching
      
      # ========================================
      # Search and Sorting
      # ========================================
      sorting-method = "fzf";              # Use fuzzy search algorithm (more flexible matching)
    };
  };

  # ============================================================
  # ROFI USAGE NOTES
  # ============================================================
  # Rofi modes and their purposes:
  # 
  # 1. Apps Mode (drun):
  #    - Launch desktop applications
  #    - Shows installed .desktop applications
  #    - Displays icons and descriptions
  #    - Most commonly used mode
  #
  # 2. Run Mode (run):
  #    - Execute any command in PATH
  #    - Useful for command-line tools
  #    - Direct access to system commands
  #    - Good for advanced users
  #
  # 3. Window Mode (window):
  #    - Switch between open windows
  #    - Shows window titles and applications
  #    - Quick navigation between workspaces
  #    - Essential for multitasking
  #
  # The fuzzy search allows partial matching, making it easy to find
  # applications by typing just part of their name.
}
