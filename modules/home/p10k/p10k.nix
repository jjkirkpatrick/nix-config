# ======================================================================
# POWERLEVEL10K ZSH THEME CONFIGURATION
# ======================================================================
# This module configures Powerlevel10k (p10k), a highly customizable and
# fast ZSH theme that provides a rich, informative shell prompt with
# Git integration, system status, and beautiful powerline separators.
#
# Powerlevel10k features:
# - Lightning-fast prompt rendering
# - Extensive customization options
# - Git repository status integration
# - Command execution time display
# - System load and status indicators
# - Nerd Font icon support
# ======================================================================

{ ... }:
{
  # ============================================================
  # POWERLEVEL10K CONFIGURATION DEPLOYMENT
  # ============================================================
  # Deploy the Powerlevel10k configuration file to the home directory
  # This file contains all the theme customizations and prompt settings
  
  home.file.".p10k.zsh".source = ./.p10k.zsh;
  # The .p10k.zsh file contains:
  # - Prompt segment configuration (what information to show)
  # - Color scheme settings (matching the Dark Space theme)
  # - Icon selections (using Nerd Font glyphs)
  # - Layout and positioning (left/right prompt elements)
  # - Conditional display rules (when to show/hide elements)
  
  # ============================================================
  # POWERLEVEL10K INTEGRATION NOTES
  # ============================================================
  # This configuration file is sourced by the ZSH configuration
  # (see zsh/zsh.nix) which loads Powerlevel10k as a plugin.
  #
  # Key features typically configured in .p10k.zsh:
  # - Current directory with smart truncation
  # - Git branch, status, and modification indicators
  # - Command execution time for long-running commands
  # - Exit status of previous command
  # - Background jobs indicator
  # - Python virtual environment display
  # - Node.js version when in Node projects
  # - Custom prompt segments and separators
  #
  # The configuration is designed to be:
  # - Informative without being cluttered
  # - Fast to render (Powerlevel10k's main advantage)
  # - Visually consistent with the Dark Space theme
  # - Suitable for development workflows
  #
  # To reconfigure Powerlevel10k interactively, run:
  # p10k configure
}