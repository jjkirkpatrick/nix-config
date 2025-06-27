# X11 server and input device configuration
{ username, ... }:
{
  services = {
    # X11 display server configuration
    xserver = {
      # Enable X11 display server
      # Required even for Wayland compositors for compatibility with some applications
      enable = true;
      
      # Keyboard layout configuration
      xkb = {
        # Set keyboard layout to UK/British
        # Change to "us" for US layout or other country codes as needed
        layout = "gb";
      };
    };

    # Input device management service
    libinput = {
      # Enable libinput for touchpad and mouse input handling
      # Provides modern input device management with better gesture support
      # Replaces the older synaptics driver
      enable = true;
    };
  };
  
  # System service timeout configuration
  # Reduce the default shutdown timeout to prevent hanging on shutdown
  # Default is 90 seconds, this reduces it to 10 seconds for faster shutdowns
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
