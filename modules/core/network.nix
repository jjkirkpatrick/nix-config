# Network configuration - WiFi, firewall, and DNS settings
{ pkgs, host, ... }:
{
  networking = {
    # Set system hostname dynamically based on the host parameter
    hostName = "${host}";
    
    # Enable WiFi support using wpa_supplicant
    wireless.enable = true;
    
    # WiFi networks should be configured via secrets file for security
    # Create /etc/nixos/wireless-secrets with format:
    # psk_vodafone=your_password_here
    wireless.secretsFile = "/etc/nixos/wireless-secrets";
    
    # Define available WiFi networks
    wireless.networks = {
      # VodafoneD3EB53 network configuration
      VodafoneD3EB53 = {
        # Reference password from secrets file (ext: prefix loads from secretsFile)
        pskRaw = "ext:psk_vodafone";
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

  # Install NetworkManager applet for GUI network management
  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
