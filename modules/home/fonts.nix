{ pkgs, ... }:
{
  # Font configuration for home-manager
  fonts.fontconfig.enable = true;
  
  home.packages = with pkgs; [
    # Font Awesome - Icon fonts
    font-awesome          # Font Awesome 6 Free
    
    # Powerline fonts
    powerline-fonts       # Powerline patched fonts
    
    # Basic Nerd Font
    nerd-fonts.jetbrains-mono     # JetBrains Mono with Nerd Font patches
  ];
}