# User account and Home Manager configuration
{
  pkgs,
  inputs,
  username,
  host,
  ...
}:
{
  # Import Home Manager NixOS module
  # Home Manager manages user-specific packages and dotfiles
  imports = [ inputs.home-manager.nixosModules.home-manager ];
  
  # Home Manager configuration
  home-manager = {
    # Use packages from system configuration instead of separate ones
    # More efficient and ensures consistency between system and user packages
    useUserPackages = true;
    
    # Use the same nixpkgs instance as the system
    # Prevents version mismatches between system and home packages
    useGlobalPkgs = true;
    
    # Pass additional arguments to Home Manager configurations
    # Makes inputs, username, and host available in home configurations
    extraSpecialArgs = { inherit inputs username host; };
    
    # File backup extension when Home Manager needs to replace existing files
    # Existing files will be renamed with .backup extension
    backupFileExtension = "backup";
    
    # User-specific Home Manager configuration
    users.${username} = {
      # Import different home configurations based on host type
      imports =
        if (host == "desktop") then
          # Desktop-specific home configuration
          [ ./../home/default.desktop.nix ]
        else
          # Default home configuration for other hosts
          [ ./../home ];
      
      # Basic Home Manager settings
      home.username = "${username}";
      home.homeDirectory = "/home/${username}";
      
      # Home Manager state version - should match system stateVersion
      # This determines which Home Manager release to use for this user
      home.stateVersion = "25.05";
      
      # Enable Home Manager to manage itself
      # Allows home-manager command to work for the user
      programs.home-manager.enable = true;
    };
  };

  # System user account configuration
  users.users.${username} = {
    # Create a normal user account (not system user)
    isNormalUser = true;
    
    # User description/full name
    description = "${username}";
    
    # Additional groups for user permissions
    extraGroups = [
      # Network configuration permissions
      "networkmanager"
      # Administrative privileges (sudo access)
      "wheel"
    ];
    
    # Set default shell to Zsh
    shell = pkgs.zsh;
  };
  
  # Nix daemon configuration
  # Allow this user to interact with the Nix daemon
  # Required for using nix commands as a non-root user
  nix.settings.allowed-users = [ "${username}" ];
}
