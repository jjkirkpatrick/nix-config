{ pkgs, host, ... }:
{
  networking = {
    hostName = "${host}";
    wireless.enable = true;
    wireless.networks = {
      VodafoneD3EB53 = {
       psk = "FFK6r4Hsdxf3mbbT";
     };
    };


    #networkmanager.enable = true;
    nameservers = [
      "1.1.1.1"
      "8.8.8.8"
      "8.8.4.4"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22
        80
        443
        59010
        59011
      ];
      allowedUDPPorts = [
        59010
        59011
      ];
    };
  };

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
