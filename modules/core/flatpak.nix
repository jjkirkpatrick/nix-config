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
    enable = false;
    
    # Declaratively managed Flatpak applications
    # These will be automatically installed when Flatpak is enabled
    packages = [
      # Flatseal - Flatpak permission manager
      # GUI tool for managing Flatpak application permissions and overrides
      "com.github.tchx84.Flatseal"
      
      # Olympus - Celeste mod installer and manager
      # Tool for managing mods for the Celeste game
      "io.github.everestapi.Olympus"
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
