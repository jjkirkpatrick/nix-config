# Nh (NixOS Helper) - Enhanced NixOS rebuild and management tool
{ pkgs, username, ... }:
{
  # Nh program configuration - modern NixOS system management
  programs.nh = {
    # Enable nh as a system program
    # Nh provides a better interface for nixos-rebuild with colored output
    enable = true;
    
    # Automatic cleanup configuration
    clean = {
      # Enable automatic cleanup of old generations and store paths
      enable = true;
      
      # Cleanup arguments to preserve recent builds
      # --keep-since 7d: Keep all generations from the last 7 days
      # --keep 5: Always keep at least 5 most recent generations
      extraArgs = "--keep-since 7d --keep 5";
    };
    
    # Path to the NixOS flake configuration
    # Points to the user's nixos-config directory
    flake = "/home/${username}/nixos-config";
  };

  # Additional system packages for Nix management
  environment.systemPackages = with pkgs; [
    # Nix Output Monitor - provides better build output formatting
    # Shows progress bars and cleaner output during builds
    nix-output-monitor
    
    # Nix Version Diff - compares package versions between generations
    # Useful for seeing what changed between system rebuilds
    nvd
  ];
}
