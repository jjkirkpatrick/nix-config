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
    blueman                  # bluetooth manager
    
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
    
    # Terminal emulators (alternatives)
    # alacritty              # alternative terminal
    # wezterm                # alternative terminal
    
    # Misc utilities
    zenity                   # dialog boxes
    
    # Gaming utilities
    gamemode                 # gaming optimizations
    
    # Virtualization GUIs
    virt-manager             # VM management
    
    # Password client
    bitwarden-desktop         # bitwarden client
 
 ];
}
