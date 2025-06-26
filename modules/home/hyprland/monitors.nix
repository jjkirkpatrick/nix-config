{ ... }:
{
  wayland.windowManager.hyprland = {
    extraConfig = ''
      monitor=DP-3,5120x1440@120.00,0x1080,1
      monitor=HDMI-A-1,prefered,760x0,1

      xwayland {
        force_zero_scaling = true
      }
    '';
  };
}