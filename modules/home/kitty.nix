# ======================================================================
# KITTY TERMINAL EMULATOR CONFIGURATION
# ======================================================================
# This module configures Kitty, a fast, feature-rich, GPU-accelerated terminal
# emulator. Kitty is designed for power users and supports advanced features
# like ligatures, images, and extensive customization.
#
# Configuration includes:
# - Custom Dark Space color scheme
# - Font configuration with Nerd Font support
# - Performance optimizations
# - Custom keybindings
# - Window and tab management
# ======================================================================

{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    
    # ============================================================
    # FONT CONFIGURATION
    # ============================================================
    # Configure the terminal font for optimal readability and development
    
    font = {
      name = "JetBrains Mono Nerd Font";  # Professional monospace font with icons
      size = 14;                           # Comfortable size for most screens
    };
    
    # ============================================================
    # VISUAL SETTINGS AND THEMING
    # ============================================================
    # Dark Space theme configuration - custom color scheme inspired by
    # deep space aesthetics with high contrast for readability
    
    settings = {
      # ========================================
      # Base Colors - Dark Space Theme
      # ========================================
      foreground = "#F8FAFC";           # Star white - primary text color
      background = "#0B0D17";           # Deep space - main background
      selection_foreground = "#0B0D17"; # Deep space - selected text color
      selection_background = "#E2E8F0"; # Slate blue - selection highlight
      
      # ========================================
      # Cursor Configuration
      # ========================================
      cursor = "#E2E8F0";               # Slate blue - cursor color
      cursor_text_color = "#0B0D17";    # Deep space - text under cursor
      
      # ========================================
      # Interactive Elements
      # ========================================
      url_color = "#06B6D4";            # Cyan accent - clickable URLs
      
      # ========================================
      # Window Border Colors
      # ========================================
      active_border_color = "#8B5CF6";  # Purple accent - focused window
      inactive_border_color = "#252A38"; # Cosmic gray - unfocused windows
      bell_border_color = "#F97316";    # Orange accent - notification bell
      
      # ========================================
      # Tab Bar Color Scheme
      # ========================================
      active_tab_foreground = "#F8FAFC"; # Star white - active tab text
      active_tab_background = "#252A38"; # Cosmic gray - active tab background
      inactive_tab_foreground = "#A0A8B8"; # Muted gray - inactive tab text
      inactive_tab_background = "#0F141E"; # Void black - inactive tab background
      tab_bar_background = "#0B0D17";   # Deep space - tab bar background
      
      # ========================================
      # Terminal Color Palette - 16 ANSI Colors
      # ========================================
      # Standard terminal colors used by applications and shell prompts
      # Dark Space theme provides vibrant yet comfortable colors
      
      # Dark Colors (0-7)
      color0 = "#1A1F2E";   # black (dark slate) - used for dark elements
      color1 = "#EF4444";   # red - errors, warnings, important text
      color2 = "#10B981";   # green - success, confirmations, positive status
      color3 = "#F59E0B";   # yellow - warnings, highlights, attention
      color4 = "#06B6D4";   # blue (cyan) - information, links, directories
      color5 = "#8B5CF6";   # magenta (purple) - special text, keywords
      color6 = "#06B6D4";   # cyan - information, secondary highlights
      color7 = "#E2E8F0";   # white (slate blue) - normal text
      
      # Bright Colors (8-15) - More vibrant versions for emphasis
      color8 = "#64748B";   # bright black (disabled gray) - disabled text
      color9 = "#EF4444";   # bright red - critical errors, alerts
      color10 = "#10B981";  # bright green - strong success indicators
      color11 = "#F59E0B";  # bright yellow - strong warnings
      color12 = "#06B6D4";  # bright blue (cyan) - emphasized information
      color13 = "#8B5CF6";  # bright magenta (purple) - special emphasis
      color14 = "#06B6D4";  # bright cyan - emphasized secondary info
      color15 = "#F8FAFC";  # bright white (star white) - primary text
      
      # ========================================
      # Window Appearance and Behavior
      # ========================================
      window_padding_width = 12;           # Internal padding around terminal content
      hide_window_decorations = "yes";     # Remove title bar (handled by window manager)
      confirm_os_window_close = 0;         # Don't ask for confirmation when closing
      
      # ========================================
      # Tab Configuration
      # ========================================
      tab_bar_edge = "top";               # Position tab bar at the top
      tab_bar_style = "powerline";        # Use powerline-style tab separators
      tab_powerline_style = "slanted";    # Slanted separators for modern look
      
      # ========================================
      # Performance Optimization
      # ========================================
      repaint_delay = 10;                 # Milliseconds between screen redraws (lower = smoother)
      input_delay = 3;                    # Delay before processing input (lower = more responsive)
      sync_to_monitor = "yes";            # Sync with monitor refresh rate (prevents tearing)
      
      # ========================================
      # Scrollback Buffer
      # ========================================
      scrollback_lines = 10000;           # Lines to keep in scroll history (balance memory vs history)
      
      # ========================================
      # Mouse Behavior
      # ========================================
      mouse_hide_wait = 3.0;              # Seconds before hiding cursor when typing
      url_style = "curly";                # Underline style for URLs (curly looks modern)
      
      # ========================================
      # Audio and Visual Feedback
      # ========================================
      enable_audio_bell = "no";           # Disable system beep (annoying in terminal)
      visual_bell_duration = 0.0;         # No visual flash on bell (keep it clean)
      
      # ========================================
      # Shell Integration
      # ========================================
      shell_integration = "enabled";       # Enable Kitty's shell integration features
      shell = "zsh";                      # Default shell to use
      
      # ========================================
      # Clipboard Management
      # ========================================
      copy_on_select = "clipboard";       # Automatically copy selected text to clipboard
      strip_trailing_spaces = "smart";    # Remove trailing spaces when copying
      
      # ========================================
      # Transparency and Compositing
      # ========================================
      background_opacity = 1.0;           # Fully opaque (let window manager handle transparency)
      dynamic_background_opacity = "yes"; # Allow dynamic opacity changes
      
      # ========================================
      # Text Rendering
      # ========================================
      disable_ligatures = "never";        # Always show font ligatures (programming symbols)
    };
    
    # ============================================================
    # CUSTOM KEYBINDINGS
    # ============================================================
    # Configure keyboard shortcuts for efficient terminal usage
    # These bindings follow common terminal conventions while adding
    # Kitty-specific functionality
    
    keybindings = {
      # ========================================
      # Tab Management
      # ========================================
      "ctrl+shift+t" = "new_tab";         # Create new tab
      "ctrl+shift+w" = "close_tab";       # Close current tab
      "ctrl+shift+right" = "next_tab";    # Switch to next tab
      "ctrl+shift+left" = "previous_tab"; # Switch to previous tab
      
      # ========================================
      # Window Management
      # ========================================
      "ctrl+shift+enter" = "new_window";  # Create new window in current tab
      "ctrl+shift+n" = "new_os_window";   # Create new OS window (separate instance)
      
      # ========================================
      # Font Size Control
      # ========================================
      "ctrl+plus" = "increase_font_size";  # Increase font size
      "ctrl+equal" = "increase_font_size"; # Alternative increase (+ key without shift)
      "ctrl+minus" = "decrease_font_size"; # Decrease font size
      "ctrl+0" = "restore_font_size";      # Reset to default font size
      
      # ========================================
      # Clipboard Operations
      # ========================================
      "ctrl+shift+c" = "copy_to_clipboard";   # Copy selected text
      "ctrl+shift+v" = "paste_from_clipboard"; # Paste from clipboard
      
      # ========================================
      # URL and Link Handling
      # ========================================
      "ctrl+shift+e" = "open_url_with_hints"; # Show URL hints for clicking
      
      # ========================================
      # Search and Navigation
      # ========================================
      "ctrl+shift+f" = "show_scrollback";     # Search through terminal history
    };
  };

  # ============================================================
  # KITTY CONFIGURATION NOTES
  # ============================================================
  # This configuration optimizes Kitty for:
  # - Development work with proper font rendering
  # - Visual consistency with the Dark Space theme
  # - Performance on modern hardware
  # - Integration with the Hyprland window manager
  # - Efficient keyboard-driven workflow
  #
  # Key features enabled:
  # - GPU acceleration for smooth rendering
  # - Font ligatures for better code readability
  # - Extensive scrollback for debugging
  # - Smart clipboard integration
  # - Modern tab styling with powerline separators
}
