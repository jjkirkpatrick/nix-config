# Nix store optimization and garbage collection configuration
{ ... }:

{
  # Nix store optimization and automatic garbage collection
  # These settings help manage disk space by removing unused packages and optimizing storage
  
  # Manual garbage collection commands for reference:
  # `nix-store --optimize` - Find and eliminate redundant copies of identical store paths
  # `nix-store --gc` - Remove unreferenced and obsolete store paths
  # `nix-collect-garbage -d` - Delete old generations of user profiles
  
  # Periodic store deduplication (hard-links identical store paths)
  # auto-optimise-store in system.nix covers per-build optimisation;
  # this scheduled job catches anything that slipped through.
  nix.optimise.automatic = true;

  # Garbage collection is handled by programs.nh.clean in nh.nix
  # (keeps last 7 days and 5 generations). Do not set nix.gc.automatic
  # here as the two conflict.
}