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

}
