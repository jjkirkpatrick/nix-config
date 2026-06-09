# Network configuration - WiFi, firewall, and DNS settings
{ pkgs, host, ... }:
{
  networking = {
    # Set system hostname dynamically based on the host parameter
    hostName = "${host}";

    # Enable WiFi support using wpa_supplicant
    wireless.enable = true;

    # WiFi passphrase is loaded from a secrets file outside the repo.
    # Create it once (do not commit this file):
    #   sudo bash -c 'echo "psk_VodafoneD3EB53=your_passphrase" > /etc/nixos/wireless-secrets'
    #   sudo chmod 600 /etc/nixos/wireless-secrets
    wireless.secretsFile = "/etc/nixos/wireless-secrets";

    wireless.networks = {
      "Josh's S23 Ultra" = {
        auth = ''
          key_mgmt=NONE
        '';
      };
    };

    # NetworkManager alternative (commented out in favor of wpa_supplicant)
    #networkmanager.enable = true;
    
    # Configure DNS servers for reliable name resolution
    nameservers = [
      "1.1.1.1"   # Cloudflare primary DNS
      "8.8.8.8"   # Google primary DNS
      "8.8.4.4"   # Google secondary DNS
    ];
    
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
