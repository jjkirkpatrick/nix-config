{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    # ZSH options
    history = {
      size = 10000;
      save = 10000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
    };

    # Shell options
    defaultKeymap = "emacs";
    
    # Environment variables
    sessionVariables = {
      EDITOR = "nvim";
      BROWSER = "brave";
      TERMINAL = "kitty";
    };

    # Shell aliases
    shellAliases = {
      # Better defaults
      ls = "eza --color=auto --group-directories-first";
      ll = "eza -la --color=auto --group-directories-first";
      tree = "eza --tree";
      cat = "bat";
      grep = "rg";
      find = "fd";
      
      # Git shortcuts
      g = "git";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gs = "git status";
      gd = "git diff";
      
      # System shortcuts
      rebuild = "sudo nixos-rebuild switch --flake ~/repos/nix-config#blue-pc";
      home-rebuild = "home-manager switch --flake ~/repos/nix-config#josh";
      
      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      
      # Misc
      h = "history";
      c = "clear";
      q = "exit";
    };

    # ZSH plugins
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
        file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
        file = "share/zsh-completions/zsh-completions.plugin.zsh";
      }
    ];

    # Additional ZSH configuration
    initExtra = ''
      # Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Custom functions
      function mkcd() {
        mkdir -p "$1" && cd "$1"
      }

      function extract() {
        if [ -f $1 ] ; then
          case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      }

      # Better cd with zoxide
      eval "$(zoxide init zsh)"

      # FZF integration
      eval "$(fzf --zsh)"

      # Direnv integration
      eval "$(direnv hook zsh)"

      # ZSH options
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_SILENT
      setopt CORRECT
      setopt CDABLE_VARS
      setopt EXTENDED_GLOB
      setopt NO_CASE_GLOB
      setopt NUMERIC_GLOB_SORT
      setopt RC_EXPAND_PARAM

      # Key bindings
      bindkey '^[[1;5C' forward-word                    # Ctrl+Right
      bindkey '^[[1;5D' backward-word                   # Ctrl+Left
      bindkey '^[[3~' delete-char                       # Delete
      bindkey '^[[H' beginning-of-line                  # Home
      bindkey '^[[F' end-of-line                        # End

      # Load Powerlevel10k config
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  # Powerlevel10k configuration
  home.file.".p10k.zsh".text = ''
    # Powerlevel10k configuration file
    'builtin' 'local' '-a' 'p10k_config_opts'
    [[ -o 'aliases'         ]] && p10k_config_opts+=('aliases')
    [[ -o 'sh_glob'         ]] && p10k_config_opts+=('sh_glob')
    [[ -o 'no_brace_expand' ]] && p10k_config_opts+=('no_brace_expand')
    'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

    () {
      emulate -L zsh -o extended_glob

      # Unset all configuration options.
      unset POWERLEVEL9K_*

      # Zsh >= 5.1 is required.
      autoload -Uz is-at-least && is-at-least 5.1 || return

      # Prompt style: lean, classic, rainbow, pure
      typeset -g POWERLEVEL9K_MODE=nerdfont-complete
      typeset -g POWERLEVEL9K_ICON_PADDING=none

      # Basic prompt elements
      typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
        os_icon
        dir
        vcs
        prompt_char
      )

      typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
        status
        command_execution_time
        background_jobs
        direnv
        asdf
        virtualenv
        anaconda
        pyenv
        goenv
        nodenv
        nvm
        nodeenv
        node_version
        go_version
        rust_version
        dotnet_version
        php_version
        laravel_version
        java_version
        package
        rbenv
        rvm
        fvm
        luaenv
        jenv
        plenv
        phpenv
        scalaenv
        haskell_stack
        kubecontext
        terraform
        aws
        aws_eb_env
        azure
        gcloud
        google_app_cred
        context
        nordvpn
        ranger
        nnn
        vim_shell
        midnight_commander
        nix_shell
        todo
        timewarrior
        taskwarrior
        time
      )

      # OS icon
      typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND=232
      typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND=7

      # Directory
      typeset -g POWERLEVEL9K_DIR_FOREGROUND=31
      typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=103
      typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=39
      typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
      typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
      typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
      typeset -g POWERLEVEL9K_DIR_MAX_LENGTH=80
      typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS=40
      typeset -g POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT=50
      typeset -g POWERLEVEL9K_DIR_HYPERLINK=false

      # VCS (Git)
      typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
      typeset -g POWERLEVEL9K_VCS_UNTRACKED_ICON='?'

      # Prompt character
      typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=76
      typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=196
      typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
      typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
      typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
      typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
      typeset -g POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE=true
      typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''

      # Command execution time
      typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=3
      typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=0
      typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT='d h m s'

      # Status
      typeset -g POWERLEVEL9K_STATUS_EXTENDED_STATES=true
      typeset -g POWERLEVEL9K_STATUS_OK=false
      typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=70
      typeset -g POWERLEVEL9K_STATUS_OK_VISUAL_IDENTIFIER_EXPANSION='✓'
      typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=160
      typeset -g POWERLEVEL9K_STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION='✗'

      # Time
      typeset -g POWERLEVEL9K_TIME_FOREGROUND=66
      typeset -g POWERLEVEL9K_TIME_FORMAT='%D{%H:%M:%S}'

      # Nix shell
      typeset -g POWERLEVEL9K_NIX_SHELL_FOREGROUND=74

      # Transient prompt
      typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose

      # Multiline prompt
      typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
      typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=''
      typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX=''
      typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=''
      typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_SUFFIX=''
      typeset -g POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_SUFFIX=''
      typeset -g POWERLEVEL9K_MULTILINE_LAST_PROMPT_SUFFIX=''

      # Instant prompt mode
      typeset -g POWERLEVEL9K_INSTANT_PROMPT=verbose
      typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true
    }

    (( \${#p10k_config_opts} )) && setopt \${p10k_config_opts[@]}
    'builtin' 'unset' 'p10k_config_opts'
  '';
}