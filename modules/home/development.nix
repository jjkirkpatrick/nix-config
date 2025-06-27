{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.requests

    # Node.js and JavaScript
    nodejs
    yarn

    # Rust
    rustc
    cargo
    rustfmt
    clippy

    # Go
    go

    # C/C++
    gcc
    gdb
    valgrind
    cmake

    # General development tools
    git
    curl
    wget
    jq
    tree
    htop
    neofetch
    unzip
    zip

    # Text editors and IDEs
    vim
    neovim

    # Docker and containers
    docker
    docker-compose

    # Database tools
    sqlite
    
    # Version control
    gh # GitHub CLI
  ];

  # Configure Git (if not already configured elsewhere)
  programs.git = {
    enable = true;
    userName = "jjkirkpatrick";
    userEmail = "joshkirkpatrick12@gmail.com"; # Update with actual email
  };

}