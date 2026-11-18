# ======================================================================
# APPLICATION CONFIGURATION FILES MANAGEMENT
# ======================================================================
# This module manages the deployment of application configuration files
# (dotfiles) to their appropriate locations in the user's home directory.
# It uses Nix's declarative approach to ensure configurations are
# consistently applied and version-controlled.
#
# All configuration files are stored in the ./config directory and
# symlinked to their target locations. This provides a single source
# of truth for all application configurations.
# ======================================================================

let 
  # Define the base directory containing all configuration files
  # This allows easy reference and maintains organization
  configDir = ./config;
in
{
  # ============================================================
  # HOME DIRECTORY FILE MANAGEMENT
  # ============================================================
  # Map configuration directories to their target locations in ~/.config
  # Each entry creates a symlink from the Nix store to the user's config directory
  
  home.file = {
    # ========================================
    # System Utilities and Monitoring
    # ========================================
    
    ".config/neofetch".source = "${configDir}/neofetch";
    # Neofetch system information display configuration
    # Customizes the system info output format and ASCII art

    ".config/btop".source = "${configDir}/btop";
    # btop system monitor configuration - Modern replacement for htop
    # with better visual design and more detailed system information

    # ========================================
    # Window Manager and Desktop Environment
    # ========================================
    
    # Hyprland window manager configuration - individual files
    # (hyprpaper.conf is managed by services.hyprpaper)
    # Hyprland 0.56 dropped classic hyprlang (.conf) auto-discovery in favor
    # of a Lua config; these are the ported equivalents, require()'d from
    # hyprland.lua.
    ".config/hypr/bind.lua".source = "${configDir}/hypr/bind.lua";
    ".config/hypr/exec.lua".source = "${configDir}/hypr/exec.lua";
    ".config/hypr/hypridle.conf".source = "${configDir}/hypr/hypridle.conf";
    ".config/hypr/hyprland.lua".source = "${configDir}/hypr/hyprland.lua";
    ".config/hypr/input.lua".source = "${configDir}/hypr/input.lua";
    ".config/hypr/monitor.lua".source = "${configDir}/hypr/monitor.lua";
    ".config/hypr/window.lua".source = "${configDir}/hypr/window.lua";
    ".config/hypr/windowrule.lua".source = "${configDir}/hypr/windowrule.lua";

    ".config/waybar".source = "${configDir}/waybar";
    # Waybar status bar configuration - Displays system information,
    # workspaces, and provides quick access to system controls

    # ========================================
    # Session Management and Security
    # ========================================
    

".config/wlogout".source = "${configDir}/wlogout";
    # Wlogout session menu configuration - Provides logout, shutdown,
    # reboot, and lock options with custom styling

    # ========================================
    # Terminal and Command Line Applications
    # ========================================
    
    ".config/kitty".source = "${configDir}/kitty";
    # Kitty terminal emulator configuration - GPU-accelerated terminal
    # with custom color schemes, fonts, and keybindings

    # ========================================
    # Application Launchers and Menus
    # ========================================
    
    ".config/fuzzel".source = "${configDir}/fuzzel";
    # Fuzzel application launcher configuration - fast Wayland-native launcher

    # ========================================
    # Notification System
    # ========================================

    ".config/swaync".source = "${configDir}/swaync";
    # SwayNC notification center - notification daemon with slide-out control panel

    # ========================================
    # Hardware and Peripheral Control
    # ========================================
    
    ".config/streamdeck".source = "${configDir}/streamdeck";
    # StreamDeck configuration - Custom button layouts and macros
    # for system management, development workflows, and application control
  };
}