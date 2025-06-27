# Wayland compositor configuration - Hyprland setup
{ inputs, pkgs, ... }:
{
  # Configure Hyprland compositor
  programs.hyprland = {
    # Enable Hyprland window manager
    enable = true;
    # Enable XWayland for X11 application compatibility
    xwayland.enable = true; 
    # Use Hyprland package from flake input for latest features
    package = inputs.hyprland.packages.${pkgs.system}.default;
    # Use Hyprland's XDG desktop portal for better integration
    portalPackage =
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  # Configure XDG desktop portals for application integration
  xdg.portal = {
    # Enable XDG desktop portal support
    enable = true;
    # Use portals for xdg-open and similar operations
    xdgOpenUsePortal = true;
    
    # Portal configuration for different desktop environments
    config = {
      # Default portal for general applications
      common.default = [ "gtk" ];
      # Hyprland-specific portal configuration
      hyprland.default = [
        "gtk"       # GTK file picker and other GTK portals
        "hyprland"  # Hyprland-specific portals (screenshots, etc.)
      ];
    };

    # Additional portal implementations
    extraPortals = [ 
      pkgs.xdg-desktop-portal-gtk  # GTK portal for file dialogs, etc.
    ];
  };
}
