{ pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    
    font = "JetBrains Mono 16";
    terminal = "kitty";
    
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

  # Custom theme overrides (Catppuccin will handle the base theme)
  xdg.configFile."rofi/theme-overrides.rasi".text = ''
    window {
      height: 530px;
      width: 400px;
      border: 2px;
      border-radius: 8px;
    }

    inputbar {
      border-radius: 8px;
      padding: 0px;
    }

    prompt {
      padding: 4px;
      border-radius: 6px;
      margin: 10px 0px 10px 10px;
    }

    entry {
      padding: 6px;
      margin: 10px 10px 10px 5px;
      border-radius: 6px;
    }

    listview {
      border: 0px 0px 0px;
      padding: 6px 0px 0px;
      margin: 10px 0px 0px 6px;
      columns: 1;
      cycle = true;
    }

    element {
      padding: 8px;
      margin: 0px 10px 4px 4px;
      border-radius: 6px;
    }

    element-icon {
      size: 28px;
    }

    button {
      padding: 10px;
      vertical-align: 0.5;
      horizontal-align: 0.5;
      border-radius: 6px;
    }
  '';

}
