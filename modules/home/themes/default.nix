# ======================================================================
# THEME MANAGEMENT SYSTEM
# ======================================================================
# This module provides a centralized theme management system for the entire
# user environment. It allows easy switching between different visual themes
# and ensures consistent theming across all applications and configurations.
#
# The theme system:
# - Provides a single point of theme configuration
# - Exports theme variables for other modules to use
# - Supports multiple theme definitions
# - Enables easy theme switching without modifying individual configs
# - Maintains visual consistency across the desktop environment
# ======================================================================

{ pkgs, lib, ... }:
let
  # ============================================================
  # THEME SELECTION
  # ============================================================
  # Current active theme - change this string to switch themes
  # Available themes:
  # - "dark-space": Space-themed dark theme with cosmic colors
  # - Add other themes as directories under ./themes/
  currentTheme = "dark-space";
  
  # ============================================================
  # THEME IMPORT AND CONFIGURATION
  # ============================================================
  # Import the selected theme configuration from its directory
  # Each theme directory should contain:
  # - default.nix: Main theme configuration with color definitions
  # - Additional files: Application-specific configurations
  theme = import ./${currentTheme} { inherit lib; };
in
{
  # ============================================================
  # THEME EXPORT TO OTHER MODULES
  # ============================================================
  # Export theme variables to make them available to all other modules
  # This allows consistent theming across applications like:
  # - Terminal colors (Kitty, Alacritty)
  # - Status bar appearance (Waybar)
  # - Window manager themes (Hyprland)
  # - Application launchers (Rofi, Wofi)
  # - Text editors and development environments
  _module.args.theme = theme;
  
  # ============================================================
  # THEME-SPECIFIC MODULE IMPORTS (OPTIONAL)
  # ============================================================
  # Uncomment and customize to import theme-specific configurations
  # This allows themes to override or extend default configurations
  # imports = [
  #   ./${currentTheme}/module-overrides.nix    # Theme-specific config overrides
  #   ./${currentTheme}/application-configs.nix # Theme-specific app configurations
  #   ./${currentTheme}/wallpaper-config.nix    # Theme-specific wallpaper settings
  # ];
  
  # ============================================================
  # GLOBAL THEME CONFIGURATION
  # ============================================================
  # Configuration that applies globally across all modules
  config = {
    # ========================================
    # Environment Variables for Theme
    # ========================================
    # Set environment variables for applications that check for theme preferences
    # home.sessionVariables = {
    #   THEME_NAME = currentTheme;                    # Current theme identifier
    #   GTK_THEME = theme.gtk.theme or "Adwaita";    # GTK application theme
    #   QT_STYLE_OVERRIDE = theme.qt.style or "";    # Qt application theme
    #   CURSOR_THEME = theme.cursor.name or "";      # Cursor theme name
    # };
    
    # ========================================
    # Global Theme Settings
    # ========================================
    # You can add global theme settings here that affect all applications:
    # - Default fonts and font sizes
    # - Global color preferences
    # - Accessibility settings
    # - Animation preferences
    
    # Example global settings (customize based on theme needs):
    # fonts.fontconfig.defaultFonts = {
    #   monospace = theme.fonts.monospace or ["JetBrains Mono"];
    #   sansSerif = theme.fonts.sansSerif or ["Inter"];
    #   serif = theme.fonts.serif or ["Source Serif Pro"];
    # };
  };
  
  # ============================================================
  # THEME MANAGEMENT NOTES
  # ============================================================
  # To add a new theme:
  # 1. Create a new directory under ./themes/ with the theme name
  # 2. Add a default.nix file with color definitions and settings
  # 3. Update currentTheme variable to the new theme name
  # 4. Optionally add application-specific configurations
  #
  # Theme structure example:
  # themes/
  # ├── dark-space/
  # │   ├── default.nix           # Main theme configuration
  # │   ├── colors.nix           # Color palette definitions
  # │   ├── kitty.nix            # Terminal theme
  # │   └── rofi.rasi            # Application launcher theme
  # └── light-theme/
  #     └── default.nix           # Alternative theme
  #
  # This modular approach ensures:
  # - Easy theme switching
  # - Consistent visual experience
  # - Maintainable theme definitions
  # - Flexibility for customization
}