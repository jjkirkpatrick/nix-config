# Core system modules - central configuration hub
{ ... }:
{
  # Import all core system configuration modules
  imports = [
    # System boot configuration and bootloader settings
    ./bootloader.nix
    # Hardware detection and basic hardware support
    ./hardware.nix
    # X11 server configuration for compatibility
    ./xserver.nix
    # Network configuration including WiFi and firewall
    ./network.nix
    # NixOS Helper (nh) tool configuration
    ./nh.nix
    # Audio hardware configuration (ALSA, USB audio interfaces)
    ./audio.nix
    # PipeWire audio server configuration
    ./pipewire.nix
    # System programs and command-line tools
    ./program.nix
    # Security settings and permissions
    ./security.nix
    # System services and daemon configuration
    ./services.nix
    # Steam gaming platform configuration
    ./steam.nix
    # Core system settings (Nix configuration, locale, timezone)
    ./system.nix
    # Flatpak application support
    ./flatpak.nix
    # User account and home-manager integration
    ./user.nix
    # Wayland compositor support (Hyprland)
    ./wayland.nix
    # Virtualization support (KVM, QEMU, containers)
    ./virtualization.nix
    # NVIDIA graphics driver configuration
    ./nvidia.nix
    # Automatic system updates configuration
    ./auto-upgrade.nix
    # Bluetooth hardware and service support
    ./bluetooth.nix
    # System-wide theming configuration
    ./theme.nix
  ];

  # Nixpkgs configuration - allow insecure packages when necessary
  nixpkgs.config = {
    # Allow specific insecure packages that are still needed
    # OpenSSL 1.1.1w is required by some packages (e.g., Steam games)
    # even though it has reached end-of-life
    permittedInsecurePackages = [
      "openssl-1.1.1w"
    ];
  };
}
