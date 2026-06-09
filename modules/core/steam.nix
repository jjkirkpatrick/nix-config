# Steam gaming platform configuration
{ pkgs, inputs, ... }:
let
  # Bolt (the Linux launcher for OSRS Jagex-account login) embeds a CEF
  # browser for the login flow. On NixOS its bundled chrome-sandbox can't be
  # SUID, and CEF's nested sandbox fails inside bolt's bwrap FHS env, so CEF
  # aborts on startup (SIGABRT, "ContentMainInitialize failed") and login
  # never opens. Launching with --no-sandbox makes CEF init cleanly.
  bolt-launcher-nosandbox = pkgs.symlinkJoin {
    name = "bolt-launcher-nosandbox";
    paths = [ pkgs.bolt-launcher ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/bolt-launcher --add-flags "--no-sandbox"
    '';
  };
in
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
    bolt-launcher-nosandbox  # bolt-launcher wrapped to pass --no-sandbox (CEF fix)
    runelite

    # osrs-login — minimal browser-login launcher that execs runelite with the
    # Jagex JX_* session vars (https://github.com/jjkirkpatrick/osrs-login)
    inputs.osrs-login.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
