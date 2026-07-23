# Network configuration - WiFi and firewall settings
{ pkgs, host, ... }:
{
  networking = {
    # Set system hostname dynamically based on the host parameter
    hostName = "${host}";

    # Enable WiFi support using wpa_supplicant
    wireless.enable = true;

    # WiFi passphrase is loaded from a secrets file outside the repo.
    # The wpa_supplicant service runs as the unprivileged `wpa_supplicant`
    # user, so the file must be readable by that group (640), NOT root-only.
    # Create it once (do not commit this file):
    #   sudo bash -c 'echo "psk_TheDuke=your_passphrase" > /etc/nixos/wireless-secrets'
    #   sudo chown root:wpa_supplicant /etc/nixos/wireless-secrets
    #   sudo chmod 640 /etc/nixos/wireless-secrets
    wireless.secretsFile = "/etc/nixos/wireless-secrets";

    wireless.networks = {
      # Home network - preferred when in range
      "The Duke" = {
        pskRaw = "ext:psk_TheDuke";
        priority = 10;
      };
      # Phone hotspot - fallback when home network is unavailable
      "Josh's S23 Ultra" = {
        auth = ''
          key_mgmt=NONE
        '';
        priority = 1;
      };
    };

    # NetworkManager alternative (commented out in favor of wpa_supplicant)
    #networkmanager.enable = true;

    # Firewall configuration for network security
    firewall = {
      # Enable the firewall for network protection
      enable = true;
      # Allow incoming TCP connections on specific ports
      allowedTCPPorts = [
        22      # SSH remote access
        80      # HTTP web traffic
        443     # HTTPS secure web traffic
        59010   # Custom application port
        59011   # Custom application port
      ];
      # Allow incoming UDP connections on specific ports
      allowedUDPPorts = [
        59010   # Custom application port
        59011   # Custom application port
      ];
    };
  };

}
