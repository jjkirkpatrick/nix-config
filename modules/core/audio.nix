# ======================================================================
# PIPEWIRE AUDIO SYSTEM CONFIGURATION
# ======================================================================
# Complete audio system configuration using PipeWire as the modern
# replacement for PulseAudio. This module provides:
# - PipeWire audio server with full compatibility layers
# - ALSA support for legacy applications and hardware
# - PulseAudio compatibility for existing applications
# - USB audio interface support (Focusrite Scarlett series)
# - Audio device management tools and utilities
#
# PipeWire replaces PulseAudio while maintaining compatibility and
# providing better performance, lower latency, and more flexible routing.
# ======================================================================

{pkgs, ...}: 

{
    # ========================================
    # PULSEAUDIO REPLACEMENT
    # ========================================
    # Explicitly disable PulseAudio since PipeWire replaces it
    # This prevents conflicts and ensures clean audio stack
    services.pulseaudio.enable = false;
    
    # ========================================
    # PIPEWIRE AUDIO SERVER CONFIGURATION
    # ========================================
    # PipeWire is a modern audio/video server that provides:
    # - Low-latency audio processing
    # - Professional audio routing capabilities
    # - Better security model than PulseAudio
    # - Real-time audio processing support
    services.pipewire = {
        # Enable PipeWire as the primary audio server
        # Replaces both PulseAudio and JACK for most use cases
        enable = true;
        
        # Enable ALSA (Advanced Linux Sound Architecture) support
        # Required for:
        # - Legacy applications that use ALSA directly
        # - Hardware that only supports ALSA
        # - Low-level audio applications
        alsa.enable = true;
        
        # Enable 32-bit ALSA support for compatibility
        # Essential for:
        # - 32-bit applications on 64-bit systems
        # - Older games and multimedia software
        # - Wine/Steam Proton Windows compatibility
        alsa.support32Bit = true;
        
        # Enable PulseAudio compatibility layer
        # Provides seamless migration for:
        # - Applications designed for PulseAudio
        # - Desktop environments expecting PulseAudio
        # - Existing audio configuration and scripts
        pulse.enable = true;
    };
    
    # ========================================
    # HARDWARE AUDIO CONFIGURATION
    # ========================================
    # Persist ALSA mixer settings across system reboots
    # Ensures volume levels and device settings are maintained
    # Important for consistent audio experience
    hardware.alsa.enablePersistence = true;
    
    # ========================================
    # AUDIO MANAGEMENT PACKAGES
    # ========================================
    # Install essential audio management and control utilities
    environment.systemPackages = [
        # Focusrite Scarlett USB audio interface management
        # Provides GUI control for:
        # - Input/output routing and mixing
        # - Hardware-specific controls and settings
        # - Real-time monitoring and configuration
        pkgs.alsa-scarlett-gui
        
        # PulseAudio utilities for compatibility and control
        # Includes essential tools:
        # - pavucontrol: GUI volume control and device management
        # - pactl: Command-line audio control utility
        # - pamixer: Command-line mixer interface
        # These tools work with PipeWire's PulseAudio compatibility layer
        pkgs.pulseaudioFull
    ];
    
    # ========================================
    # USB AUDIO INTERFACE CONFIGURATION
    # ========================================
    # Kernel module configuration for professional USB audio devices
    # Specifically optimized for Focusrite Scarlett series interfaces
    boot.extraModprobeConfig = ''
      # Focusrite Scarlett USB audio interface optimization
      # vid=0x1235: Focusrite vendor ID
      # pid=0x8212: Scarlett device product ID (adjust for your model)
      # device_setup=1: Enables advanced features including:
      #   - Individual input/output control
      #   - Hardware monitoring capabilities
      #   - Low-latency direct monitoring
      #   - Enhanced routing and mixing options
      options snd_usb_audio vid=0x1235 pid=0x8212 device_setup=1
    '';
}