# System security and authentication configuration
{ ... }:
{
  # Real-time priority and scheduling configuration
  # RTKit allows programs to gain real-time priority without running as root
  # Essential for low-latency audio applications and multimedia
  security.rtkit.enable = true;
  
  # Enable sudo for privilege escalation
  # Allows users in the wheel group to execute commands as root
  security.sudo.enable = true;
  
  # PAM (Pluggable Authentication Modules) service configuration
  # Configure authentication for hyprlock screen locker
  # Empty configuration uses default PAM settings for authentication
  security.pam.services.hyprlock = { };
}
