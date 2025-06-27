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
        "~/Pictures/wallpapers/space.png"
      ];
      
      # Set wallpapers for monitors
      wallpaper = [
        "DP-3,~/Pictures/wallpapers/space.png"
        "HDMI-A-1,~/Pictures/wallpapers/space.png"
        ",~/Pictures/wallpapers/space.png" # fallback for any monitor
      ];
    };
  };

  # Ensure wallpapers directory exists and copy wallpapers
  home.file."Pictures/wallpapers/space.png" = {
    source = ../../wallpapers/space.png;
  };
}