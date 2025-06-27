# System services configuration - Display manager and related services
{ pkgs, ... }:

{
  # Display manager configuration
  # Handles user login screen and session management
  services.displayManager = {
    # Enable SDDM (Simple Desktop Display Manager)
    # Modern Qt-based display manager with theming support
    sddm = {
      enable = true;
      
      # Custom SDDM theme configuration
      # Uses the astronaut theme defined in sddm-theme.nix
      theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
    };
  };

  # System packages required for display manager functionality
  environment.systemPackages = [
    # Qt5 graphical effects library
    # Required for SDDM theme animations and visual effects
    pkgs.libsForQt5.qt5.qtgraphicaleffects
  ];
}
