
{ pkgs, ... }:
{
  # ============================================================
  # AUDIBLE CLI INSTALLATION
  # ============================================================
  # Install Audible CLI package for managing Audible audiobooks
  
  home.packages = with pkgs; [ 
    audible-cli                             # Audible CLI - command-line interface for Audible audiobooks
                                     # Features:
                                     # - Download and manage Audible audiobooks
                                     # - Convert audiobooks to various formats
                                     # - Library management and organization
                                     # - Authentication with Audible accounts
                                     # - Batch processing capabilities
                                     # - Metadata management and tagging
  ];

}