# Bluetooth hardware and management configuration
{ pkgs, ... }:

{
  # Bluetooth hardware configuration
  hardware.bluetooth = {
    # Enable Bluetooth support system-wide
    # Provides the underlying BlueZ Bluetooth stack
    enable = true;
    
    # Bluetooth power-on behavior
    # Set to false to prevent Bluetooth from auto-starting on boot
    # Useful for battery conservation on laptops
    powerOnBoot = false;
  };

  # Bluetooth management applications
  environment.systemPackages = with pkgs; [
    # OverSkride - Advanced Bluetooth device manager
    # Provides detailed control over Bluetooth connections and profiles
    # Alternative to basic desktop environment Bluetooth managers
    overskride
  ];
}