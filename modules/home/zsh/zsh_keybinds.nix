{ pkgs, ... }:
{
  programs.zsh.initContent = ''
    # Key bindings
    bindkey "^[[1;5C" forward-word      # Ctrl+Right
    bindkey "^[[1;5D" backward-word     # Ctrl+Left
    bindkey "^[[3~" delete-char         # Delete
    bindkey "^[[H" beginning-of-line    # Home
    bindkey "^[[F" end-of-line          # End
    bindkey "^[[3;5~" kill-word         # Ctrl+Delete
    bindkey "^H" backward-kill-word     # Ctrl+Backspace
    
    # History search
    bindkey "^[[A" history-search-backward    # Up arrow
    bindkey "^[[B" history-search-forward     # Down arrow
    bindkey "^R" history-incremental-search-backward
    
    # Better history navigation
    autoload -U up-line-or-beginning-search
    autoload -U down-line-or-beginning-search
    zle -N up-line-or-beginning-search
    zle -N down-line-or-beginning-search
    bindkey "^[[A" up-line-or-beginning-search
    bindkey "^[[B" down-line-or-beginning-search
  '';
}