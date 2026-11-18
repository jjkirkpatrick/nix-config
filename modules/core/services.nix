# System services configuration - Display manager and related services
{ pkgs, ... }:

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

  # At cold boot the NVIDIA driver can still be link-training the DP/HDMI
  # outputs when SDDM's weston-based greeter starts, so every connector
  # reports "disconnected" and weston dies with "Could not enable any
  # output" -- leaving a blank screen with no greeter and no auto-retry.
  # Waiting for udev to settle (plus a short safety margin) gives the
  # outputs time to come up before the greeter tries to bind them.
  systemd.services.display-manager = {
    after = [ "systemd-udev-settle.service" ];
    wants = [ "systemd-udev-settle.service" ];
    serviceConfig.ExecStartPre = [ "${pkgs.coreutils}/bin/sleep 2" ];
  };

}
