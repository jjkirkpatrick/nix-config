# System services configuration - Display manager and related services
{ pkgs, lib, ... }:

{
  # Display manager configuration
  # Handles user login screen and session management
  services.displayManager = {
    sddm = {
      enable = true;
      theme = "sddm-astronaut-theme";
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs.kdePackages; [ qtmultimedia ];
      settings.General.InputMethod = "";
      wayland.enable = true;
    };
  };

  # sddm-astronaut must be in systemPackages so its theme folder is linked
  # into /run/current-system/sw/share/sddm/themes/ where SDDM looks for themes
  environment.systemPackages = [ pkgs.sddm-astronaut ];

  # At cold boot the NVIDIA driver can still be link-training the outputs
  # when SDDM's weston greeter starts ("Could not enable any output").
  # NixOS already sets Restart=always on the display manager; instead of the
  # deprecated udev-settle + sleep, space the retries out (default 200ms) so
  # the outputs come up before the start-limit burst is used up.
  systemd.services.display-manager.serviceConfig.RestartSec = lib.mkForce "3s";

}
