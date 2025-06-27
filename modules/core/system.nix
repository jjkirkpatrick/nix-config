# Core system configuration - Nix settings, locale, and essential packages
{ pkgs, inputs, ... }:
{
  # Commented out: Nix Gaming modules (not currently used)
  # imports = [ inputs.nix-gaming.nixosModules.default ];
  
  # Nix package manager configuration
  nix = {
    settings = {
      # Automatically optimize the Nix store by hardlinking identical files
      auto-optimise-store = true;
      
      # Enable experimental Nix features for flakes and new CLI
      experimental-features = [
        "nix-command"  # New nix CLI commands
        "flakes"       # Flake system for reproducible configurations
      ];
      
      # Binary cache substituters for faster package downloads
      substituters = [
        "https://nix-community.cachix.org"  # Community packages cache
        "https://hyprland.cachix.org"       # Hyprland compositor cache
        "https://ghostty.cachix.org"        # Ghostty terminal cache
      ];
      
      # Public keys for verifying binary cache integrity
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      ];
    };
  };
  
  # Nixpkgs configuration and overlays
  nixpkgs = {
    # Apply NUR (Nix User Repository) overlay for additional packages
    overlays = [ inputs.nur.overlays.default ];
  };

  # Essential system packages available to all users
  environment.systemPackages = with pkgs; [
    wget          # File downloader
    git           # Version control system
    home-manager  # User environment manager
  ];

  # Create /bin/sh symlink for compatibility with non-NixOS applications
  # Many applications (including Flatpaks) expect /bin/sh to exist
  environment.binsh = "${pkgs.dash}/bin/dash";
  
  # System-wide environment variables
  environment.sessionVariables = {
    # Add Flatpak application directories to XDG_DATA_DIRS
    # This ensures Flatpak applications appear in application menus
    XDG_DATA_DIRS = [
      "/var/lib/flatpak/exports/share"
      "$HOME/.local/share/flatpak/exports/share"
      "/usr/share"
      "/run/current-system/sw/share"
    ];
  };

  # System timezone configuration
  time.timeZone = "Europe/London";
  
  # Internationalization settings for UK English
  i18n.defaultLocale = "en_GB.UTF-8";
  
  # Allow installation of proprietary/unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # NixOS release version for compatibility tracking
  system.stateVersion = "25.05";
}
