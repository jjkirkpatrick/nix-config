# Core system configuration - Nix settings, locale, and essential packages
{ pkgs, inputs, ... }:
{
  # Commented out: Nix Gaming modules (not currently used)
  # imports = [ inputs.nix-gaming.nixosModules.default ];
  
  # Nix package manager configuration
  nix = {
    settings = {
      # Enable experimental Nix features for flakes and new CLI
      experimental-features = [
        "nix-command"  # New nix CLI commands
        "flakes"       # Flake system for reproducible configurations
      ];
      
      # Binary cache substituters for faster package downloads
      substituters = [
        "https://nix-community.cachix.org"  # Community packages cache
        "https://hyprland.cachix.org"       # Hyprland compositor cache
      ];
      
      # Public keys for verifying binary cache integrity
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
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
    lm_sensors    # Hardware monitoring: `sensors` reads CPU (k10temp), mobo, RAM temps
    smartmontools # SSD/HDD health: `smartctl -H -A /dev/nvme0` for wear/SMART attrs
  ];

  # Create /bin/sh symlink for compatibility with non-NixOS applications
  # Many applications (including Flatpaks) expect /bin/sh to exist
  environment.binsh = "${pkgs.dash}/bin/dash";
  
  # (No custom XDG_DATA_DIRS: services.flatpak already adds both flatpak
  # export dirs via environment.profiles, and re-listing
  # /run/current-system/sw/share made dbus-broker log duplicate-service
  # errors on every login.)

  # Cap the persistent journal (it had grown to 3.3G unbounded).
  services.journald.settings.Journal.SystemMaxUse = "1G";

  # Compressed swap in RAM, used before the disk swap partition (higher
  # priority). Much faster than paging to NVMe under memory pressure.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
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
