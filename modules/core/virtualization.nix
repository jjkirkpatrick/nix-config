# Virtualization and containerization configuration
{ pkgs, ... }: 

# Remove this line:
# kvmgt.enable = true;
{
  virtualisation = {
    spiceUSBRedirection.enable = true;
    
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;  # Add this line
        runAsRoot = false;        # Add this line
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings = {
        dns_enabled = true;
      };
    };
  };

  # Keep only kvm-amd
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];

# Add user to groups
users.users.josh.extraGroups = [ "libvirtd" "kvm" ];
  # Virtualization and container management tools
  environment.systemPackages = with pkgs; [
    # Container orchestration
    # Docker Compose equivalent for Podman
    podman-compose
    
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
    win-virtio     # VirtIO drivers for Windows guests
  ];
}

