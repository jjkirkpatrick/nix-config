# Steam gaming platform configuration
{ pkgs, inputs, ... }:
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

  environment.systemPackages = with pkgs; [
    runelite

    # osrs-login — minimal browser-login launcher that execs runelite with the
    # Jagex JX_* session vars (https://github.com/jjkirkpatrick/osrs-login)
    inputs.osrs-login.packages.${pkgs.stdenv.hostPlatform.system}.default

    # App-launcher entry: opens kitty running `osrs-login pick` so you can choose
    # a character and launch (reuses the cached session; no browser unless it has
    # expired). osrs-login is interactive, so it needs a terminal.
    (makeDesktopItem {
      name = "osrs-login";
      desktopName = "Old School RuneScape";
      comment = "Launch OSRS via Jagex login (RuneLite)";
      exec = "kitty --class osrs-login -e osrs-login pick";
      terminal = false;
      categories = [ "Game" ];
    })
  ];
}
