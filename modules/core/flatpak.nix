# Flatpak application sandboxing and distribution system
{ inputs, ... }:
{
  # Import nix-flatpak module for declarative Flatpak management
  # Allows managing Flatpak applications through Nix configuration
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  # Flatpak service configuration
  services.flatpak = {
    # Flatpak is currently disabled
    # Enable this to use sandboxed applications from Flathub
    enable = true;
    
    # Declaratively managed Flatpak applications
    # These will be automatically installed when Flatpak is enabled
    packages = [
    ];
    
    # Global application overrides and permissions
    overrides = {
      # Apply these settings to all Flatpak applications
      global = {
        # Display server preferences
        # Force applications to use Wayland instead of X11
        Context.sockets = [
          # Enable Wayland socket access
          "wayland"
          # Disable X11 socket access (! prefix means disable)
          "!x11"
          # Disable X11 fallback
          "!fallback-x11"
        ];
      };
    };
  };
}
