{ pkgs, ... }:
{

  
  environment.systemPackages = [(
    pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      font  = "Noto Sans";
      fontSize = "9";
      background = "${./wallpaper.png}";
      loginBackground = true;
    }
  )];

  services.displayManager = {
   defaultSession = "hyprland";
  };

  services.displayManager.sddm {
    enable = true;
    theme = "catppuccin-mocha"; 
    package = pkgs.kdePackages.sddm;
  };


  programs = {
    steam = {
      enable = false;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;

      gamescopeSession.enable = true;

      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
  };
}
