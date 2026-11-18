# Network configuration - WiFi and firewall settings
{ pkgs, host, ... }:
{
  # wg / wg-quick CLI tools for connecting to the WireGuard VPN referenced
  # in remote-access.nix (no local WireGuard server/interface is defined here).
  environment.systemPackages = [ pkgs.wireguard-tools ];

  networking = {
    # Set system hostname dynamically based on the host parameter
    hostName = "${host}";

    dhcpcd = {
      # Only the physical NIC should get a host address. Without this dhcpcd
      # also leased an IP + a second default route on macvtap0 -- the
      # vozora-tunnel VM's interface, using the VM's MAC -- and probed the
      # disabled WiFi card. (gns3-oob is denied in gns3.nix; lists merge.)
      denyInterfaces = [ "macvtap*" "vnet*" "virbr*" "veth*" "docker*" "wlp*" ];
      # Don't hold boot on the DHCP lease (~9s on the critical path);
      # units that need it order after network-online.target.
      wait = "background";
    };

    # WiFi disabled - blue-pc is wired to ethernet full-time. Running WiFi
    # alongside ethernet caused dual default routes, and WiFi power-save
    # was intermittently stalling connections for several seconds even
    # though ethernet should have been preferred. Simplest fix: don't
    # bring the radio up at all.
    wireless.enable = false;

    # WiFi passphrase was loaded from a secrets file outside the repo.
    # Re-enable if WiFi is ever needed again:
    #   sudo bash -c 'echo "psk_TheDuke=your_passphrase" > /etc/nixos/wireless-secrets'
    #   sudo chown root:wpa_supplicant /etc/nixos/wireless-secrets
    #   sudo chmod 640 /etc/nixos/wireless-secrets
    # wireless.secretsFile = "/etc/nixos/wireless-secrets";
    #
    # wireless.networks = {
    #   "The Duke" = {
    #     pskRaw = "ext:psk_TheDuke";
    #     priority = 10;
    #   };
    #   "Josh's S23 Ultra" = {
    #     auth = ''
    #       key_mgmt=NONE
    #     '';
    #     priority = 1;
    #   };
    # };

    # NetworkManager alternative (commented out in favor of wpa_supplicant)
    #networkmanager.enable = true;

    # Firewall: default-deny inbound. Service modules open what they need
    # (Sunshine in remote-access.nix, Steam Remote Play in steam.nix).
    firewall.enable = true;
  };

}
