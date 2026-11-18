# NVIDIA graphics driver configuration
{ config, lib, ... }:

{
  # Graphics hardware acceleration
  hardware.graphics = {
    # Enable OpenGL/Vulkan graphics acceleration
    # Required for GPU-accelerated applications and games
    enable = true;
  };

  # X11 video driver configuration
  # Load NVIDIA proprietary driver for both X11 and Wayland
  # This enables hardware acceleration in graphical applications
  services.xserver.videoDrivers = ["nvidia"];

  # Container GPU access (CDI specs for Docker/Podman --device nvidia.com/gpu).
  # Its CDI generator fails on a live driver bump, so apply driver updates
  # with `nh os boot .` + reboot (the auto-update timer already does).
  hardware.nvidia-container-toolkit.enable = true;

  # NVIDIA driver configuration options
  hardware.nvidia = {
    # Kernel modesetting configuration
    # Modesetting is required for Wayland support and modern display management
    # Enables the kernel to directly control display modes
    modesetting.enable = true;
    
    # Save/restore VRAM across suspend (nvidia-suspend/resume services).
    # Without it, Wayland sessions come back with corrupted graphics.
    powerManagement.enable = true;

    # Open kernel modules: NVIDIA's recommended module for Turing and newer
    # (this is an RTX 3080 Ti, Ampere).
    # See: https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    open = true;

    # NVIDIA Settings application
    # Enable the NVIDIA control panel GUI application
    # Accessible via 'nvidia-settings' command
    # Provides GPU monitoring, overclocking, and display configuration
    nvidiaSettings = true;

    # Driver branch: newest release (other options: stable/production, beta).
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
}
