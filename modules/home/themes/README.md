# Themes Directory

This directory contains the central theming system for the NixOS configuration.

## Structure

```
themes/
├── default.nix          # Theme selector - change currentTheme here
├── dark-space/          # Dark space theme
│   ├── default.nix      # Main theme definition and exports
│   ├── colors.nix       # Color palette
│   └── kitty.nix        # Kitty terminal colors
└── README.md            # This file
```

## Usage

### Switching Themes

1. Edit `default.nix` in this directory
2. Change the `currentTheme` variable to your desired theme name
3. Run `home-manager switch`

### Available Themes

- **dark-space**: Deep space inspired theme with dark backgrounds and cosmic accents

### Creating New Themes

1. Copy the `dark-space` directory to a new name (e.g., `my-theme`)
2. Edit `colors.nix` to define your color palette
3. Modify application-specific files as needed
4. Update `default.nix` to use your new theme

### Using Themes in Modules

Themes are automatically available as the `theme` argument in any module:

```nix
{ pkgs, theme, ... }:
{
  programs.kitty.settings = theme.kitty;
}
```

### Color System

Each theme provides:

- `colors.*` - Direct color access
- `theme.kitty` - Kitty terminal colors
- `theme.waybar.*` - Waybar styling components  
- `theme.zsh.*` - ZSH/shell colors
- `theme.rofi.*` - Rofi launcher colors
- Helper functions like `withAlpha` and `gradient`

## Implementation Status

- ✅ Color palette definition
- ✅ Kitty terminal integration ready
- ✅ Waybar components defined
- ⏳ ZSH integration (planned)
- ⏳ Rofi integration (planned)
- ⏳ Module updates needed

See `THEMING.md` in the root directory for full implementation details.