{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    # autostart applications
    exec-once = [
      #"waybar &"
      #"swaync &"
      "hyprctl setcursor Bibata-Modern-Ice 24 &"
      #"swww-daemon &"
      
      # "hyprlock"

      # Example application launches (commented out)
      # "${terminal} --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false"
      # "[workspace 1 silent] ${browser}"
      # "[workspace 2 silent] ${terminal}"
    ];
  };
}