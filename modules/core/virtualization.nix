# Virtualization and containerization configuration
{ lib, pkgs, username, ... }:
{
  virtualisation = {
    spiceUSBRedirection.enable = true;
    
    libvirtd = {
      enable = true;
      # At power-off, shut guests down cleanly (in parallel) instead of saving
      # their RAM to disk: resuming those save files failed for every VM on
      # 2026-11-14 (libvirt_iohelper SIGPIPE) and they lost their state.
      onShutdown = "shutdown";
      parallelShutdown = 10;
      shutdownTimeout = 180;
      # At boot, only VMs marked with `virsh autostart <name>` start
      # (libvirtd handles that itself); libvirt-guests doesn't restart others.
      onBoot = "ignore";
    };
    
    docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # docker.rootless installs its systemd --user unit for every user session on
  # the system, including SDDM's ephemeral greeter account, which has no
  # subuid/subgid range and can never run it. The upstream module already
  # excludes root (ConditionUser = "!root"); tighten it to just our user so
  # it stops failing (and spamming the journal) on every login screen too.
  systemd.user.services.docker.unitConfig.ConditionUser = lib.mkForce username;

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

