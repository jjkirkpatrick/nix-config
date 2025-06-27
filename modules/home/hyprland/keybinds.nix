{ ... }:
let
  browser = "brave";
  terminal = "kitty";
in
{
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";

    binds = {
      movefocus_cycles_fullscreen = true;
    };

    bind = [
      # show keybinds list
      "$mainMod, K, exec, show-keybinds"

      # application launchers
      "$mainMod, Return, exec, ${terminal}"
      "ALT, Return, exec, [float; size 1111 700] ${terminal}"
      "$mainMod SHIFT, Return, exec, [fullscreen] ${terminal}"
      "$mainMod, B, exec, [workspace 1 silent] ${browser}"
      "$mainMod, R, exec, rofi -show drun || pkill rofi"
      "$mainMod, E, exec, nemo"
      "ALT, E, exec, hyprctl dispatch exec '[float; size 1111 700] nemo'"

      # window management
      "$mainMod, Q, killactive,"
      "$mainMod, F, fullscreen, 0"
      "$mainMod SHIFT, F, fullscreen, 1"
      "$mainMod, Space, exec, toggle-float"
      "$mainMod, P, pseudo,"
      "$mainMod, X, togglesplit,"

      # system controls
      "$mainMod, Escape, exec, hyprlock"
      "ALT, Escape, exec, hyprlock"
      "$mainMod SHIFT, Escape, exec, power-menu"
      "CTRL SHIFT, Escape, exec, hyprctl dispatch exec '[workspace 9] missioncenter'"

      # utilities
      "$mainMod, T, exec, toggle-oppacity"
      "$mainMod SHIFT, B, exec, toggle-waybar"
      "$mainMod, C ,exec, hyprpicker -a"
      "$mainMod, W,exec, wallpaper-picker"
      "$mainMod SHIFT, W,exec, hyprctl dispatch exec '[float; size 925 615] waypaper'"
      "$mainMod, N, exec, swaync-client -t -sw"
      "$mainMod, equal, exec, woomer"
      "$mainMod, V, exec, cliphist list | rofi -dmenu -theme-str 'window {width: 50%;} listview {columns: 1;}' | cliphist decode | wl-copy"

      # applications
      "$mainMod SHIFT, D, exec, webcord --enable-features=UseOzonePlatform --ozone-platform=wayland"
      "$mainMod SHIFT, S, exec, hyprctl dispatch exec '[workspace 5 silent] SoundWireServer'"

      # screenshots
      ",Print, exec, screenshot --copy"
      "$mainMod, Print, exec, screenshot --save"
      "$mainMod SHIFT, Print, exec, screenshot --swappy"

      # focus movement
      "$mainMod, left,  movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up,    movefocus, u"
      "$mainMod, down,  movefocus, d"
      "$mainMod, h, movefocus, l"
      "$mainMod, j, movefocus, d"
      "$mainMod, k, movefocus, u"
      "$mainMod, l, movefocus, r"

      # alter z-order (bring to front)
      "$mainMod, left,  alterzorder, top"
      "$mainMod, right, alterzorder, top"
      "$mainMod, up,    alterzorder, top"
      "$mainMod, down,  alterzorder, top"
      "$mainMod, h, alterzorder, top"
      "$mainMod, j, alterzorder, top"
      "$mainMod, k, alterzorder, top"
      "$mainMod, l, alterzorder, top"

      # focus floating/tiled windows
      "CTRL ALT, up, exec, hyprctl dispatch focuswindow floating"
      "CTRL ALT, down, exec, hyprctl dispatch focuswindow tiled"

      # workspace switching
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # move to workspace (silent)
      "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
      "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
      "$mainMod CTRL, c, movetoworkspace, empty"

      # window movement
      "$mainMod SHIFT, left, movewindow, l"
      "$mainMod SHIFT, right, movewindow, r"
      "$mainMod SHIFT, up, movewindow, u"
      "$mainMod SHIFT, down, movewindow, d"
      "$mainMod SHIFT, h, movewindow, l"
      "$mainMod SHIFT, j, movewindow, d"
      "$mainMod SHIFT, k, movewindow, u"
      "$mainMod SHIFT, l, movewindow, r"

      # window resizing
      "$mainMod CTRL, left, resizeactive, -80 0"
      "$mainMod CTRL, right, resizeactive, 80 0"
      "$mainMod CTRL, up, resizeactive, 0 -80"
      "$mainMod CTRL, down, resizeactive, 0 80"
      "$mainMod CTRL, h, resizeactive, -80 0"
      "$mainMod CTRL, j, resizeactive, 0 80"
      "$mainMod CTRL, k, resizeactive, 0 -80"
      "$mainMod CTRL, l, resizeactive, 80 0"

      # window positioning
      "$mainMod ALT, left, moveactive,  -80 0"
      "$mainMod ALT, right, moveactive, 80 0"
      "$mainMod ALT, up, moveactive, 0 -80"
      "$mainMod ALT, down, moveactive, 0 80"
      "$mainMod ALT, h, moveactive,  -80 0"
      "$mainMod ALT, j, moveactive, 0 80"
      "$mainMod ALT, k, moveactive, 0 -80"
      "$mainMod ALT, l, moveactive, 80 0"

      # media controls
      ",XF86AudioPlay,exec, playerctl play-pause"
      ",XF86AudioNext,exec, playerctl next"
      ",XF86AudioPrev,exec, playerctl previous"
      ",XF86AudioStop,exec, playerctl stop"

      # mouse workspace switching
      "$mainMod, mouse_down, workspace, e-1"
      "$mainMod, mouse_up, workspace, e+1"
    ];

    # mouse bindings
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    # Commented out binds for future use
    # # binds active in lockscreen
    # bindl = [
    #   # laptop brigthness
    #   ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
    #   ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
    #   "$mainMod, XF86MonBrightnessUp, exec, brightnessctl set 100%+"
    #   "$mainMod, XF86MonBrightnessDown, exec, brightnessctl set 100%-"
    # ];

    # # binds that repeat when held
    # binde = [
    #   ",XF86AudioRaiseVolume,exec, pamixer -i 2"
    #   ",XF86AudioLowerVolume,exec, pamixer -d 2"
    # ];
  };
}