# Remote access configuration - SSH and Sunshine desktop streaming
#
# Both services are reachable only from the LAN and the WireGuard VPN
# subnet: the UX gateway has no WAN port-forwards to this host, so nothing
# here is exposed to the public internet. When away from home, connect to
# the WireGuard server first, then reach this PC at its LAN IP (192.168.1.75).
{ username, ... }:
{
  # SSH server - the always-available backbone for CLI access and tunnelling.
  # Port 22 is already opened in network.nix.
  services.openssh = {
    enable = true;
    settings = {
      # Never allow direct root login over SSH
      PermitRootLogin = "no";
      # Password auth is left on because access is already gated behind the
      # WireGuard VPN (no WAN exposure). To harden further, drop a public key
      # into users.users.${username}.openssh.authorizedKeys.keys below and
      # set this to false.
      PasswordAuthentication = true;
    };
  };

  # Place your laptop's SSH public key here, then you can flip
  # PasswordAuthentication to false above for key-only login.
  # users.users.${username}.openssh.authorizedKeys.keys = [
  #   "ssh-ed25519 AAAA... josh@laptop"
  # ];

  # Sunshine - low-latency desktop streaming server (Moonlight is the client).
  # Uses the NVIDIA GPU's NVENC hardware encoder and captures the running
  # Hyprland/Wayland session via KMS.
  services.sunshine = {
    enable = true;
    # Start with the graphical session so it's ready without manual launch.
    autoStart = true;
    # Grants CAP_SYS_ADMIN to the capture helper, required for KMS/DRM
    # screen capture under Wayland compositors like Hyprland.
    capSysAdmin = true;
    # Open Sunshine's TCP/UDP ports in the firewall (LAN/VPN reachable only,
    # per the no-WAN-forward note above).
    openFirewall = true;
  };
}
