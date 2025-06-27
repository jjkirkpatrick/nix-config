# Hyprland Wayland compositor configuration
{ inputs, pkgs, ... }:
{
  # Hyprland compositor configuration
  programs.hyprland = {
    # Enable Hyprland as a system program
    enable = true;
    
    # Use Hyprland package from the flake input
    # Ensures we get the latest version with all features
    package = inputs.hyprland.packages.${pkgs.system}.default;
    
    # XDG Desktop Portal for Hyprland
    # Handles screen sharing, file picking, and other desktop integration
    portalPackage =
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  # XDG Desktop Portal configuration
  # Handles desktop integration for applications
  xdg.portal = {
    # Enable XDG Desktop Portal system
    enable = true;
    
    # Use portal for xdg-open operations
    # Ensures file opening uses the portal system
    xdgOpenUsePortal = true;
    
    # Portal backend configuration
    config = {
      # Default portal for all applications
      common.default = [ "gtk" ];
      
      # Hyprland-specific portal configuration
      hyprland.default = [
        "gtk"       # GTK portal for file dialogs
        "hyprland"  # Hyprland portal for screen capture
      ];
    };

    # Additional portal backends
    # GTK portal provides file dialogs and other GTK integrations
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Essential Wayland/Hyprland applications and utilities
  environment.systemPackages = with pkgs; [
    # Wallpaper management
    # Hyprpaper - wallpaper daemon for Hyprland
    hyprpaper
    
    # Terminal emulator
    # Kitty - GPU-accelerated terminal with good Wayland support
    kitty
    
    # Notification system
    # libnotify - command-line notification library
    libnotify
    # Mako - lightweight Wayland notification daemon
    mako
    
    # Qt Wayland support
    # Required for Qt applications to run properly on Wayland
    qt5.qtwayland
    qt6.qtwayland
    
    # Power management and screen locking
    # Swayidle - idle management daemon
    swayidle
    # Swaylock-effects - screen locker with visual effects
    swaylock-effects
    
    # Session management
    # Wlogout - logout menu for Wayland
    wlogout
    
    # Clipboard management
    # wl-clipboard - command-line Wayland clipboard utilities
    wl-clipboard
    
    # Application launcher
    # Wofi - application launcher and dmenu replacement for Wayland
    wofi
    
    # Status bar
    # Waybar - highly customizable status bar for Wayland
    waybar
  ]; 
}
