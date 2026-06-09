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
    ".config/hypr/bind.conf".source = "${configDir}/hypr/bind.conf";
    ".config/hypr/exec.conf".source = "${configDir}/hypr/exec.conf";
    ".config/hypr/hypridle.conf".source = "${configDir}/hypr/hypridle.conf";
    ".config/hypr/hyprland.conf".source = "${configDir}/hypr/hyprland.conf";
    ".config/hypr/input.conf".source = "${configDir}/hypr/input.conf";
    ".config/hypr/monitor.conf".source = "${configDir}/hypr/monitor.conf";
    ".config/hypr/window.conf".source = "${configDir}/hypr/window.conf";
    ".config/hypr/windowrule.conf".source = "${configDir}/hypr/windowrule.conf";

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