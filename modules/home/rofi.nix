{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    
    font = "JetBrains Mono 16";
    terminal = "kitty";
    theme = ./themes/dark-space/rofi.rasi;
    
    extraConfig = {
      modi = "run,drun,window";
      lines = 5;
      cycle = false;
      show-icons = true;
      icon-theme = "Papirus-dark";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = true;
      hide-scrollbar = true;
      display-drun = " Apps ";
      display-run = " Run ";
      display-window = " Window ";
      sidebar-mode = true;
      sorting-method = "fzf";
    };
  };

}
