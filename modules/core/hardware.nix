# Hardware graphics and multimedia acceleration configuration
{ inputs, pkgs, ... }:
let
  # Use Mesa packages from Hyprland's nixpkgs input for compatibility
  # This ensures graphics drivers are compatible with Hyprland compositor
  hyprland-pkgs =
    inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  hardware = {
    # Graphics and video acceleration configuration
    graphics = {
      # Enable hardware-accelerated graphics support
      enable = true;
      
      # Use Mesa graphics drivers from Hyprland's package set
      # Ensures compatibility with Hyprland's rendering requirements
      package = hyprland-pkgs.mesa;
      
      # Additional packages for video acceleration and codec support
      extraPackages = with pkgs; [
        # Intel media driver for modern Intel GPUs (Broadwell and newer)
        intel-media-driver
        
        # Intel VAAPI driver with hybrid codec support
        # Enables hardware-accelerated video decode/encode for Intel graphics
        (vaapiIntel.override { enableHybridCodec = true; })
        
        # VAAPI driver for VDPAU backend
        # Provides video acceleration compatibility layer
        vaapiVdpau
        
        # VDPAU driver for VA-GL backend
        # Another compatibility layer for video acceleration
        libvdpau-va-gl
      ];
    };
  };
  
  # Enable proprietary firmware for hardware devices
  # Required for many WiFi cards, Bluetooth adapters, and other hardware
  # This includes firmware that's not open source but necessary for functionality
  hardware.enableRedistributableFirmware = true;
}
