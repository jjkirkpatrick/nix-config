{ pkgs, ... }:
{
  programs.zsh.shellAliases = {
    # Better defaults
    l = "eza --icons  -a --group-directories-first -1"; # EZA_ICON_SPACING=2
    ll = "eza --icons  -a --group-directories-first -1 --no-user --long";
    tree = "eza --icons --tree --group-directories-first";
    cat = "bat";
    grep = "rg";
    find = "fd";

    # Git shortcuts
    g = "git";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    gl = "git pull";
    gs = "git status";
    gd = "git diff";
    
    # System shortcuts
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#blue-pc";
    home-rebuild = "home-manager switch --flake ~/nixos-config#josh";
    
    #Nix Development

    cdnix = "cd ~/nixos-config && codium ~/nixos-config";

    # Directory navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    
    # Misc
    h = "history";
    c = "clear";
    q = "exit";
  };
}