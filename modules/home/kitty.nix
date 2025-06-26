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
      # Theme - Dark Space
      foreground = "#F8FAFC";           # Star white
      background = "#0B0D17";           # Deep space
      selection_foreground = "#0B0D17"; # Deep space
      selection_background = "#E2E8F0"; # Slate blue
      
      # Cursor
      cursor = "#E2E8F0";               # Slate blue
      cursor_text_color = "#0B0D17";    # Deep space
      
      # URL underline color when hovering
      url_color = "#06B6D4";            # Cyan accent
      
      # Kitty window border colors
      active_border_color = "#8B5CF6";  # Purple accent
      inactive_border_color = "#252A38"; # Cosmic gray
      bell_border_color = "#F97316";    # Orange accent
      
      # Tab bar colors
      active_tab_foreground = "#F8FAFC"; # Star white
      active_tab_background = "#252A38"; # Cosmic gray
      inactive_tab_foreground = "#A0A8B8"; # Muted gray
      inactive_tab_background = "#0F141E"; # Void black
      tab_bar_background = "#0B0D17";   # Deep space
      
      # The 16 terminal colors - Dark Space Theme
      color0 = "#1A1F2E";   # black (dark slate)
      color8 = "#64748B";   # bright black (disabled gray)
      color1 = "#EF4444";   # red
      color9 = "#EF4444";   # bright red
      color2 = "#10B981";   # green
      color10 = "#10B981";  # bright green
      color3 = "#F59E0B";   # yellow
      color11 = "#F59E0B";  # bright yellow
      color4 = "#06B6D4";   # blue (cyan)
      color12 = "#06B6D4";  # bright blue (cyan)
      color5 = "#8B5CF6";   # magenta (purple)
      color13 = "#8B5CF6";  # bright magenta (purple)
      color6 = "#06B6D4";   # cyan
      color14 = "#06B6D4";  # bright cyan
      color7 = "#E2E8F0";   # white (slate blue)
      color15 = "#F8FAFC";  # bright white (star white)
      
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
