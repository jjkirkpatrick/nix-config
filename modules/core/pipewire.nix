# PipeWire audio server configuration - modern audio system
{ pkgs, ... }:
{
  # Disable PulseAudio (replaced by PipeWire)
  services.pulseaudio.enable = false;
  
  # Configure PipeWire audio server
  services.pipewire = {
    # Enable PipeWire as the main audio server
    enable = true;
    # Enable ALSA support for legacy applications
    alsa.enable = true;
    # Enable 32-bit ALSA support for older applications and games
    alsa.support32Bit = true;
    # Enable PulseAudio compatibility layer
    pulse.enable = true;
  };
  
  # Persist ALSA mixer settings across reboots
  hardware.alsa.enablePersistence = true;
  
  # Install PulseAudio tools for compatibility and debugging
  environment.systemPackages = with pkgs; [ 
    pulseaudioFull  # PulseAudio utilities (pavucontrol, pactl, etc.)
  ];
}
