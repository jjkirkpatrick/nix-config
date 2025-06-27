# ======================================================================
# BRAVE BROWSER CONFIGURATION
# ======================================================================
# This module installs the Brave web browser, a privacy-focused browser
# based on Chromium with built-in ad blocking, tracker protection, and
# cryptocurrency features.
#
# Brave is chosen for:
# - Enhanced privacy protection out of the box
# - Built-in ad and tracker blocking
# - Chromium compatibility for web development
# - Better performance than standard Chrome
# - Optional cryptocurrency rewards system
# ======================================================================

{ pkgs, ... }:
{
  # ============================================================
  # BROWSER INSTALLATION
  # ============================================================
  # Install Brave browser package
  
  home.packages = with pkgs; [ 
    brave                             # Brave browser - privacy-focused Chromium-based browser
                                     # Features:
                                     # - Built-in ad blocker (faster page loading)
                                     # - Tracker protection (enhanced privacy)
                                     # - HTTPS upgrading (improved security)
                                     # - Chromium engine (web development compatibility)
                                     # - Optional BAT rewards (browsing rewards)
                                     # - Tor integration for private browsing
  ];

  # ============================================================
  # BROWSER CONFIGURATION NOTES
  # ============================================================
  # Brave browser configuration is handled through the browser's settings UI.
  # Key recommended settings for development and privacy:
  #
  # Privacy Settings:
  # - Enable "Shields" for ad/tracker blocking
  # - Set fingerprinting protection to "Strict"
  # - Block cookies from third parties
  # - Upgrade connections to HTTPS
  #
  # Development Features:
  # - Chromium DevTools (F12)
  # - Extension compatibility with Chrome Web Store
  # - Modern web standards support
  # - Performance profiling tools
  #
  # For additional browser configuration (bookmarks, extensions, etc.),
  # consider using home-manager's browser management features or
  # manual setup through Brave's settings interface.
}
