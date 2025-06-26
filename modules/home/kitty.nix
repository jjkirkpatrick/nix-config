{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    
    font = {
      name = "JetBrains Mono Nerd Font";
      size = 14;
    };
    
    settings = {
      # Theme - Catppuccin Mocha
      foreground = "#CDD6F4";
      background = "#1E1E2E";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";
      
      # Cursor
      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";
      
      # URL underline color when hovering
      url_color = "#F5E0DC";
      
      # Kitty window border colors
      active_border_color = "#B4BEFE";
      inactive_border_color = "#6C7086";
      bell_border_color = "#F9E2AF";
      
      # Tab bar colors
      active_tab_foreground = "#11111B";
      active_tab_background = "#CBA6F7";
      inactive_tab_foreground = "#CDD6F4";
      inactive_tab_background = "#181825";
      tab_bar_background = "#11111B";
      
      # The 16 terminal colors - Catppuccin Mocha
      color0 = "#45475A";   # black
      color8 = "#585B70";
      color1 = "#F38BA8";   # red
      color9 = "#F38BA8";
      color2 = "#A6E3A1";   # green
      color10 = "#A6E3A1";
      color3 = "#F9E2AF";   # yellow
      color11 = "#F9E2AF";
      color4 = "#89B4FA";   # blue
      color12 = "#89B4FA";
      color5 = "#F5C2E7";   # magenta
      color13 = "#F5C2E7";
      color6 = "#94E2D5";   # cyan
      color14 = "#94E2D5";
      color7 = "#BAC2DE";   # white
      color15 = "#A6ADC8";
      
      # Window settings
      window_padding_width = 12;
      hide_window_decorations = "yes";
      confirm_os_window_close = 0;
      
      # Tab settings
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      
      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = "yes";
      
      # Scrollback
      scrollback_lines = 10000;
      
      # Mouse
      mouse_hide_wait = 3.0;
      url_style = "curly";
      
      # Bell
      enable_audio_bell = "no";
      visual_bell_duration = 0.0;
      
      # Advanced
      shell_integration = "enabled";
      shell = "zsh";
      
      # Clipboard
      copy_on_select = "clipboard";
      strip_trailing_spaces = "smart";
      
      # Background transparency (let Hyprland handle transparency)
      background_opacity = 1.0;
      dynamic_background_opacity = "yes";
      
      # Text rendering
      disable_ligatures = "never";
    };
    
    keybindings = {
      # Tab management
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+w" = "close_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      
      # Window management
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+n" = "new_os_window";
      
      # Font size
      "ctrl+plus" = "increase_font_size";
      "ctrl+equal" = "increase_font_size";
      "ctrl+minus" = "decrease_font_size";
      "ctrl+0" = "restore_font_size";
      
      # Copy/Paste
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      
      # URL hints
      "ctrl+shift+e" = "open_url_with_hints";
      
      # Search
      "ctrl+shift+f" = "show_scrollback";
    };
  };
}
