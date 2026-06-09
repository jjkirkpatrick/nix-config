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
  
  # Enable binfmt so AppImages execute directly without appimage-run prefix
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  # Dynamic linker for running unpatched binaries
  # nix-ld allows running non-NixOS binaries by providing a standard FHS environment
  programs.nix-ld = {
    # Enable nix-ld for compatibility with non-Nix binaries
    enable = true;
    
    # Libraries required for pre-compiled binaries (Electron, Chromium-based devtools, etc.)
    libraries = with pkgs; [
      glib
      nss
      nspr
      dbus
      atk
      at-spi2-atk
      at-spi2-core
      cups
      libdrm
      gtk3
      mesa
      alsa-lib
      expat
      libxkbcommon
      pango
      cairo
      xorg.libX11
      xorg.libXext
      xorg.libXfixes
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxcb
    ];
  };
}
