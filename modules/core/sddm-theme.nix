# SDDM custom theme package - Astronaut theme
{ pkgs }:

# Custom SDDM theme derivation
# Creates a Nix package from the astronaut theme GitHub repository
pkgs.stdenv.mkDerivation {
    # Package name identifier
    name = "sddm-theme";
    
    # Source code from GitHub repository
    src = pkgs.fetchFromGitHub {
        # Repository owner
        owner = "gpskwlkr";
        
        # Repository name
        repo = "sddm-astronaut-theme";
        
        # Specific commit hash for reproducible builds
        # This ensures the exact same version is always used
        rev = "468a100460d5feaa701c2215c737b55789cba0fc";
        
        # SHA256 hash of the source for integrity verification
        # Prevents tampering and ensures reproducible builds
        sha256 = "1h20b7n6a4pbqnrj22y8v5gc01zxs58lck3bipmgkpyp52ip3vig";
    };
    
    # Installation phase - copy theme files to output directory
    installPhase = ''
        # Create output directory
        mkdir -p $out
        
        # Copy all theme files to the output
        # This makes the theme available to SDDM
        cp -R ./* $out/
    '';
}