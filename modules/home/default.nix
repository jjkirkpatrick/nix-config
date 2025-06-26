{username, inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./hyprland                        # window manager
    ./packages                        # CLI and GUI packages
    ./fonts.nix                       # font configuration
    ./kitty.nix                       # terminal
    ./hyprpaper.nix                   # wallpaper manager
    ./waybar.nix                      # status bar
    ./rofi.nix                        # launcher
    ./wlogout.nix                     # logout menu
    ./brave.nix
    ./p10k/p10k.nix
    ./zsh                            # shell configuration
  ];

  # Required home-manager options
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}

