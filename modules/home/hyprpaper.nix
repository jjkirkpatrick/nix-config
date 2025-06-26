{ pkgs, ... }:
{
  services.hyprpaper = {
    enable = true;
    
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;
      
      # Preload wallpapers
      preload = [
        "~/Pictures/wallpapers/astronaut.jpg"
      ];
      
      # Set wallpapers for monitors
      wallpaper = [
        "DP-3,~/Pictures/wallpapers/astronaut.jpg"
        "HDMI-A-1,~/Pictures/wallpapers/astronaut.jpg"
        ",~/Pictures/wallpapers/astronaut.jpg" # fallback for any monitor
      ];
    };
  };

  # Ensure wallpapers directory exists and copy wallpapers
  home.file."Pictures/wallpapers/astronaut.jpg" = {
    source = ../../wallpapers/astronaut.jpg;
  };
}