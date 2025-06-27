{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # System tools
    ripgrep                  # better grep
    fd                       # better find
    eza                      # better ls
    bat                      # better cat
    fzf                      # fuzzy finder
    zoxide                   # better cd
    btop                     # better top
    htop                     # system monitor
    tree                     # directory tree
    du-dust                  # better du
    duf                      # better df
    
    # File management
    file                     # file type detection
    unzip                    # archive extraction
    zip                      # archive creation
    p7zip                    # 7-zip support
    rsync                    # file synchronization
    
    # Network tools
    wget                     # download tool
    curl                     # HTTP client
    nmap                     # network scanner
    bandwhich                # network utilization
    
    # Development tools
    git                      # version control
    gh                       # GitHub CLI
    jq                       # JSON processor
    yq                       # YAML processor
    delta                    # better git diff
    lazygit                  # git TUI
    claude-code
    
    # Text processing
    gnused                   # stream editor
    gawk                     # text processing
    
    # System monitoring
    lsof                     # list open files
    pstree                   # process tree
    killall                  # process killer
    btop    


    # Terminal utilities
    tmux                     # terminal multiplexer
    direnv                   # environment management
    starship                 # shell prompt
    
    # Archive tools
    gnutar                   # tar archiver
    gzip                     # compression
    
    # Password management
    pass                     # password store
    
    # Media tools
    ffmpeg                   # video/audio processing
    imagemagick              # image processing
    
    # Misc utilities
    neofetch                 # system info
    fastfetch                # faster system info
    hyperfine                # command benchmarking
    
    # GUI/Wayland packages
    hyprpaper                # wallpaper utility
    kitty                    # terminal emulator
    libnotify                # notification library
    mako                     # notification daemon
    qt5.qtwayland            # Qt5 Wayland support
    qt6.qtwayland            # Qt6 Wayland support
    swayidle                 # idle management
    swaylock-effects         # screen locker
    wlogout                  # logout menu
    wl-clipboard             # clipboard utilities
    wofi                     # application launcher
    waybar                   # status bar
  ];
}



