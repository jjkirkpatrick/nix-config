# ======================================================================
# HOME MANAGER CONFIGURATION - MAIN ENTRY POINT
# ======================================================================
# This is the primary home-manager configuration file that orchestrates
# all user-space configurations. It imports and manages all the different
# aspects of the user environment, from applications to shell configuration.
#
# Home Manager allows declarative configuration of user environments,
# managing dotfiles, packages, and settings in a reproducible way.
# ======================================================================

{username, inputs, ... }:
{
  # ============================================================
  # MODULE IMPORTS - Core Configuration Components
  # ============================================================
  # Import all the modular configuration files that define different
  # aspects of the user environment. Each module handles a specific
  # domain (fonts, shell, applications, etc.) to keep configuration
  # organized and maintainable.

  imports = [
    # Theme Management
    inputs.catppuccin.homeModules.catppuccin  # Catppuccin color scheme integration

    # Core System Configuration
    ./config.nix                      # Application configuration files (dotfiles)
    ./packages                        # Software packages (CLI tools, GUI applications)
    ./fonts.nix                       # Font installation and configuration
    ./development.nix                 # Programming languages, development tools, and environments

    # Desktop Environment Applications (currently disabled for headless/server setup)
    # ./kitty.nix                       # Terminal emulator configuration
    # ./hyprpaper.nix                   # Wallpaper manager for Hyprland
    # ./waybar.nix                      # Status bar configuration
    # ./rofi.nix                        # Application launcher configuration

    # Web Browsers and Applications
    ./brave.nix                       # Brave browser installation

    # Shell and Terminal Environment
    ./p10k/p10k.nix                  # Powerlevel10k shell prompt theme
    ./zsh                            # Zsh shell configuration (aliases, keybinds, plugins)
  ];

  # ============================================================
  # CORE HOME MANAGER CONFIGURATION
  # ============================================================
  # These are the fundamental settings required by home-manager to
  # properly manage the user environment.

  # Required home-manager options - defines the user context
  home = {
    username = username;                    # Username from flake parameter
    homeDirectory = "/home/${username}";    # Home directory path
    stateVersion = "25.05";                # Home Manager version for compatibility
  };

  # ============================================================
  # HOME MANAGER SELF-MANAGEMENT
  # ============================================================
  # Allow home-manager to manage itself, enabling updates and
  # self-maintenance through the standard home-manager commands.
  programs.home-manager.enable = true;
}

