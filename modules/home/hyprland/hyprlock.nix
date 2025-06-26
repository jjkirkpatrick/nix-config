{
  inputs,
  pkgs,
  host,
  ...
}:
{
  programs.hyprlock = {
    enable = true;

    package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;

    settings = {
      general = {
        hide_cursor = true;
        no_fade_in = false;
        disable_loading_bar = true;
        ignore_empty_input = true;
        fractional_scaling = 0;
      };

      background = [
        {
          monitor = "";
          path = "${../../../wallpapers/space.png}";
          blur_passes = 2;
          contrast = 0.8916;
          brightness = 0.8172;
          vibrancy = 0.1696;
          vibrancy_darkness = 0.0;
        }
      ];

      shape = [
        # User box
        {
          monitor = "";
          size = "300, 50";
          color = "rgba(26, 31, 46, 0.8)";  # Dark slate with higher opacity
          rounding = 10;
          border_color = "rgba(37, 42, 56, 0.4)";  # Cosmic gray border
          position = "0, ${if host == "laptop" then "120" else "270"}";
          halign = "center";
          valign = "bottom";
        }
      ];

      label = [
        # Time
        {
          monitor = "";
          text = ''cmd[update:1000] echo "$(date +'%k:%M')"'';
          color = "rgba(248, 250, 252, 0.9)";  # Star white
          font_size = 115;
          font_family = "JetBrains Mono";
          shadow_passes = 3;
          position = "0, ${if host == "laptop" then "-25" else "-150"}";
          halign = "center";
          valign = "top";
        }
        # Date
        {
          monitor = "";
          text = ''cmd[update:1000] echo "- $(date +'%A, %B %d') -" '';
          color = "rgba(248, 250, 252, 0.9)";  # Star white
          font_size = 18;
          font_family = "JetBrains Mono";
          shadow_passes = 3;
          position = "0, ${if host == "laptop" then "-225" else "-350"}";
          halign = "center";
          valign = "top";
        }
        # Username
        {
          monitor = "";
          text = "  $USER";
          color = "rgba(248, 250, 252, 1)";  # Star white
          font_size = 15;
          font_family = "JetBrains Mono";
          position = "0, ${if host == "laptop" then "131" else "281"}";
          halign = "center";
          valign = "bottom";
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "300, 50";
          outline_thickness = 1;
          rounding = 10;
          dots_size = 0.25;
          dots_spacing = 0.4;
          dots_center = true;
          outer_color = "rgba(26, 31, 46, 0.8)";  # Dark slate
          inner_color = "rgba(15, 20, 30, 0.9)";  # Void black
          color = "rgba(248, 250, 252, 0.9)";  # Star white
          font_color = "rgba(248, 250, 252, 0.9)";  # Star white
          font_size = 14;
          font_family = "JetBrains Mono";
          fade_on_empty = false;
          placeholder_text = ''<i><span foreground="#A0A8B8">Enter Password</span></i>'';  # Muted gray
          hide_input = false;
          position = "0, ${if host == "laptop" then "50" else "200"}";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };
}
