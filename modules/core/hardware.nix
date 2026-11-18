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
      
      # VA-API on NVIDIA (NVDEC-backed) for browsers/mpv hardware decoding.
      # This is an AMD CPU (no iGPU) + NVIDIA box, so no Intel drivers.
      extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    };
  };
  
  # Point libva at the NVIDIA (NVDEC) backend; the direct backend is the
  # only one that works with the current driver.
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };

  # Enable proprietary firmware for hardware devices
  # Required for many WiFi cards, Bluetooth adapters, and other hardware
  # This includes firmware that's not open source but necessary for functionality
  hardware.enableRedistributableFirmware = true;
}
