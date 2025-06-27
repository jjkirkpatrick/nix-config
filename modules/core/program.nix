# System-wide program configurations
{ pkgs, ... }:
{
  # Configuration management programs
  
  # Enable dconf for GNOME/GTK application settings management
  # Required for many GUI applications to save their preferences
  programs.dconf.enable = true;
  
  # Enable Zsh shell system-wide
  # Modern shell with better completion and customization options
  programs.zsh.enable = true;
  
  # GnuPG agent configuration
  programs.gnupg.agent = {
    # Disable GnuPG agent (using alternative or not needed)
    enable = false;
    
    # Disable SSH support in GnuPG agent
    # SSH key management handled elsewhere
    enableSSHSupport = false;
    
    # PIN entry method (commented out since agent is disabled)
    # Options: "curses", "gtk2", "gnome3", "qt"
    # pinentryFlavor = "";
  };
  
  # Dynamic linker for running unpatched binaries
  # nix-ld allows running non-NixOS binaries by providing a standard FHS environment
  programs.nix-ld = {
    # Enable nix-ld for compatibility with non-Nix binaries
    enable = true;
    
    # Additional libraries to make available to non-Nix binaries
    # Currently empty - add libraries as needed for specific software
    libraries = with pkgs; [ ];
  };
}
