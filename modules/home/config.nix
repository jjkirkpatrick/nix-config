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
    # Development and Text Editor Configurations
    # ========================================
    
    ".config/nvim".source = "${configDir}/nvim";
    # Neovim configuration - Complete IDE setup with plugins, keybindings,
    # and language server configurations. Includes custom Lua configuration
    # for enhanced development experience.

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
    
    ".config/hypr".source = "${configDir}/hypr";
    # Hyprland window manager configuration - Wayland compositor
    # Includes keybindings, window rules, monitor setup, and animations

    ".config/waybar".source = "${configDir}/waybar";
    # Waybar status bar configuration - Displays system information,
    # workspaces, and provides quick access to system controls

    ".config/wallpapers".source = "${configDir}/wallpapers";
    # Wallpaper collection - Contains background images used by
    # the wallpaper manager (hyprpaper)

    # ========================================
    # Session Management and Security
    # ========================================
    
    ".config/swayidle".source = "${configDir}/swayidle";
    # Swayidle configuration - Manages idle states, screen timeout,
    # and automatic locking for security and power management

    ".config/swaylock".source = "${configDir}/swaylock";
    # Swaylock screen locker configuration - Secure screen locking
    # with custom styling and authentication options

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
    
    ".config/wofi".source = "${configDir}/wofi";
    # Wofi application launcher configuration - Wayland-native launcher
    # with custom styling to match the overall theme

    # ========================================
    # Notification System
    # ========================================
    
    ".config/mako".source = "${configDir}/mako";
    # Mako notification daemon configuration - Handles desktop notifications
    # with custom styling, positioning, and behavior settings
  };
}