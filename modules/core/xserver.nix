{ username, ... }:
{
  services = {
    xserver = {
      enable = true;
      xkb.layout = "gb";
    };

    libinput = {
      enable = true;
    };
  };
  # To prevent getting stuck at shutdown
  systemd.extraConfig = "DefaultTimeoutStopSec=10s";
}
