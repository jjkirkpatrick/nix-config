# ======================================================================
# DESKTOP ENVIRONMENT HOME MANAGER CONFIGURATION
# ======================================================================
# This configuration extends the base home-manager setup (default.nix)
# with desktop environment specific configurations. It's designed to be
# used when the system has a graphical desktop environment.
#
# Usage:
# - For desktop/laptop systems: Use this file as the home configuration
# - For servers/headless systems: Use default.nix directly
#
# This provides a clean separation between base configurations and
# desktop-specific features like window managers, GUI applications, etc.
# ======================================================================

{ ... }:
{
  # ============================================================
  # DESKTOP CONFIGURATION IMPORTS
  # ============================================================
  # Import the base home-manager configuration which contains all
  # the core functionality (shell, development tools, etc.)
  
  imports = [
    ./default.nix                     # Base home-manager configuration
    
    # Desktop-specific modules would be added here when needed
    # For example:
    # ./hyprland.nix                  # Hyprland window manager configuration
    # ./gtk.nix                       # GTK theme configuration
    # ./qt.nix                        # Qt application theming
    # ./desktop-packages.nix          # Desktop-specific packages
  ];

  # ============================================================
  # DESKTOP-SPECIFIC CONFIGURATION
  # ============================================================
  # Additional desktop environment configurations can be added here
  # Currently, all desktop functionality is handled through the imported
  # modules, but this section can be expanded as needed.
}
