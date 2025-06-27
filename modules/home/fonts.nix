# ======================================================================
# FONT CONFIGURATION
# ======================================================================
# This module manages font installation and configuration for the user
# environment. It includes programming fonts, icon fonts, and display fonts
# used across applications like terminals, editors, and the desktop environment.
#
# Fonts are crucial for readability and aesthetics in development environments
# and desktop applications. This configuration ensures consistent typography
# across all applications.
# ======================================================================

{ pkgs, ... }:
{
  # ============================================================
  # FONTCONFIG CONFIGURATION
  # ============================================================
  # Enable fontconfig for proper font management and rendering
  # This ensures fonts are properly detected and configured system-wide
  
  fonts.fontconfig.enable = true;
  
  # ============================================================
  # FONT PACKAGE INSTALLATION
  # ============================================================
  # Install essential fonts for development, desktop use, and icons
  
  home.packages = with pkgs; [
    # ========================================
    # Icon Fonts
    # ========================================
    font-awesome          # Font Awesome 6 Free - Comprehensive icon set
                         # Used in status bars, application launchers, and UI elements
                         # Provides consistent iconography across the desktop environment

    # ========================================
    # Terminal and Development Fonts
    # ========================================
    powerline-fonts       # Powerline patched fonts - Enhanced glyphs for shell prompts
                         # Includes additional symbols and powerline separators
                         # Used by shell themes like Powerlevel10k and Starship

    nerd-fonts.jetbrains-mono     # JetBrains Mono with Nerd Font patches
                                 # Professional monospace font designed for coding
                                 # Features:
                                 # - Excellent readability for code
                                 # - Clear distinction between similar characters (0/O, 1/l/I)
                                 # - Nerd Font patches add thousands of glyphs and icons
                                 # - Perfect for terminals, editors, and IDEs
                                 # - Consistent character width for proper alignment
  ];

  # ============================================================
  # FONT USAGE NOTES
  # ============================================================
  # JetBrains Mono Nerd Font is used as the primary font across:
  # - Terminal emulator (Kitty)
  # - Text editors (Neovim, VS Code)
  # - Status bar (Waybar)
  # - Application launcher (Rofi)
  #
  # Font Awesome provides icons for:
  # - Waybar modules and indicators
  # - Application launcher icons
  # - Window manager status indicators
  #
  # This font selection ensures:
  # - Consistent appearance across applications
  # - Excellent readability for code and text
  # - Rich iconography for UI elements
  # - Professional appearance for development work
}