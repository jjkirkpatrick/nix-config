# Bluetooth hardware and management configuration
{ pkgs, ... }:

{
  # Bluetooth hardware configuration
  hardware.bluetooth = {
    # Enable Bluetooth support system-wide
    # Provides the underlying BlueZ Bluetooth stack
    enable = true;
    
    # Bluetooth power-on behavior
    # blue-pc is a desktop (always powered), so keep the adapter on at boot.
    # This avoids the Waybar cold-start race where a just-powered adapter has
    # not yet re-exported its stored devices, leaving the menu's paired list
    # empty and forcing a needless re-pair.
    powerOnBoot = true;

    # BlueZ daemon settings (rendered into /etc/bluetooth/main.conf)
    settings = {
      Policy = {
        # Re-enable controllers on boot/resume and let trusted devices
        # (e.g. headphones) reconnect automatically when they come online.
        AutoEnable = true;
      };
    };
  };

  # Bluetooth management applications
  environment.systemPackages = with pkgs; [
    # OverSkride - Advanced Bluetooth device manager
    # Provides detailed control over Bluetooth connections and profiles
    # Alternative to basic desktop environment Bluetooth managers
    overskride
  ];
}