{
  # Brief description of this NixOS flake configuration
  description = "nixos configuration";

  # Input sources - external repositories and dependencies
  inputs = {
    # Main NixOS package repository - using unstable for latest packages
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager for user environment management
    home-manager = {
      url = "github:nix-community/home-manager";
      # Ensure home-manager uses the same nixpkgs as our system
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland compositor - modern Wayland compositor
    hyprland.url = "github:hyprwm/Hyprland";

    # Hyprland community contributions and utilities
    hypr-contrib = {
      url = "github:hyprwm/contrib";
      # Use the same nixpkgs as Hyprland for compatibility
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    # Hyprpicker - color picker tool for Hyprland
    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      # Use the same nixpkgs as Hyprland for compatibility
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
    };

    # Hyprlock - screen locker for Hyprland
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      # Ensure all Hyprland-related dependencies are synchronized
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    
    # Nix User Repository - community-maintained packages
    nur.url = "github:nix-community/NUR";
    # Nix Flatpak integration for managing Flatpak applications
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    # Ghostty terminal emulator
    ghostty.url = "github:ghostty-org/ghostty";
    # Catppuccin theme collection for consistent theming
    catppuccin.url = "github:catppuccin/nix";
  };

  # Flake outputs - the actual configurations produced by this flake
  outputs =
    { nixpkgs, self, home-manager, ... }@inputs:
    let
      # Default username for this configuration
      username = "josh";
      # Target system architecture (64-bit Linux)
      system = "x86_64-linux";
      # Import nixpkgs with system architecture and unfree packages enabled
      pkgs = import nixpkgs {
        inherit system;
        # Allow proprietary/unfree packages (needed for some drivers, etc.)
        config.allowUnfree = true;
      };
      # Import nixpkgs library functions for building configurations
      lib = nixpkgs.lib;
    in
    {
    # NixOS system configurations - defines complete system setups
    nixosConfigurations = {
      # Configuration for the "blue-pc" host
      blue-pc = nixpkgs.lib.nixosSystem {
        # Use the defined system architecture
        inherit system;
        # Import host-specific configuration modules
        modules = [ ./hosts/blue-pc ];
        # Special arguments passed to all modules
        specialArgs = {
          # Hostname identifier for conditional configuration
          host = "blue-pc";
          # Pass flake inputs and username to modules
          inherit self inputs username;
        };
      };
    };
    
    # Home Manager configurations - defines user environment setups
    homeConfigurations = {
      # Configuration for user "josh"
      josh = home-manager.lib.homeManagerConfiguration {
        # Use the configured package set
        pkgs = pkgs;
        # Import home manager modules
        modules = [ ./modules/home ];
        # Extra arguments passed to home manager modules
        extraSpecialArgs = {
          # Pass flake inputs and username to home modules
          inherit inputs username;
          # Specify which host this home config is for
          host = "blue-pc";
	};
      };
    };
  };
}
