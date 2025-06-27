{ pkgs, ... }:

{
  # Enable Display Manager

  services.displayManager = {
			sddm.enable = true;
      sddm.theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
		};

  environment.systemPackages = [ pkgs.libsForQt5.qt5.qtgraphicaleffects ];



}
