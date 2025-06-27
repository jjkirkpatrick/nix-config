# Audio hardware configuration - ALSA and USB audio interface support
{pkgs, ...}: 

{
    # Install packages for audio hardware management
    environment.systemPackages = [
        # GUI tool for managing Scarlett USB audio interfaces
        pkgs.alsa-scarlett-gui
    ];
    
    # Kernel module configuration for USB audio devices
    boot.extraModprobeConfig = ''
      # Configure Scarlett USB audio interface
      # vid=0x1235 pid=0x8212: Focusrite Scarlett device IDs
      # device_setup=1: Enable advanced features and routing
      options snd_usb_audio vid=0x1235 pid=0x8212 device_setup=1
    '';
}