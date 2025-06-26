{ colors }:
{
  # Basic colors
  foreground = colors.fg.primary;
  background = colors.bg.primary;
  selection_foreground = colors.bg.primary;
  selection_background = colors.fg.secondary;
  
  # Cursor
  cursor = colors.fg.secondary;
  cursor_text_color = colors.bg.primary;
  
  # URL colors
  url_color = colors.accent.cyan;
  
  # Border colors
  active_border_color = colors.accent.cyan;
  inactive_border_color = colors.border.secondary;
  bell_border_color = colors.accent.yellow;
  
  # Tab bar colors
  active_tab_foreground = colors.fg.primary;
  active_tab_background = colors.bg.elevated;
  inactive_tab_foreground = colors.fg.muted;
  inactive_tab_background = colors.bg.secondary;
  tab_bar_background = colors.bg.primary;
  
  # The 16 terminal colors - Dark Space theme
  color0 = colors.bg.surface;      # black
  color8 = colors.fg.disabled;     # bright black (gray)
  
  color1 = colors.accent.red;      # red
  color9 = colors.accent.red;      # bright red
  
  color2 = colors.accent.green;    # green
  color10 = colors.accent.green;   # bright green
  
  color3 = colors.accent.yellow;   # yellow
  color11 = colors.accent.yellow;  # bright yellow
  
  color4 = colors.accent.blue;     # blue
  color12 = colors.accent.cyan;    # bright blue (cyan variant)
  
  color5 = colors.accent.purple;   # magenta
  color13 = colors.accent.pink;    # bright magenta (pink variant)
  
  color6 = colors.accent.cyan;     # cyan
  color14 = colors.accent.cyan;    # bright cyan
  
  color7 = colors.fg.secondary;    # white
  color15 = colors.fg.primary;     # bright white
}