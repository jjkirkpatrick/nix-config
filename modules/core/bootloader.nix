# System bootloader configuration - systemd-boot UEFI setup
{ pkgs, ... }:
{
  # Boot loader configuration
  boot.loader = {
    # Enable systemd-boot as the primary boot loader
    # systemd-boot is the modern UEFI boot loader that's simpler than GRUB
    systemd-boot.enable = true;
    
    # Allow NixOS to modify EFI variables for boot entries
    # Required for systemd-boot to manage boot entries automatically
    efi.canTouchEfiVariables = true;
    
    # Limit the number of boot configurations kept in boot menu
    # Prevents /boot partition from filling up with old configurations
    # Keeps the 10 most recent system generations
    systemd-boot.configurationLimit = 10;
  };
  
  # Alternative kernel packages (commented out)
  # Zen kernel provides better desktop performance and responsiveness
  #boot.kernelPackages = pkgs.linuxPackages_zen;
  
  # Disable USB autosuspend to prevent KVM switches from leaving ports in a
  # suspended state — without this, switching the KVM away causes Linux to
  # suspend the USB ports, and they fail to re-enumerate when switching back.
  boot.kernelParams = [ "usbcore.autosuspend=-1" ];

  # Filesystem support
  # Enable NTFS support for reading Windows partitions
  # Useful for dual-boot systems or external drives
  boot.supportedFilesystems = [ "ntfs" ];
}
