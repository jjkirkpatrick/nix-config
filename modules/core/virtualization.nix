# Virtualization and containerization configuration
{ pkgs, ... }: 

{
  virtualisation = {
    # SPICE protocol configuration
    # Enable USB device redirection for virtual machines
    # Allows passing USB devices from host to guest VMs
    spiceUSBRedirection.enable = true;

    # libvirtd virtualization daemon
    libvirtd = {
      # Enable libvirtd for managing virtual machines
      # Provides the backend for virt-manager and virsh
      enable = true;

      # QEMU/KVM configuration
      qemu = {
        # Software TPM (Trusted Platform Module) support
        # Required for Windows 11 and other modern OS security features
        swtpm.enable = true;
        
        # OVMF UEFI firmware support
        # Enables UEFI boot for virtual machines instead of legacy BIOS
        ovmf.enable = true;
        
        # Full OVMF package with secure boot support
        # Includes additional UEFI features and security capabilities
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };

    # Podman container runtime configuration
    podman = {
      # Enable Podman as container runtime
      # Rootless container alternative to Docker
      enable = true;

      # Docker compatibility layer
      # Allows using 'docker' command that maps to podman
      dockerCompat = true;
      
      # Network configuration
      defaultNetwork.settings = {
        # Enable DNS resolution for containers
        # Allows containers to resolve domain names
        dns_enabled = true;
      };
    };
  };

  # Virtualization and container management tools
  environment.systemPackages = with pkgs; [
    # Container orchestration
    # Docker Compose equivalent for Podman
    podman-compose
    
    # Virtual machine emulation
    # QEMU system emulator and virtualizer
    qemu
    
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