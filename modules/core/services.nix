{ pkgs, ... }:
{

  
  environment.systemPackages = [(
    pkgs.where-is-my-sddm-theme.override {
      themeConfig.General = {
        background = "${../../wallpapers/space.png}";
        backgroundMode = "fill";
        # Dark Space Theme Colors
        primaryColor = "#F8FAFC";      # Star white
        accentColor = "#8B5CF6";       # Purple accent
        backgroundColor = "#0B0D17";   # Deep space
        disabledColor = "#64748B";     # Disabled gray
        # Font configuration
        font = "JetBrains Mono";
        fontSize = "11";
        # Interface styling
        radius = "12";
        # Input field styling
        placeholderColor = "#A0A8B8";  # Muted gray
      };
    }
  )];

  services.displayManager = {
   defaultSession = "hyprland";
  };

  services.displayManager.sddm = {
    enable = true;
    theme = "where_is_my_sddm_theme"; 
    package = pkgs.libsForQt5.sddm;
  };
}
