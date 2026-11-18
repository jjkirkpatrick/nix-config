{
  # Brief description of this NixOS flake configuration
  description = "nixos configuration";

  # Input sources - external repositories and dependencies
  inputs = {
    # Main NixOS package repository - using unstable for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager for user environment management (used as a NixOS module,
    # see modules/core/user.nix)
    home-manager = {
      url = "github:nix-community/home-manager";
      # Ensure home-manager uses the same nixpkgs as our system
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland compositor - modern Wayland compositor
    hyprland.url = "github:hyprwm/Hyprland";

    # Nix User Repository - community-maintained packages
    nur.url = "github:nix-community/NUR";
    # Nix Flatpak integration for managing Flatpak applications
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # osrs-login - minimal Jagex-account launcher for Old School RuneScape
    osrs-login = {
      url = "github:jjkirkpatrick/osrs-login";
      # Build against our nixpkgs to avoid a second copy
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Flake outputs - the actual configurations produced by this flake
  outputs =
    { nixpkgs, self, ... }@inputs:
    let
      # Default username for this configuration
      username = "josh";
    in
    {
      # NixOS system configurations. Home Manager runs inside this as a NixOS
      # module, so `nh os switch .` updates both system and user environment.
      nixosConfigurations.blue-pc = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/blue-pc ];
        specialArgs = {
          host = "blue-pc";
          inherit self inputs username;
        };
      };
    };
}
