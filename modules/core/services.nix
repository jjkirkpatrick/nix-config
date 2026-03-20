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
      extraPackages = [ pkgs.sddm-astronaut ];
      settings.General.InputMethod = "";
      wayland.enable = true;
    };
  };

}
