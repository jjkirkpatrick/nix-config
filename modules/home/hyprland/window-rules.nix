{ ... }:
let
  browser = "brave";
in
{
  wayland.windowManager.hyprland.settings = {
    # window rules
    windowrule = [
      # floating windows
      "float,class:^(Viewnior)$"
      "float,class:^(imv)$"
      "float,class:^(mpv)$"
      "float,class:^(Audacious)$"
      "float,title:^(Transmission)$"
      "float,title:^(Volume Control)$"
      "float,title:^(Firefox — Sharing Indicator)$"
      "float, title:^(Picture-in-Picture)$"
      "float,class:^(org.gnome.Calculator)$"
      "float,class:^(waypaper)$"
      "float,class:^(zenity)$"
      "float,class:^(org.gnome.FileRoller)$"
      "float,class:^(org.pulseaudio.pavucontrol)$"
      "float,class:^(SoundWireServer)$"
      "float,class:^(.sameboy-wrapped)$"
      "float,class:^(file_progress)$"
      "float,class:^(confirm)$"
      "float,class:^(dialog)$"
      "float,class:^(download)$"
      "float,class:^(notification)$"
      "float,class:^(error)$"
      "float,class:^(confirmreset)$"
      "float,title:^(Open File)$"
      "float,title:^(File Upload)$"
      "float,title:^(branchdialog)$"
      "float,title:^(Confirm to replace files)$"
      "float,title:^(File Operation Progress)$"

      # tiled windows
      "tile,class:^(Aseprite)$"
      
      # pinned windows
      "pin,class:^(rofi)$"
      "pin,class:^(waypaper)$"
      "pin, title:^(Picture-in-Picture)$"

      # positioning and sizing
      "move 0 0,title:^(Firefox — Sharing Indicator)$"
      "size 700 450,title:^(Volume Control)$"
      "move 40 55%,title:^(Volume Control)$"
      "size 850 500,class:^(zenity)$"
      "size 725 330,class:^(SoundWireServer)$"

      # opacity overrides for terminals and specific apps
      "opacity 0.85 override 0.75 override, class:^(kitty)$"              # Terminal transparency
      "opacity 0.85 override 0.75 override, class:^(Alacritty)$"          # Alternative terminal
      "opacity 0.85 override 0.75 override, class:^(wezterm)$"            # Alternative terminal
      "opacity 0.90 override 0.80 override, class:^(vscodium)$"           # Code editor transparency
      "opacity 0.90 override 0.80 override, class:^(Code)$"               # VS Code transparency
      "opacity 0.95 override 0.85 override, class:^(brave-browser)$"      # Browser slight transparency
      "opacity 0.95 override 0.85 override, class:^(firefox)$"            # Firefox slight transparency
      
      # Keep these apps fully opaque
      "opacity 1.0 override 1.0 override, title:^(Picture-in-Picture)$"
      "opacity 1.0 override 1.0 override, title:^(.*imv.*)$"
      "opacity 1.0 override 1.0 override, title:^(.*mpv.*)$"
      "opacity 1.0 override 1.0 override, class:(Aseprite)"
      "opacity 1.0 override 1.0 override, class:(Unity)"
      "opacity 1.0 override 1.0 override, class:(zen)"
      "opacity 1.0 override 1.0 override, class:(evince)"
      "opacity 1.0 override 1.0 override, class:(Gimp-2.10)"              # Keep GIMP opaque
      "opacity 1.0 override 1.0 override, class:(discord)"                # Keep Discord opaque
      "opacity 1.0 override 1.0 override, class:(WebCord)"                # Keep WebCord opaque

      # workspace assignments
      "workspace 1, class:^(${browser})$"
      "workspace 3, class:^(evince)$"
      "workspace 4, class:^(Gimp-2.10)$"
      "workspace 4, class:^(Aseprite)$"
      "workspace 5, class:^(Audacious)$"
      "workspace 5, class:^(Spotify)$"
      "workspace 8, class:^(com.obsproject.Studio)$"
      "workspace 10, class:^(discord)$"
      "workspace 10, class:^(WebCord)$"

      # idle inhibition
      "idleinhibit focus, class:^(mpv)$"
      "idleinhibit fullscreen, class:^(firefox)$"

      # xwaylandvideobridge rules
      "opacity 0.0 override,class:^(xwaylandvideobridge)$"
      "noanim,class:^(xwaylandvideobridge)$"
      "noinitialfocus,class:^(xwaylandvideobridge)$"
      "maxsize 1 1,class:^(xwaylandvideobridge)$"
      "noblur,class:^(xwaylandvideobridge)$"

      # no gaps when only one window
      "bordersize 0, floating:0, onworkspace:w[t1]"
      "rounding 0, floating:0, onworkspace:w[t1]"
      "bordersize 0, floating:0, onworkspace:w[tg1]"
      "rounding 0, floating:0, onworkspace:w[tg1]"
      "bordersize 0, floating:0, onworkspace:f[1]"
      "rounding 0, floating:0, onworkspace:f[1]"

      # remove context menu transparency in chromium based apps
      "opaque,class:^()$,title:^()$"
      "noshadow,class:^()$,title:^()$"
      "noblur,class:^()$,title:^()$"
    ];

    # workspace rules for no gaps when only one window
    workspace = [
      "w[t1], gapsout:0, gapsin:0"
      "w[tg1], gapsout:0, gapsin:0"
      "f[1], gapsout:0, gapsin:0"
    ];
  };
}