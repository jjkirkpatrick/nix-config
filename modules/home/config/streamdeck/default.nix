{ config, lib, pkgs, ... }:

{
  # StreamDeck UI configuration
  xdg.configFile."streamdeck_ui/config.json".source = ./config.json;
  
  # Font configuration for StreamDeck UI
  fonts.fontconfig.enable = true;
  
  # SystemD user service for StreamDeck
  systemd.user.services.streamdeck = {
    Unit = {
      Description = "StreamDeck UI Service";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.streamdeck-ui}/bin/streamdeck -n";
      Restart = "always";
      RestartSec = 3;
      Environment = [
        "PATH=${lib.makeBinPath [ pkgs.fontconfig pkgs.coreutils ]}"
      ];
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
  
  # Additional packages needed for StreamDeck functionality
  home.packages = with pkgs; [
    fontconfig  # For fc-list command
  ];
}