{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    # autostart applications
    exec-once = [
      "hyprpaper &"
      "waybar &"
      #"swaync &"
      "hyprctl setcursor Bibata-Modern-Ice 24 &"
      #"swww-daemon &"
      
      # "hyprlock"

      "eww open bar &"
      "eww open bottom-bar &"
      "eww open top-bar &"


      # Example application launches (commented out)
      # "${terminal} --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
      # "[workspace 1 silent] ${browser}"
      # "[workspace 2 silent] ${terminal}"
    ];
  };
}