# NixOS Configuration Theming System

This document explains how to implement a central theming system for your NixOS configuration, allowing you to maintain consistent colors and styling across all applications (Waybar, Kitty, ZSH, Rofi, etc.).

## Current State Analysis

### Waybar (Dark Space Theme)
- **Current**: Custom dark space theme with consistent gradients
- **Colors**: Deep space blacks (#0B0D17), dark grays (#1A1F2E), subtle accents
- **Style**: Professional, minimal, space-inspired

### Kitty Terminal
- **Current**: Catppuccin Mocha theme 
- **Colors**: Purple-based (#1E1E2E background, #CDD6F4 foreground)
- **Style**: Colorful, high contrast

### ZSH/Powerlevel10k
- **Current**: Default Powerlevel10k styling
- **Colors**: Varies based on terminal theme
- **Style**: Depends on .p10k.zsh configuration

## Proposed Solution: Central Theming System

### 1. Theme Folder Structure

```
modules/home/themes/
├── default.nix          # Theme selector and exports
├── dark-space/          # Your custom dark space theme
│   ├── default.nix      # Main theme definition
│   ├── colors.nix       # Color palette definitions
│   ├── waybar.nix       # Waybar-specific styling
│   ├── kitty.nix        # Kitty-specific colors
│   ├── zsh.nix          # ZSH/shell theming
│   └── rofi.nix         # Rofi launcher styling
├── catppuccin/          # Alternative theme (if desired)
│   └── ...
└── README.md            # Theme documentation
```

### 2. Theme Implementation

#### A. Core Theme Definition (`themes/dark-space/colors.nix`)

```nix
{
  # Primary backgrounds (darkest to lighter)
  bg = {
    primary = "#0B0D17";      # Deep space
    secondary = "#0F141E";    # Void black  
    tertiary = "#131820";     # Shadow gray
    surface = "#1A1F2E";      # Dark slate
    elevated = "#252A38";     # Cosmic gray
  };

  # Foreground colors
  fg = {
    primary = "#F8FAFC";      # Star white
    secondary = "#E2E8F0";    # Slate blue
    muted = "#A0A8B8";        # Muted gray
    disabled = "#64748B";     # Disabled gray
  };

  # Accent colors
  accent = {
    green = "#10B981";        # Success/CPU
    orange = "#F97316";       # Warning/Memory
    cyan = "#06B6D4";         # Info/Network
    purple = "#8B5CF6";       # Audio/Special
    red = "#EF4444";          # Error/Critical
    yellow = "#F59E0B";       # Warning/Alt
  };

  # Transparency levels
  alpha = {
    high = "0.95";
    medium = "0.85";
    low = "0.7";
    subtle = "0.4";
    minimal = "0.2";
  };
}
```

#### B. Application-Specific Themes

**Waybar Theme (`themes/dark-space/waybar.nix`)**
```nix
{ colors }:
{
  window = {
    background = "linear-gradient(135deg, rgba(11,13,23,0.98), rgba(20,25,35,0.96))";
    border = "rgba(25,30,40,0.4)";
  };
  
  workspaces = {
    background = "linear-gradient(135deg, rgba(11,13,23,0.9), rgba(15,18,25,0.8))";
    active = "linear-gradient(135deg, rgba(35,40,55,0.8), rgba(40,45,60,0.7))";
    hover = "linear-gradient(135deg, rgba(25,30,40,0.4), rgba(30,35,45,0.3))";
  };
  
  modules = {
    cpu.color = colors.accent.green;
    memory.color = colors.accent.orange;
    network.color = colors.accent.cyan;
    audio.color = colors.accent.purple;
  };
}
```

**Kitty Theme (`themes/dark-space/kitty.nix`)**
```nix
{ colors }:
{
  foreground = colors.fg.primary;
  background = colors.bg.primary;
  selection_foreground = colors.bg.primary;
  selection_background = colors.fg.secondary;
  
  cursor = colors.fg.secondary;
  cursor_text_color = colors.bg.primary;
  
  # Terminal colors matching space theme
  color0 = colors.bg.surface;      # black
  color8 = colors.fg.disabled;     # bright black
  color1 = colors.accent.red;      # red
  color9 = colors.accent.red;      # bright red
  color2 = colors.accent.green;    # green
  color10 = colors.accent.green;   # bright green
  color3 = colors.accent.yellow;   # yellow
  color11 = colors.accent.yellow;  # bright yellow
  color4 = colors.accent.cyan;     # blue
  color12 = colors.accent.cyan;    # bright blue
  color5 = colors.accent.purple;   # magenta
  color13 = colors.accent.purple;  # bright magenta
  color6 = colors.accent.cyan;     # cyan
  color14 = colors.accent.cyan;    # bright cyan
  color7 = colors.fg.secondary;    # white
  color15 = colors.fg.primary;     # bright white
  
  # Tab styling
  active_tab_foreground = colors.fg.primary;
  active_tab_background = colors.bg.elevated;
  inactive_tab_foreground = colors.fg.muted;
  inactive_tab_background = colors.bg.secondary;
  tab_bar_background = colors.bg.primary;
}
```

### 3. Implementation Steps

#### Step 1: Create Theme Structure
```bash
mkdir -p modules/home/themes/dark-space
```

#### Step 2: Create Theme Selector (`themes/default.nix`)
```nix
{ pkgs, lib, ... }:
let
  # Current active theme
  currentTheme = "dark-space";
  
  # Import theme
  theme = import ./${currentTheme};
in
{
  # Export theme for other modules to use
  _module.args.theme = theme;
  
  # Auto-import theme-specific configurations
  imports = [
    ./${currentTheme}
  ];
}
```

#### Step 3: Update Application Configurations

**Update `modules/home/kitty.nix`:**
```nix
{ pkgs, theme, ... }:
{
  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    
    font = {
      name = "JetBrains Mono Nerd Font";
      size = 14;
    };
    
    settings = theme.kitty // {
      # Non-color settings
      window_padding_width = 12;
      hide_window_decorations = "yes";
      # ... other settings
    };
    
    # ... keybindings stay the same
  };
}
```

**Update `modules/home/waybar.nix`:**
```nix
{ pkgs, theme, ... }:
{
  programs.waybar = {
    enable = true;
    
    settings = {
      # ... waybar config stays same
    };
    
    style = theme.waybar.generateCSS;
  };
}
```

#### Step 4: Update Main Configuration

**Update `modules/home/default.nix`:**
```nix
{username, inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./themes                          # Add theme system
    ./hyprland                        # window manager
    ./packages                        # CLI and GUI packages
    ./fonts.nix                       # font configuration
    ./kitty.nix                       # terminal
    ./hyprpaper.nix                   # wallpaper manager
    ./waybar.nix                      # status bar
    ./rofi.nix                        # launcher
    ./brave.nix
    ./p10k/p10k.nix
    ./zsh                            # shell configuration
  ];
  
  # ... rest of config
}
```

### 4. Usage Workflow

#### Switching Themes
1. Edit `themes/default.nix` and change `currentTheme` variable
2. Run `home-manager switch`
3. All applications automatically use new theme

#### Creating New Themes
1. Copy `themes/dark-space/` to `themes/new-theme/`
2. Modify color values in `colors.nix`
3. Adjust application-specific files as needed
4. Update theme selector

#### Customizing Existing Theme
1. Edit values in `themes/dark-space/colors.nix`
2. Run `home-manager switch`
3. Changes apply across all applications

### 5. Benefits

- **Consistency**: All applications share the same color palette
- **Maintainability**: Change colors in one place, applies everywhere
- **Flexibility**: Easy to create and switch between themes
- **Modularity**: Each application's theming is isolated but consistent
- **Version Control**: Themes are tracked in your NixOS config

### 6. Advanced Features

#### Theme Variants
```nix
# In colors.nix
variants = {
  dark = { /* dark colors */ };
  light = { /* light colors */ };
  auto = { /* system-dependent */ };
};
```

#### Dynamic Color Generation
```nix
# Generate accent variations
accent = {
  primary = "#06B6D4";
  light = lib.colors.lighten accent.primary 0.2;
  dark = lib.colors.darken accent.primary 0.2;
};
```

#### Application Detection
```nix
# Only apply theme if application is enabled
config = lib.mkIf config.programs.kitty.enable {
  programs.kitty.settings = theme.kitty;
};
```

This system provides a scalable, maintainable way to manage themes across your entire NixOS configuration while keeping the flexibility to customize individual applications when needed.