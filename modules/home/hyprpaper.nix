# ======================================================================
# HYPRPAPER WALLPAPER MANAGER CONFIGURATION
# ======================================================================
# Hyprpaper is the wallpaper utility for Hyprland window manager. It provides
# efficient wallpaper management with support for multiple monitors, dynamic
# wallpaper switching, and minimal resource usage.
#
# Features configured:
# - Multi-monitor wallpaper support
# - Consistent wallpaper across all displays
# - IPC interface for dynamic wallpaper changes
# - Optimized for Hyprland integration
# ======================================================================

{ pkgs, ... }:
{
  # ============================================================
  # HYPRPAPER SERVICE CONFIGURATION
  # ============================================================
  # Configure the hyprpaper service for wallpaper management
  
  services.hyprpaper = {
    enable = true;                        # Enable hyprpaper service
    
    settings = {
      # ========================================
      # Service Configuration
      # ========================================
      ipc = "on";                         # Enable IPC interface for dynamic control
                                         # Allows changing wallpapers via hyprctl
      
      splash = false;                     # Disable splash screen on startup
                                         # Provides faster, cleaner startup experience
      
      splash_offset = 2.0;               # Splash screen offset (unused when splash = false)
      
      # ========================================
      # Wallpaper Preloading
      # ========================================
      # Preload wallpapers into memory for instant switching
      # This improves performance and reduces lag when changing wallpapers
      preload = [
        "~/Pictures/wallpapers/space.png"  # Dark Space theme wallpaper
                                          # Preloading ensures immediate display
      ];
      
      # ========================================
      # Monitor Wallpaper Assignment
      # ========================================
      # Assign wallpapers to specific monitors and provide fallbacks
      wallpaper = [
        "DP-3,~/Pictures/wallpapers/space.png"      # Primary monitor (DisplayPort)
        "HDMI-A-1,~/Pictures/wallpapers/space.png"  # Secondary monitor (HDMI)
        ",~/Pictures/wallpapers/space.png"          # Fallback for any unspecified monitor
                                                    # Ensures consistent experience across setups
      ];
    };
  };

  # ============================================================
  # WALLPAPER FILE MANAGEMENT
  # ============================================================
  # Ensure wallpaper files are available in the expected location
  # This creates the necessary directory structure and copies wallpapers
  
  home.file."Pictures/wallpapers/space.png" = {
    source = ../../wallpapers/space.png;   # Source wallpaper from repository
                                          # Creates ~/Pictures/wallpapers/space.png
                                          # Ensures wallpaper is available for hyprpaper
  };

  # ============================================================
  # HYPRPAPER USAGE NOTES
  # ============================================================
  # Hyprpaper integrates seamlessly with Hyprland and provides:
  #
  # Dynamic Control:
  # - Change wallpapers via: hyprctl hyprpaper wallpaper "monitor,path"
  # - Preload new wallpapers: hyprctl hyprpaper preload "path"
  # - Unload wallpapers: hyprctl hyprpaper unload "path"
  #
  # Performance Benefits:
  # - Efficient memory usage with selective preloading
  # - GPU-accelerated rendering when possible
  # - Minimal CPU overhead during normal operation
  #
  # Multi-Monitor Support:
  # - Independent wallpapers per monitor
  # - Automatic scaling and positioning
  # - Fallback support for unknown monitors
  #
  # The Dark Space wallpaper complements the overall theme with:
  # - Deep space aesthetics matching the color scheme
  # - High contrast for better desktop element visibility
  # - Professional appearance suitable for work environments
}