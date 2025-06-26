{ lib, ... }:
let
  colors = import ./colors.nix;
  
  # Helper function to convert color to rgba with alpha
  withAlpha = color: alpha: 
    let
      # Remove # if present
      cleanColor = lib.removePrefix "#" color;
      # Convert hex to RGB values
      r = toString (lib.toInt ("0x" + (lib.substring 0 2 cleanColor)));
      g = toString (lib.toInt ("0x" + (lib.substring 2 2 cleanColor)));
      b = toString (lib.toInt ("0x" + (lib.substring 4 2 cleanColor)));
    in "rgba(${r}, ${g}, ${b}, ${alpha})";
    
  # Helper function to create gradients
  gradient = direction: colorStops:
    "linear-gradient(${direction}, ${lib.concatStringsSep ", " colorStops})";
in
{
  # Export colors for direct access
  inherit colors;
  
  # Export helper functions
  inherit withAlpha gradient;
  
  # Application-specific configurations
  kitty = import ./kitty.nix { inherit colors; };
  
  # Waybar styling (extracted from current waybar.nix)
  waybar = {
    window = {
      background = gradient "135deg" [
        (withAlpha colors.bg.primary colors.alpha.high)
        (withAlpha colors.bg.tertiary colors.alpha.medium)
        (withAlpha colors.bg.surface colors.alpha.high)
      ];
      border = withAlpha colors.border.primary colors.alpha.subtle;
      shadow = "0 0 15px ${colors.shadow.medium}";
    };
    
    workspaces = {
      background = gradient "135deg" [
        (withAlpha colors.bg.primary "0.9")
        (withAlpha colors.bg.secondary "0.8")
      ];
      border = withAlpha colors.border.primary colors.alpha.subtle;
      
      button = {
        color = colors.fg.primary;
        textShadow = "0 0 5px ${colors.shadow.small}";
      };
      
      hover = {
        background = gradient "135deg" [
          (withAlpha colors.bg.elevated colors.alpha.subtle)
          (withAlpha colors.bg.overlay "0.3")
        ];
        color = colors.fg.muted;
      };
      
      active = {
        background = gradient "135deg" [
          (withAlpha colors.bg.elevated "0.8")
          (withAlpha colors.bg.overlay "0.7")
        ];
        color = colors.fg.secondary;
        shadow = "0 0 15px ${withAlpha colors.bg.elevated colors.alpha.subtle}";
      };
    };
    
    modules = {
      background = gradient "135deg" [
        (withAlpha colors.bg.primary "0.85")
        (withAlpha colors.bg.tertiary "0.8")
      ];
      border = withAlpha colors.border.primary "0.3";
      
      cpu = {
        color = colors.accent.green;
        hoverShadow = "0 0 10px ${withAlpha colors.accent.green colors.alpha.minimal}";
      };
      
      memory = {
        color = colors.accent.orange;
        hoverShadow = "0 0 10px ${withAlpha colors.accent.orange colors.alpha.minimal}";
      };
      
      network = {
        color = colors.accent.cyan;
        hoverShadow = "0 0 10px ${withAlpha colors.accent.cyan colors.alpha.minimal}";
      };
      
      audio = {
        color = colors.accent.purple;
        hoverShadow = "0 0 10px ${withAlpha colors.accent.purple colors.alpha.minimal}";
      };
    };
    
    clock = {
      background = gradient "135deg" [
        (withAlpha colors.bg.elevated "0.9")
        (withAlpha colors.bg.overlay "0.8")
        (withAlpha colors.bg.surface "0.85")
      ];
      color = colors.fg.secondary;
      border = withAlpha colors.border.accent colors.alpha.subtle;
    };
    
    tooltip = {
      background = gradient "135deg" [
        (withAlpha colors.bg.primary "0.98")
        (withAlpha colors.bg.tertiary "0.95")
      ];
      border = withAlpha colors.border.primary colors.alpha.subtle;
      color = colors.fg.primary;
    };
  };
  
  # ZSH/Terminal colors
  zsh = {
    # Completion menu colors
    menu = {
      background = colors.bg.secondary;
      foreground = colors.fg.primary;
      selection = colors.bg.elevated;
    };
    
    # Syntax highlighting colors
    syntax = {
      comment = colors.fg.disabled;
      keyword = colors.accent.purple;
      string = colors.accent.green;
      number = colors.accent.orange;
      operator = colors.accent.cyan;
      function = colors.accent.blue;
      variable = colors.fg.primary;
    };
  };
  
  # Rofi launcher colors
  rofi = {
    background = colors.bg.primary;
    foreground = colors.fg.primary;
    selected = colors.bg.elevated;
    border = colors.border.focus;
    accent = colors.accent.cyan;
  };
}