# ======================================================================
# ZSH SHELL CONFIGURATION MODULE
# ======================================================================
# This module orchestrates the complete ZSH shell environment by importing
# all the specialized configuration files. ZSH provides an advanced shell
# experience with powerful features like autocompletion, syntax highlighting,
# history search, and extensive customization options.
#
# Configuration is split into logical modules:
# - Core ZSH settings and plugins
# - Shell aliases for productivity
# - Custom keybindings for enhanced navigation
# ======================================================================

{ pkgs, ... }:
{
  # ============================================================
  # ZSH CONFIGURATION IMPORTS
  # ============================================================
  # Import all ZSH-related configuration modules to create a complete
  # shell environment optimized for development and daily use
  
  imports = [
    ./zsh.nix            # Core ZSH configuration, plugins, and settings
                        # - Base ZSH configuration
                        # - Plugin management (fzf-tab, powerlevel10k)
                        # - Completion system setup
                        # - History management
                        # - Integration with modern tools

    ./zsh_alias.nix     # Shell aliases for common commands and workflows
                        # - Improved versions of standard commands (eza, bat, rg)
                        # - Git shortcuts for version control
                        # - System management aliases
                        # - Development workflow shortcuts

    ./zsh_keybinds.nix  # Custom keybindings for enhanced shell navigation
                        # - Word-by-word navigation (Ctrl+Arrow)
                        # - Better history search
                        # - Line editing improvements
                        # - Terminal-specific key mappings
  ];

  # ============================================================
  # ZSH CONFIGURATION NOTES
  # ============================================================
  # This modular approach provides:
  # - Clean separation of concerns
  # - Easy maintenance and updates
  # - Selective customization options
  # - Better organization of shell features
  #
  # The ZSH configuration integrates with:
  # - Powerlevel10k theme for a beautiful prompt
  # - Fzf for fuzzy finding and completion
  # - Modern CLI tools (eza, bat, ripgrep, fd)
  # - Development tools and workflows
  # - Zoxide for smart directory navigation
  #
  # Together, these modules create a powerful, efficient, and
  # visually appealing shell environment suitable for both
  # development work and system administration.
}