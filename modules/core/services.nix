{ pkgs, ... }:
{

  
  environment.systemPackages = [(
    pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      font  = "Noto Sans";
      fontSize = "9";
      background = "${../../wallpapers/astronaut.jpg}";
      loginBackground = true;
    }
  )];

  services.displayManager = {
   defaultSession = "hyprland";
  };

  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha"; 
    package = pkgs.kdePackages.sddm;
  };
}
