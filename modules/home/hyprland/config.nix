{ ... }:
{
  # Import all the modular configurations
  imports = [
    ./autostart.nix
    ./catppuccin.nix
    ./general.nix
    ./input.nix
    ./keybinds.nix
    ./monitors.nix
    ./styling.nix
    ./window-rules.nix
  ];
}