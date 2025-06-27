# ======================================================================
# USER PACKAGES ORGANIZATION
# ======================================================================
# This module organizes user packages into logical categories to maintain
# a clean and manageable package list. Packages are separated into:
# - CLI tools and command-line utilities
# - GUI applications and desktop software
#
# This separation makes it easier to manage different types of software
# and allows for selective installation based on system role (server vs desktop).
# ======================================================================

{ ... }:
{
  # Import package category modules
  imports = [
    # Command-line interface tools and utilities
    ./cli.nix                        # Terminal applications, system utilities, development tools
    # Graphical user interface applications
    ./gui.nix                        # Desktop applications, GUI utilities, media software
  ];
}