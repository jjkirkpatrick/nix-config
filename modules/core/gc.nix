# Nix store optimization and garbage collection configuration
{ ... }:

{
  # Nix store optimization and automatic garbage collection
  # These settings help manage disk space by removing unused packages and optimizing storage
  
  # Manual garbage collection commands for reference:
  # `nix-store --optimize` - Find and eliminate redundant copies of identical store paths
  # `nix-store --gc` - Remove unreferenced and obsolete store paths
  # `nix-collect-garbage -d` - Delete old generations of user profiles
  
  # Nix store settings
  nix.settings = {
    # Automatically optimize store during builds
    # Deduplicates identical files by creating hard links
    # Saves significant disk space over time
    auto-optimise-store = true;
  };
  
  # Automatic store optimization
  nix.optimise = {
    # Enable automatic store optimization
    # Runs periodically to deduplicate store paths
    automatic = true;
  };
  
  # Garbage collection configuration
  nix.gc = {
    # Enable automatic garbage collection
    automatic = true;
    
    # Schedule for garbage collection
    # Runs weekly to clean up unused packages
    dates = "weekly";
    
    # Garbage collection options
    # Delete generations older than 14 days
    # Keeps recent generations for rollback capability
    options = "--delete-older-than 14d";
  };
}