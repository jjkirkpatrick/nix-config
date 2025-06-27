# ======================================================================
# ZSH SHELL CONFIGURATION MODULE
# ======================================================================
# This module provides comprehensive ZSH shell configuration with modern
# enhancements for productivity, usability, and development workflows.
# It configures ZSH with intelligent completion, fuzzy finding, syntax
# highlighting, and a powerful theme system.
#
# Key Features:
# - Advanced tab completion with fuzzy matching
# - Syntax highlighting and auto-suggestions
# - Powerlevel10k theme for rich prompts
# - FZF integration for fuzzy finding
# - History management and search
# - Custom keybindings and functions
# ======================================================================

{ pkgs, ... }:
{
  programs.zsh = {
    # ============================================================
    # CORE ZSH CONFIGURATION
    # ============================================================
    # Enable ZSH and configure its essential features
    
    enable = true;                      # Enable ZSH as the user shell
    # enableCompletion = true;          # Disabled: handled manually for custom config
    autosuggestion.enable = true;       # Enable command auto-suggestions based on history
    syntaxHighlighting.enable = true;   # Enable syntax highlighting for commands
    
    # Auto-suggestions provide inline suggestions based on command history,
    # improving productivity by reducing typing and helping discover commands.
    # Syntax highlighting colors commands as you type, showing valid/invalid
    # commands and helping catch errors before execution.

    # ============================================================
    # ZSH PLUGINS CONFIGURATION
    # ============================================================
    # Load essential plugins that enhance ZSH functionality
    
    plugins = [
      {
        # FZF-Tab: Replace ZSH default tab completion with FZF fuzzy finder
        # Must be loaded before plugins that wrap widgets (autosuggestions, syntax highlighting)
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
        # Provides fuzzy matching for tab completion with preview windows
        # Allows interactive filtering of completion candidates
        # Integrates seamlessly with existing ZSH completion system
      }
      {
        # Powerlevel10k: Fast, flexible, and feature-rich ZSH theme
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        # Provides informative prompt with Git status, directory info, and more
        # Optimized for speed with instant prompt rendering
        # Highly customizable with extensive configuration options
      }
    ];

    # ============================================================
    # COMPLETION SYSTEM INITIALIZATION
    # ============================================================
    # Configure ZSH's powerful completion system with custom behavior,
    # caching, styling, and intelligent matching
    
    completionInit = ''
      # ========================================
      # ZSH MODULES AND SYSTEM INITIALIZATION
      # ========================================
      # Load essential ZSH modules (commented out as they're loaded by default)
      # zmodload zsh/zle        # Z-Line Editor for command line editing
      # zmodload zsh/zpty       # Pseudo-terminal support
      # zmodload zsh/complist   # Completion listing extensions

      # Initialize color support for prompts and completion
      autoload -Uz colors      # Load color functionality
      colors                   # Initialize color variables ($fg, $bg, etc.)

      # Initialize completion system (handled by home-manager)
      # autoload -U compinit    # Load completion initialization
      # compinit                # Initialize completion system
      _comp_options+=(globdots) # Include hidden files (dotfiles) in completion

      # ========================================
      # COMMAND LINE EDITING ENHANCEMENTS
      # ========================================
      # Set up advanced command line editing capabilities
      
      # Load edit-command-line widget for opening commands in external editor
      autoload -Uz edit-command-line  # Load the editing function
      zle -N edit-command-line        # Register as ZLE widget
      bindkey "^e" edit-command-line  # Bind Ctrl+E to open current command in $EDITOR
      # Useful for editing complex commands or multi-line scripts

      # ========================================
      # COMPLETION BEHAVIOR CONFIGURATION
      # ========================================
      # Configure how completions are generated and displayed
      
      # Set completion strategy: try extensions, then complete, then approximate
      zstyle ':completion:*' completer _extensions _complete _approximate
      # _extensions: Complete based on file extensions
      # _complete: Standard completion
      # _approximate: Fuzzy matching for typos (suggests corrections)

      # ========================================
      # COMPLETION CACHING SYSTEM
      # ========================================
      # Enable caching to speed up completion for slow commands
      
      zstyle ':completion:*' use-cache on    # Enable completion caching
      zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
      # Cache completions in XDG-compliant location for faster subsequent access
      # Particularly beneficial for package managers, Git, and other slow completers

      # ========================================
      # COMPLETION MATCHING AND BEHAVIOR
      # ========================================
      # Configure how completion matching works
      
      zstyle ':completion:*' complete true         # Complete aliases and functions
      zstyle ':completion:*' complete-options true # Show command options in completion

      # Advanced matching patterns for flexible completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      # Pattern 1: Case-insensitive matching (a matches A and vice versa)
      # Pattern 2: Partial matching on word boundaries (dots, underscores, hyphens)
      # Pattern 3: Left-anchored and right-anchored partial matching
      
      zstyle ':completion:*' keep-prefix true      # Keep typed prefix when completing

      # ========================================
      # COMPLETION DISPLAY AND FORMATTING
      # ========================================
      # Configure how completions are presented to the user
      
      # Menu selection for interactive completion browsing
      zstyle ':completion:*' menu select          # Use interactive menu for selection
      zstyle ':completion:*' list-grouped false   # Don't group completion lists
      zstyle ':completion:*' list-separator ''    # No separator between groups
      zstyle ':completion:*' group-name ''        # No group names displayed
      zstyle ':completion:*' verbose yes          # Show verbose descriptions
      
      # Group completion matches for better organization
      zstyle ':completion:*:matches' group 'yes'  # Group similar matches together
      
      # Format messages and descriptions for better user experience
      zstyle ':completion:*:warnings' format '%F{red}%B-- No match for: %d --%b%f'
      zstyle ':completion:*:messages' format '%d'
      zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'  
      zstyle ':completion:*:descriptions' format '[%d]'
      # Color-coded warnings, clear descriptions, and error counts

      # ========================================
      # COMPLETION VISUAL STYLING
      # ========================================
      # Apply colors to completion lists for better readability
      
      # Use LS_COLORS for file completion coloring (matches ls output)
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      # Files are colored according to their type, permissions, and extensions

      # ========================================
      # DIRECTORY-SPECIFIC COMPLETION BEHAVIOR
      # ========================================
      # Special handling for directory navigation and commands
      
      # Prioritize completion sources for 'cd' command
      zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
      # Order: current directory contents, directory stack, then PATH directories
      
      zstyle ':completion:*:*:cd:*:directory-stack' menu yes select  # Interactive directory stack
      
      # Configure tilde expansion completion (~user format)
      zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
      
      # Command completion ordering (prioritize aliases and functions)
      zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands
      
      zstyle ':completion:*' special-dirs true     # Include . and .. in completion
      zstyle ':completion:*' squeeze-slashes true  # Normalize multiple slashes in paths

      # ========================================
      # COMPLETION SORTING CONFIGURATION
      # ========================================
      # Control how completion results are ordered
      
      # Disable alphabetical sorting for more intelligent ordering
      zstyle ':completion:*' sort false            # Use natural/intelligent sorting
      zstyle ":completion:*:git-checkout:*" sort false  # Git branches by recency, not alphabetically
      zstyle ':completion:*' file-sort modification      # Sort files by modification time
      zstyle ':completion:*:eza' sort false        # Let eza handle its own sorting
      zstyle ':completion:complete:*:options' sort false # Don't sort command options
      zstyle ':completion:files' sort false        # Don't sort file completions alphabetically

      # ========================================
      # FZF-TAB PLUGIN CONFIGURATION
      # ========================================
      # Configure fzf-tab for enhanced fuzzy completion
      
      zstyle ':fzf-tab:*' use-fzf-default-opts yes  # Use global FZF options
      
      # Default preview for file/directory completion using eza
      zstyle ':fzf-tab:complete:*:*' fzf-preview 'eza --icons  -a --group-directories-first -1 --color=always $realpath'
      # Shows directory contents with icons and colors in preview window
      
      # Special preview for kill command (show process details)
      zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
      zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
      # Shows full command line for processes in kill completion
      
      # FZF-tab display configuration
      zstyle ':fzf-tab:*' fzf-command fzf          # Use fzf as the fuzzy finder
      zstyle ':fzf-tab:*' fzf-pad 4               # Padding around fzf interface
      zstyle ':fzf-tab:*' fzf-min-height 100      # Minimum height for fzf window
      zstyle ':fzf-tab:*' switch-group ',' '.'    # Keys to switch between completion groups
    '';

    # ============================================================
    # SHELL INITIALIZATION CONTENT
    # ============================================================
    # Runtime configuration that sets up the shell environment,
    # history behavior, prompt theming, and utility functions
    
    initContent = ''
      # ========================================
      # POWERLEVEL10K INSTANT PROMPT
      # ========================================
      # Enable instant prompt for faster shell startup
      # This must be near the top of shell initialization
      
      # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
      # Initialization code that may require console input (password prompts, [y/n]
      # confirmations, etc.) must go above this block; everything else may go below.
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi
      # Instant prompt shows immediately while background initialization continues
      # Provides near-zero perceived startup time

      # ========================================
      # SHELL BEHAVIOR CONFIGURATION
      # ========================================
      # Disable potentially problematic features for consistent behavior
      
      DISABLE_AUTO_UPDATE=true     # Prevent automatic updates that might break config
      DISABLE_MAGIC_FUNCTIONS=true # Disable shell magic functions that can cause issues
      export "MICRO_TRUECOLOR=1"   # Enable true color support for micro editor

      # ========================================
      # HISTORY MANAGEMENT CONFIGURATION
      # ========================================
      # Configure intelligent history behavior for better command recall
      
      setopt sharehistory           # Share history between all ZSH sessions
      setopt hist_ignore_space      # Don't record commands that start with space
      setopt hist_ignore_all_dups   # Don't record duplicate commands anywhere in history
      setopt hist_save_no_dups      # Don't save duplicate commands to history file
      setopt hist_ignore_dups       # Don't record consecutive duplicate commands
      setopt hist_find_no_dups      # Don't show duplicates when searching history
      setopt hist_expire_dups_first # Remove duplicates before unique commands when history fills
      setopt hist_verify            # Show command before executing from history expansion
      
      # These options create an intelligent history system that:
      # - Shares commands across terminal sessions
      # - Eliminates duplicate entries
      # - Allows private commands (prefix with space)
      # - Provides safety with verification

      # ========================================
      # THEME INITIALIZATION
      # ========================================
      # Load Powerlevel10k theme configuration
      
      source ~/.p10k.zsh           # Load Powerlevel10k configuration file
      # Contains all theme customizations, colors, and prompt segments

      # ========================================
      # FZF INTEGRATION FUNCTIONS
      # ========================================
      # Custom functions to enhance FZF functionality with fd and eza
      
      # Use fd (https://github.com/sharkdp/fd) for listing path candidates.
      # - The first argument to the function ($1) is the base path to start traversal
      # - See the source code (completion.{bash,zsh}) for the details.
      _fzf_compgen_path() {
        fd --hidden --exclude .git . "$1"
      }
      # Generate file paths using fd instead of find
      # Benefits: faster, respects .gitignore, cleaner output

      # Use fd to generate the list for directory completion
      _fzf_compgen_dir() {
        fd --type=d --hidden --exclude .git . "$1"
      }
      # Generate directory paths using fd for directory-specific completion
      # Filters to only directories, includes hidden dirs, excludes .git

      # Advanced customization of fzf options via _fzf_comprun function
      # - The first argument to the function is the name of the command.
      # - You should make sure to pass the rest of the arguments to fzf.
      _fzf_comprun() {
        local command=$1
        shift

        case "$command" in
          cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
          ssh)          fzf --preview 'dig {}'                   "$@" ;;
          *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
        esac
      }
      # Customize FZF behavior based on the command being completed
      # - cd: Show directory tree preview using eza
      # - ssh: Show DNS information for hostnames
      # - others: Use default preview function

      # ========================================
      # TERMINAL COMPATIBILITY CONFIGURATION
      # ========================================
      # Ensure proper terminal key handling for enhanced functionality
      
      # Make sure that the terminal is in application mode when zle is active, since
      # only then values from $terminfo are valid
      if (( ''${+terminfo[smkx]} )) && (( ''${+terminfo[rmkx]} )); then
        function zle-line-init() {
          echoti smkx            # Enter application mode
        }
        function zle-line-finish() {
          echoti rmkx            # Exit application mode
        }
        zle -N zle-line-init     # Register line initialization function
        zle -N zle-line-finish   # Register line finish function
      fi
      # This ensures special keys (arrows, function keys) work properly
      # Application mode enables extended key sequences
      # Critical for proper keybinding functionality
    '';
  };

  # ============================================================
  # ZOXIDE SMART DIRECTORY NAVIGATION
  # ============================================================
  # Enable zoxide for intelligent directory jumping based on frequency
  
  programs.zoxide = {
    enable = true;                # Enable zoxide smart directory navigation
    enableZshIntegration = true;  # Integrate with ZSH (provides 'z' command)
  };
  # Zoxide learns from your directory navigation patterns and provides:
  # - 'z' command for jumping to frequently used directories
  # - Fuzzy matching for directory names
  # - Integration with shell history
  # - Much faster than traditional 'cd' for common directories
}