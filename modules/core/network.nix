# Network configuration - WiFi, firewall, and DNS settings
{ pkgs, host, ... }:
{
  # Disable wifi power saving. With power save on, the card sleeps between
  # beacons; on a marginal link (The Duke's 5 GHz at ~-72 dBm) this causes
  # constant CTRL-EVENT-BEACON-LOSS and the AP kicking us with
  # DISASSOC_LOW_ACK. power_scheme=1 = CAM (continuously active mode).
  # Takes effect on module reload (reboot); `iw dev wlp6s0 set power_save off`
  # applies it to the running session.
  boot.extraModprobeConfig = ''
    options iwlwifi power_save=0
    options iwlmvm power_scheme=1
  '';

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
        # Pin to 2.4 GHz (UK channels 1-13). The router's 5 GHz radio is too
        # weak here (~-72 dBm): it repeatedly kicks us (DISASSOC_LOW_ACK) and
        # the resulting roam scans between bands cause drops and ping spikes.
        # Remove this to re-enable 5 GHz if the PC moves closer to the router.
        extraConfig = ''
          freq_list=2412 2417 2422 2427 2432 2437 2442 2447 2452 2457 2462 2467 2472
        '';
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
