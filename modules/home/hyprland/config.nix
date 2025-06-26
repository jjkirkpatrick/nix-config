{ ... }:
{
  # Import all the modular configurations
  imports = [
    ./autostart.nix
    ./general.nix
    ./input.nix
    ./keybinds.nix
    ./monitors.nix
    ./styling.nix
    ./window-rules.nix
  ];
}