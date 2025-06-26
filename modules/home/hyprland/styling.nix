{ ... }:
{
  wayland.windowManager.hyprland.settings = {
    decoration = {
      rounding = 8; # Enable rounding for Catppuccin aesthetic
      # active_opacity = 0.90;
      # inactive_opacity = 0.90;
      # fullscreen_opacity = 1.0;

      blur = {
        enabled = true;
        size = 3;
        passes = 2;
        brightness = 1;
        contrast = 1.4;
        ignore_opacity = true;
        noise = 0;
        new_optimizations = true;
        xray = true;
      };

      shadow = {
        enabled = true;
        ignore_window = true;
        offset = "0 2";
        range = 20;
        render_power = 3;
        color = "rgba(11111baa)"; # Catppuccin Mocha base shadow
      };
    };

    animations = {
      enabled = true;

      bezier = [
        "fluent_decel, 0, 0.2, 0.4, 1"
        "easeOutCirc, 0, 0.55, 0.45, 1"
        "easeOutCubic, 0.33, 1, 0.68, 1"
        "fade_curve, 0, 0.55, 0.45, 1"
      ];

      animation = [
        # name, enable, speed, curve, style

        # Windows
        "windowsIn,   0, 4, easeOutCubic,  popin 20%" # window open
        "windowsOut,  0, 4, fluent_decel,  popin 80%" # window close.
        "windowsMove, 1, 2, fluent_decel, slide" # everything in between, moving, dragging, resizing.

        # Fade
        "fadeIn,      1, 3,   fade_curve" # fade in (open) -> layers and windows
        "fadeOut,     1, 3,   fade_curve" # fade out (close) -> layers and windows
        "fadeSwitch,  0, 1,   easeOutCirc" # fade on changing activewindow and its opacity
        "fadeShadow,  1, 10,  easeOutCirc" # fade on changing activewindow for shadows
        "fadeDim,     1, 4,   fluent_decel" # the easing of the dimming of inactive windows
        # "border,      1, 2.7, easeOutCirc"  # for animating the border's color switch speed
        # "borderangle, 1, 30,  fluent_decel, once" # for animating the border's gradient angle - styles: once (default), loop
        "workspaces,  1, 4,   easeOutCubic, fade" # styles: slide, slidevert, fade, slidefade, slidefadevert
      ];
    };
  };
}