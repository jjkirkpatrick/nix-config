# ======================================================================
# ZSH SHELL ALIASES CONFIGURATION
# ======================================================================
# This module defines shell aliases that enhance productivity by providing
# shorter commands, improved defaults for common tools, and quick access
# to frequently used operations. Aliases replace standard commands with
# better alternatives and create shortcuts for complex operations.
#
# Philosophy: Replace traditional Unix tools with modern alternatives
# that provide better output, performance, and user experience.
# ======================================================================

{ pkgs, ... }:
{
  programs.zsh.shellAliases = {
    # ========================================
    # ENHANCED FILE AND DIRECTORY OPERATIONS
    # ========================================
    # Replace traditional commands with modern alternatives that provide
    # better output formatting, colors, and additional functionality
    
    l = "eza --icons  -a --group-directories-first -1";
    # List files with icons, show hidden files, group directories first
    # eza is a modern replacement for 'ls' with better colors and formatting
    
    ll = "eza --icons  -a --group-directories-first -1 --no-user --long";
    # Long format listing with detailed information but without user column
    # Provides file sizes, permissions, dates in a clean format
    
    tree = "eza --icons --tree --group-directories-first";
    # Tree view of directory structure with icons and organized layout
    # Better than traditional 'tree' command with modern styling
    
    cat = "bat";
    # Syntax-highlighted file viewer with line numbers and Git integration
    # bat enhances 'cat' with colors, paging, and better readability
    
    grep = "rg";
    # ripgrep - faster, smarter grep with better defaults
    # Automatically ignores binary files, respects .gitignore, faster searches
    
    find = "fd";
    # Modern find replacement with simpler syntax and better performance
    # Respects .gitignore, uses parallel processing, more intuitive interface

    # ========================================
    # GIT VERSION CONTROL SHORTCUTS
    # ========================================
    # Common Git operations with short, memorable aliases
    # Speeds up version control workflows
    
    g = "git";              # Quick access to git command
    ga = "git add";         # Stage files for commit
    gc = "git commit";      # Create a commit
    gp = "git push";        # Push changes to remote repository
    gl = "git pull";        # Pull changes from remote repository
    gs = "git status";      # Check repository status
    gd = "git diff";        # View changes between commits/files
    
    # ========================================
    # NIXOS SYSTEM MANAGEMENT
    # ========================================
    # Quick commands for rebuilding and updating the NixOS system
    # These automate common system administration tasks
    
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#blue-pc";
    # Rebuild and switch to new NixOS system configuration
    # Uses the local flake configuration for the 'blue-pc' system
    
    home-rebuild = "home-manager switch --flake ~/nixos-config#josh";
    # Rebuild home-manager configuration for user environment
    # Updates user-space configuration without affecting system-wide settings
    
    # ========================================
    # DEVELOPMENT ENVIRONMENT SHORTCUTS
    # ========================================
    # Quick access to development tools and common workflows
    
    cdnix = "cd ~/nixos-config && codium ~/nixos-config";
    # Navigate to NixOS configuration directory and open in VS Codium
    # Combines directory change with editor launch for quick config editing

    # ========================================
    # DIRECTORY NAVIGATION HELPERS
    # ========================================
    # Quick shortcuts for moving up directory levels
    # Saves typing and reduces errors in navigation
    
    ".." = "cd ..";         # Go up one directory level
    "..." = "cd ../..";     # Go up two directory levels
    "...." = "cd ../../.."; # Go up three directory levels
    
    # ========================================
    # GENERAL PRODUCTIVITY SHORTCUTS
    # ========================================
    # Common terminal operations made shorter and more convenient
    
    h = "history";          # View command history (shorter than typing 'history')
    c = "clear";            # Clear terminal screen (quick screen cleanup)
    q = "exit";             # Exit shell (faster than typing 'exit')
  };

  # ============================================================
  # ALIAS CONFIGURATION NOTES
  # ============================================================
  # These aliases are designed to:
  # - Reduce typing for common operations
  # - Provide better defaults for standard Unix commands
  # - Integrate modern CLI tools seamlessly
  # - Support efficient development workflows
  # - Maintain muscle memory while improving functionality
  #
  # The aliases work together with:
  # - ZSH autocompletion for command suggestions
  # - Modern CLI tools installed via packages
  # - Git workflows for version control
  # - NixOS system management
  # - Terminal navigation and productivity
}