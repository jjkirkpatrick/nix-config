# Steam gaming platform configuration
{ pkgs, ... }:
{
  programs = {
    # Steam gaming client configuration
    steam = {
      # Enable Steam with NixOS integration
      # Provides automatic library management and sandboxing
      enable = true;

      # Network configuration for Steam features
      remotePlay = {
        # Open firewall ports for Steam Remote Play
        # Allows streaming games to other devices on the network
        openFirewall = true;
      };
      
      dedicatedServer = {
        # Keep firewall closed for dedicated game servers
        # Only enable if hosting game servers
        openFirewall = false;
      };

      # GameScope session configuration
      # GameScope is a micro-compositor for better gaming performance
      gamescopeSession = {
        # Enable GameScope session option in display manager
        # Provides optimized gaming environment with better frame timing
        enable = true;
      };

      # Additional compatibility layers for Windows games
      extraCompatPackages = [
        # Proton-GE (GloriousEggroll) - Enhanced Proton version
        # Includes additional patches and codecs for better game compatibility
        # Often has better support for newer games than official Proton
        pkgs.proton-ge-bin
      ];
    };
  };
}
