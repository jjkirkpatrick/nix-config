{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Web browsers
    brave                    # privacy-focused browser
    
    # Media players
    vlc                      # versatile media player
    mpv                      # minimal media player
    
    # File managers
    nemo                     # file manager
    
    # Image viewers/editors
    viewnior                 # image viewer
    
    # Office/productivity
    libreoffice              # office suite
    #obsidian                 # note-taking
    
    # Communication
    discord                  # chat platform
    
    # Development
    vscodium                 # code editor
    code-cursor 

    # System utilities
    pavucontrol              # audio control
    pamixer                  # audio control CLI
    blueman                  # bluetooth manager
    playerctl                # media player control
    gammastep                # blue light filter
    jq                       # JSON processor for scripts
    jaq                      # rust JSON processor (faster jq alternative)
    socat                    # socket cat utility
    networkmanager           # network management
    
    # Archive managers
    file-roller              # archive manager
    
    # PDF viewers
    evince                   # document viewer
    
    # Gaming (commented out as steam is handled separately)
    #steam
    runelite
    
    # Screenshots
    grim                     # screenshot tool
    slurp                    # screen area selection
    swappy                   # screenshot annotation
    
    # Clipboard
    wl-clipboard             # wayland clipboard utilities
    cliphist                 # clipboard manager
    
    # Font tools
    font-manager             # font management
    
    # System monitoring
    mission-center           # system monitor GUI
    
    # Widget system
    waybar                   # wayland status bar
    streamdeck-ui            # streamdeck
    
    # Terminal emulators (alternatives)
    # alacritty              # alternative terminal
    # wezterm                # alternative terminal
     
    # music 
    termusic
    spotify
    spotifyd


    # Misc utilities
    zenity                   # dialog boxes
    
    # Gaming utilities
    gamemode                 # gaming optimizations
    
    # Virtualization GUIs
    virt-manager             # VM management
    
    # Password client
    bitwarden-desktop         # bitwarden client
    
    # Cursor themes
    rose-pine-hyprcursor      # rose pine cursor theme

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
