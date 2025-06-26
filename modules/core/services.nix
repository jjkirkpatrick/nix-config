{ pkgs, ... }:
{
  services.displayManager = {
   enable = true;
   sddm.enable = true;
   defaultSession = "hyprland";
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
