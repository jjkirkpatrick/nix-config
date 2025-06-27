let configDir = ../config;
in
{
  home.file = {
      ".config/waybar".source = "${configDir}/waybar";
      ".config/btop".source = "${configDir}/btop";
      ".config/kitty".source = "${configDir}/kitty";
      ".config/wofi".source = "${configDir}/wofi";
      ".config/mako".source = "${configDir}/mako";
      ".config/swayidle".source = "${configDir}/swayidle";
      ".config/swaylock".source = "${configDir}/swaylock";
      ".config/wlogout".source = "${configDir}/wlogout";
      ".config/wallpapers".source = "${configDir}/wallpapers";
  };
}