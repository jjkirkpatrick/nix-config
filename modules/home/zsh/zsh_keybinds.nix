# ======================================================================
# ZSH CUSTOM KEYBINDINGS CONFIGURATION
# ======================================================================
# This module defines custom keybindings for ZSH that enhance terminal
# navigation and editing capabilities. These bindings provide familiar
# keyboard shortcuts for efficient command-line editing and history navigation.
#
# Features:
# - Word-by-word navigation (like modern text editors)
# - Enhanced history search and navigation
# - Improved line editing capabilities
# - Terminal-specific key mappings
# ======================================================================

{ pkgs, ... }:
{
  programs.zsh.initContent = ''
    # ============================================================
    # WORD AND CHARACTER NAVIGATION
    # ============================================================
    # Enable efficient movement within command lines using familiar
    # keyboard shortcuts similar to modern text editors
    
    bindkey "^[[1;5C" forward-word      # Ctrl+Right Arrow - Jump forward by word
                                       # Quickly navigate to the next word boundary
    
    bindkey "^[[1;5D" backward-word     # Ctrl+Left Arrow - Jump backward by word
                                       # Quickly navigate to the previous word boundary
    
    bindkey "^[[3~" delete-char         # Delete key - Delete character forward
                                       # Standard delete functionality (forward deletion)
    
    bindkey "^[[H" beginning-of-line    # Home key - Jump to beginning of line
                                       # Quick navigation to start of command
    
    bindkey "^[[F" end-of-line          # End key - Jump to end of line
                                       # Quick navigation to end of command

    # ============================================================
    # WORD DELETION COMMANDS
    # ============================================================
    # Enhanced word deletion for faster command line editing
    
    bindkey "^[[3;5~" kill-word         # Ctrl+Delete - Delete word forward
                                       # Remove the word to the right of cursor
    
    bindkey "^H" backward-kill-word     # Ctrl+Backspace - Delete word backward
                                       # Remove the word to the left of cursor

    # ============================================================
    # HISTORY SEARCH AND NAVIGATION
    # ============================================================
    # Improved history navigation that searches based on current input
    # and provides intuitive up/down arrow behavior
    
    # Basic reverse history search (traditional functionality)
    bindkey "^R" history-incremental-search-backward
    # Ctrl+R - Interactive reverse history search
    # Type to search through previous commands
    
    # Enhanced history navigation with partial matching
    # Load ZSH functions for better history navigation
    autoload -U up-line-or-beginning-search
    autoload -U down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
    
    # Bind arrow keys to enhanced history functions
    bindkey "^[[A" up-line-or-beginning-search      # Up Arrow
    # Search backward through history for commands starting with current input
    # If no input: normal history navigation
    # If partial command typed: search for matching commands
    
    bindkey "^[[B" down-line-or-beginning-search    # Down Arrow  
    # Search forward through history for commands starting with current input
    # Complements the up arrow for bidirectional history navigation
  '';

  # ============================================================
  # KEYBINDING CONFIGURATION NOTES
  # ============================================================
  # These keybindings provide:
  # - Modern text editor-like navigation (Ctrl+Arrow keys)
  # - Efficient command line editing (word deletion)
  # - Smart history search (partial command matching)
  # - Familiar keyboard shortcuts for productivity
  #
  # Key benefits:
  # - Faster command composition and editing
  # - Reduced typing for complex commands
  # - Intuitive navigation that matches other applications
  # - Enhanced history utilization for repeated tasks
  #
  # The enhanced history navigation is particularly useful for:
  # - Recalling similar commands (start typing, then use arrows)
  # - Navigating through related commands in history
  # - Reducing retyping of complex command structures
  # - Building on previous commands with modifications
}