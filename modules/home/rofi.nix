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

  # Dark Space Theme
  xdg.configFile."rofi/config.rasi".text = ''
    /* Dark Space Theme Color Palette:
     * Deep Space: #0B0D17 (primary background)
     * Void Black: #0F141E (secondary background)
     * Shadow Gray: #131820 (tertiary background)
     * Dark Slate: #1A1F2E (elements background)
     * Cosmic Gray: #252A38 (hover states)
     * Star White: #F8FAFC (primary text)
     * Slate Blue: #E2E8F0 (secondary text)
     * Accent colors: #10B981 (green), #F97316 (orange), #06B6D4 (cyan), #8B5CF6 (purple)
     */

    * {
      bg-col: #0B0D17;
      bg-col-light: #1A1F2E;
      border-col: #252A38;
      selected-col: #252A38;
      blue: #8B5CF6;
      fg-col: #F8FAFC;
      fg-col2: #E2E8F0;
      grey: #64748B;
      
      width: 450;
      font: "JetBrains Mono Nerd Font 14";
    }

    element-text, element-icon, mode-switcher {
      background-color: inherit;
      text-color: inherit;
    }

    window {
      height: 520px;
      border: 2px;
      border-color: @border-col;
      border-radius: 16px;
      background-color: @bg-col;
      box-shadow: 0 8px 32px #0B0D1799;
    }

    mainbox {
      background-color: @bg-col;
      border-radius: 16px;
      padding: 20px;
    }

    inputbar {
      children: [prompt, entry];
      background-color: @bg-col-light;
      border-radius: 12px;
      padding: 2px;
      border: 1px;
      border-color: @border-col;
      margin: 0px 0px 20px 0px;
    }

    prompt {
      background-color: @blue;
      padding: 8px 12px;
      text-color: @bg-col;
      border-radius: 10px;
      margin: 0px;
      font-weight: bold;
    }

    textbox-prompt-colon {
      expand: false;
      str: ":";
    }

    entry {
      padding: 8px 12px;
      margin: 0px;
      text-color: @fg-col;
      background-color: transparent;
      border-radius: 10px;
      placeholder: "Search...";
      placeholder-color: @grey;
    }

    listview {
      border: 0px;
      padding: 6px 0px 0px;
      margin: 10px 0px 0px 0px;
      columns: 1;
      lines: 8;
      background-color: @bg-col;
      cycle: true;
      dynamic: true;
      layout: vertical;
    }

    element {
      padding: 8px 12px;
      margin: 0px 0px 4px 0px;
      border-radius: 10px;
      background-color: transparent;
      text-color: @fg-col2;
      transition: all 0.3s ease;
    }

    element-icon {
      size: 24px;
      margin: 0px 8px 0px 0px;
    }

    element.selected {
      background-color: @selected-col;
      text-color: @fg-col;
      border: 1px;
      border-color: @blue;
      box-shadow: 0 4px 12px #8B5CF633;
    }

    element.selected.active {
      background-color: @blue;
      text-color: @bg-col;
    }

    mode-switcher {
      spacing: 0;
      background-color: @bg-col-light;
      border-radius: 12px;
      border: 1px;
      border-color: @border-col;
      margin: 20px 0px 0px 0px;
    }

    button {
      padding: 10px 16px;
      border-radius: 10px;
      background-color: transparent;
      text-color: @grey;
      vertical-align: 0.5;
      horizontal-align: 0.5;
      transition: all 0.3s ease;
    }

    button.selected {
      background-color: @blue;
      text-color: @bg-col;
      font-weight: bold;
      box-shadow: 0 4px 12px #8B5CF64D;
    }

    button:hover {
      background-color: @border-col;
      text-color: @fg-col;
    }

    scrollbar {
      width: 4px;
      border: 0;
      handle-color: @blue;
      handle-width: 8px;
      padding: 0;
    }

    message {
      background-color: @bg-col-light;
      border: 1px;
      border-color: @border-col;
      border-radius: 12px;
      padding: 12px;
      margin: 20px 0px 0px 0px;
    }

    textbox {
      text-color: @fg-col;
      background-color: transparent;
      vertical-align: 0.5;
      horizontal-align: 0.0;
    }

    error-message {
      background-color: #F97316;
      border: 2px;
      border-color: #F97316;
      border-radius: 12px;
      padding: 12px;
      color: @bg-col;
    }
  '';

}
