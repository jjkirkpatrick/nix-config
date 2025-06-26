{ ... }:
{
  wayland.windowManager.hyprland = {
    extraConfig = ''
      # Primary monitor (DP-3): 5120x1440 at bottom, positioned at (0, 1080)
      monitor=DP-3,5120x1440@120.00,0x1080,1
      
      # Secondary monitor (HDMI-A-1): Stacked above DP-3, centered horizontally
      # Assuming HDMI is 1920x1080, center it above the 5120px wide DP-3
      # Horizontal center: (5120 - 1920) / 2 = 1600
      # Vertical position: 0 (top)
      monitor=HDMI-A-1,preferred,1600x0,1

      xwayland {
        force_zero_scaling = true
      }
    '';
  };
}