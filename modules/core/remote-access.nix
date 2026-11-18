# Remote access configuration - Sunshine desktop streaming
#
# Reachable only from the LAN and the WireGuard VPN subnet: the UX gateway
# has no WAN port-forwards to this host. When away from home, connect to the
# WireGuard server first, then reach this PC at its LAN IP (192.168.1.75).
#
# The SSH server is deliberately disabled; Sunshine/Moonlight is the remote
# access path. To bring SSH back, enable services.openssh with key-only auth
# (PasswordAuthentication = false + users.users.<name>.openssh.authorizedKeys).
{ ... }:
let
  # Sunshine's base port; the others are fixed offsets from it.
  base = 47989;
in
{
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
    settings = {
      port = base;
      # Admin web UI (https://localhost:47990) only answers this machine.
      origin_web_ui_allowed = "pc";
    };
    # Ports are opened by hand below so the web UI port (base+1) stays shut.
    openFirewall = false;
  };

  networking.firewall = {
    # HTTPS pairing, HTTP, RTSP (offsets -5, 0, +21). Web UI (+1) omitted.
    allowedTCPPorts = map (o: base + o) [ (-5) 0 21 ];
    # Video, control, audio, mic, RTSP (same offsets as the upstream module).
    allowedUDPPorts = map (o: base + o) [ 9 10 11 13 21 ];
  };
}
