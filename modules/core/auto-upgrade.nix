# Automatic system upgrade configuration
{ ... }:

{
  # Automated NixOS system upgrades
  # NOTE: This only handles NixOS system packages and configuration
  # For comprehensive upgrades including cargo/npm/pip packages, Docker containers,
  # and other system components, use the `topgrade` CLI utility manually
  # Recommended: Run `topgrade` weekly or monthly for complete system maintenance
  system.autoUpgrade = {
    # Enable automatic system upgrades
    enable = true;
    
    # Upgrade operation type
    # "switch": Apply updates immediately after download
    # "boot": Only apply updates after next reboot (safer for servers)
    operation = "switch";
    
    # Path to the NixOS flake configuration
    # Points to system flake for upgrade source
    flake = "/etc/nixos";
    
    # Additional flags for the upgrade process
    flags = [
      # Update nixpkgs input to latest version
      "--update-input" "nixpkgs"
      # Update rust-overlay input for latest Rust toolchain
      "--update-input" "rust-overlay"
      # Commit the updated lock file to version control
      "--commit-lock-file"
    ];
    
    # Upgrade schedule
    # Options: "daily", "weekly", "monthly", or systemd timer format
    dates = "weekly";
    
    # Legacy channel-based updates (commented out)
    # Modern flake-based systems use the flake input instead
    # channel = "https://nixos.org/channels/nixos-unstable";
  };
}
