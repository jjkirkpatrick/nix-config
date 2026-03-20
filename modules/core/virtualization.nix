# Virtualization and containerization configuration
{ pkgs, username, ... }:
{
  virtualisation = {
    spiceUSBRedirection.enable = true;
    
    libvirtd = {
      enable = true;
    };
    
    docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Keep only kvm-amd
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];

  users.users.${username}.extraGroups = [ "libvirtd" "kvm" ];
  # Virtualization and container management tools
  environment.systemPackages = with pkgs; [
    # Container orchestration
    # Docker Compose equivalent for Podman
    docker-compose
    
    # Virtual machine emulation
    # QEMU system emulator and virtualizer
    qemu
    swtpm
    OVMF
    
    # SPICE protocol components
    # Remote display system for virtual machines
    spice           # Core SPICE libraries
    spice-gtk       # GTK+ widget for SPICE clients
    spice-protocol  # SPICE protocol headers
    
    # Virtual machine management tools
    # GUI for managing libvirt virtual machines
    virt-manager
    
    # Lightweight VM viewer
    # Simple display client for virtual machines
    virt-viewer
    
    # Windows-specific virtualization tools
    win-spice      # SPICE agent for Windows guests
    virtio-win     # VirtIO drivers for Windows guests
  ];
}

