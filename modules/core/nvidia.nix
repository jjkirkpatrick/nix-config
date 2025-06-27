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

  # Container GPU access configuration
  # Enable NVIDIA Container Toolkit for GPU access in containers
  # Allows Docker/Podman containers to use GPU acceleration
  hardware.nvidia-container-toolkit.enable = true;

  # NVIDIA driver configuration options
  hardware.nvidia = {
    # Kernel modesetting configuration
    # Modesetting is required for Wayland support and modern display management
    # Enables the kernel to directly control display modes
    modesetting.enable = true;
    
    # Power management configuration
    # NVIDIA power management is experimental and may cause issues
    # Enable this if you experience graphical corruption after suspend/resume
    # When enabled, saves entire VRAM to /tmp/ instead of just essentials
    # Currently disabled to avoid potential sleep/suspend failures
    powerManagement.enable = false;

    # Kernel module selection
    # Choose between open-source and proprietary NVIDIA kernel modules
    # Open-source module supports Turing+ architectures (GTX 16xx, RTX 20xx+)
    # See: https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Set to false to use proprietary module for better compatibility
    open = false;

    # NVIDIA Settings application
    # Enable the NVIDIA control panel GUI application
    # Accessible via 'nvidia-settings' command
    # Provides GPU monitoring, overclocking, and display configuration
    nvidiaSettings = true;

    # Driver version selection
    # Use production/stable driver branch for maximum stability
    # Alternative options: beta, vulkan_beta, legacy_470, legacy_390
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };
}
