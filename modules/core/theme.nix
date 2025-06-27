# System theming and appearance configuration
{ pkgs, ... }:

{
  # Theme-related system packages
  environment.systemPackages = with pkgs; [
    # Icon themes
    # Adwaita icon theme - default GNOME icon set
    # Provides consistent icons across GTK applications
    adwaita-icon-theme
    
    # Core libraries for theme support
    # GLib - fundamental library for GTK applications
    # Required for proper theme and settings management
    glib
    
    # Desktop environment schemas
    # Contains GSettings schemas for desktop applications
    # Required for theme settings to work properly across applications
    gsettings-desktop-schemas

    # Theme configuration tools
    # NWG Look - GTK theme configuration utility
    # GUI tool for setting GTK themes, icons, fonts, and cursors
    # Particularly useful for non-GNOME desktop environments
    nwg-look
  ];
}