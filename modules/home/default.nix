{username, inputs, ... }:
{
  imports = [
    inputs.catppuccin.homeModules.catppuccin
    ./config.nix                      # configuration files
    ./packages                        # CLI and GUI packages
    ./fonts.nix                       # font configuration
    ./development.nix                 # programming languages and dev tools
    # ./kitty.nix                       # terminal
    # ./hyprpaper.nix                   # wallpaper manager
    # ./waybar.nix                      # status bar
    # ./rofi.nix                        # launcher
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

