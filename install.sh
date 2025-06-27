#!/usr/bin/env bash

# NixOS Configuration Installer
# Comprehensive installation script for NixOS with Hyprland

set -euo pipefail

# =============================================================================
# CONFIGURATION & VARIABLES
# =============================================================================

# Default values
DEFAULT_USERNAME="josh"
DEFAULT_HOSTNAME="blue-pc"
CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
declare -A COLORS=(
    [NORMAL]=$(tput sgr0 2>/dev/null || echo "")
    [WHITE]=$(tput setaf 7 2>/dev/null || echo "")
    [RED]=$(tput setaf 1 2>/dev/null || echo "")
    [GREEN]=$(tput setaf 2 2>/dev/null || echo "")
    [YELLOW]=$(tput setaf 3 2>/dev/null || echo "")
    [BLUE]=$(tput setaf 4 2>/dev/null || echo "")
    [MAGENTA]=$(tput setaf 5 2>/dev/null || echo "")
    [CYAN]=$(tput setaf 6 2>/dev/null || echo "")
    [BRIGHT]=$(tput bold 2>/dev/null || echo "")
)

# Global variables
USERNAME=""
HOSTNAME=""
INSTALL_MODE=""
SKIP_WALLPAPERS=false
SKIP_BUILD=false
DRY_RUN=false

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

log() {
    local level="$1"
    shift
    local color_key=""
    case "$level" in
        INFO) color_key="BLUE" ;;
        SUCCESS) color_key="GREEN" ;;
        WARNING) color_key="YELLOW" ;;
        ERROR) color_key="RED" ;;
        HEADER) color_key="CYAN" ;;
        *) color_key="NORMAL" ;;
    esac
    echo -e "${COLORS[$color_key]}[$level]${COLORS[NORMAL]} $*"
}

confirm() {
    local prompt="${1:-Continue?}"
    echo -en "${COLORS[YELLOW]}$prompt${COLORS[NORMAL]} [${COLORS[GREEN]}y${COLORS[NORMAL]}/${COLORS[RED]}n${COLORS[NORMAL]}]: "
    read -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

check_root() {
    if [[ $EUID -eq 0 ]]; then
        log "ERROR" "This script should NOT be run as root!"
        log "INFO" "Run it as a regular user with sudo access."
        exit 1
    fi
}

check_nixos() {
    if [[ ! -f /etc/os-release ]] || ! grep -q "NixOS" /etc/os-release; then
        log "ERROR" "This script is designed for NixOS systems only!"
        exit 1
    fi
}

check_dependencies() {
    local deps=("git" "nix" "sudo")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log "ERROR" "Missing required dependencies: ${missing[*]}"
        exit 1
    fi
}

# =============================================================================
# CONFIGURATION FUNCTIONS
# =============================================================================

print_banner() {
    log "HEADER" "
╔════════════════════════════════════════════════════════════════╗
║                    NixOS Configuration Installer               ║
║                                                                ║
║  This script will help you set up your NixOS configuration    ║
║  with Hyprland, home-manager, and all required components.    ║
║                                                                ║
║  ${COLORS[RED]}WARNING: Do NOT run this script as root!${COLORS[NORMAL]}                    ║
╚════════════════════════════════════════════════════════════════╝
"
}

show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

OPTIONS:
    -h, --help              Show this help message
    -u, --username USER     Set username (default: $DEFAULT_USERNAME)
    -H, --hostname HOST     Set hostname (default: $DEFAULT_HOSTNAME)
    -m, --mode MODE         Installation mode: full, update, wallpapers-only
    --skip-wallpapers       Skip wallpaper installation
    --skip-build            Skip system build (configuration only)
    --dry-run               Show what would be done without executing
    -i, --interactive       Interactive mode (default)

MODES:
    full                    Complete installation (default)
    update                  Update existing configuration
    wallpapers-only         Only install wallpapers

EXAMPLES:
    $0                                  # Interactive installation
    $0 -u myuser -H myhost             # Non-interactive with custom user/host
    $0 -m update                       # Update existing configuration
    $0 --skip-wallpapers               # Install without wallpapers
    $0 --dry-run                       # Preview changes

EOF
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -u|--username)
                USERNAME="$2"
                shift 2
                ;;
            -H|--hostname)
                HOSTNAME="$2"
                shift 2
                ;;
            -m|--mode)
                INSTALL_MODE="$2"
                case "$INSTALL_MODE" in
                    full|update|wallpapers-only) ;;
                    *) log "ERROR" "Invalid mode: $INSTALL_MODE"; exit 1 ;;
                esac
                shift 2
                ;;
            --skip-wallpapers)
                SKIP_WALLPAPERS=true
                shift
                ;;
            --skip-build)
                SKIP_BUILD=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            -i|--interactive)
                # Default behavior, just consume the flag
                shift
                ;;
            *)
                log "ERROR" "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

get_user_input() {
    # Skip if already provided via arguments
    if [[ -n "$USERNAME" && -n "$HOSTNAME" && -n "$INSTALL_MODE" ]]; then
        return 0
    fi

    log "INFO" "Starting interactive configuration..."

    # Get username
    if [[ -z "$USERNAME" ]]; then
        echo -en "${COLORS[CYAN]}Enter username${COLORS[NORMAL]} (default: ${COLORS[YELLOW]}$DEFAULT_USERNAME${COLORS[NORMAL]}): "
        read -r input_username
        USERNAME="${input_username:-$DEFAULT_USERNAME}"
    fi

    # Get hostname
    if [[ -z "$HOSTNAME" ]]; then
        echo -en "${COLORS[CYAN]}Enter hostname${COLORS[NORMAL]} (default: ${COLORS[YELLOW]}$DEFAULT_HOSTNAME${COLORS[NORMAL]}): "
        read -r input_hostname
        HOSTNAME="${input_hostname:-$DEFAULT_HOSTNAME}"
    fi

    # Get installation mode
    if [[ -z "$INSTALL_MODE" ]]; then
        echo -e "\n${COLORS[CYAN]}Select installation mode:${COLORS[NORMAL]}"
        echo "  1) Full installation (recommended)"
        echo "  2) Update existing configuration"
        echo "  3) Wallpapers only"
        echo -en "\nChoice [${COLORS[YELLOW]}1${COLORS[NORMAL]}]: "
        read -r mode_choice
        
        case "${mode_choice:-1}" in
            1) INSTALL_MODE="full" ;;
            2) INSTALL_MODE="update" ;;
            3) INSTALL_MODE="wallpapers-only" ;;
            *) log "ERROR" "Invalid choice"; exit 1 ;;
        esac
    fi

    # Confirm settings
    echo -e "\n${COLORS[CYAN]}Configuration Summary:${COLORS[NORMAL]}"
    echo "  Username: ${COLORS[YELLOW]}$USERNAME${COLORS[NORMAL]}"
    echo "  Hostname: ${COLORS[YELLOW]}$HOSTNAME${COLORS[NORMAL]}"
    echo "  Mode: ${COLORS[YELLOW]}$INSTALL_MODE${COLORS[NORMAL]}"
    echo "  Skip wallpapers: ${COLORS[YELLOW]}$SKIP_WALLPAPERS${COLORS[NORMAL]}"
    echo "  Skip build: ${COLORS[YELLOW]}$SKIP_BUILD${COLORS[NORMAL]}"
    echo "  Dry run: ${COLORS[YELLOW]}$DRY_RUN${COLORS[NORMAL]}"
    
    echo
    if ! confirm "Proceed with these settings?"; then
        log "INFO" "Installation cancelled by user."
        exit 0
    fi
}

validate_configuration() {
    # Check if hostname configuration exists
    local host_dir="$CONFIG_DIR/hosts/$HOSTNAME"
    if [[ ! -d "$host_dir" ]]; then
        log "WARNING" "Host configuration '$HOSTNAME' does not exist."
        log "INFO" "Available hosts:"
        for host in "$CONFIG_DIR/hosts"/*; do
            if [[ -d "$host" ]]; then
                echo "  - $(basename "$host")"
            fi
        done
        
        if confirm "Create new host configuration for '$HOSTNAME'?"; then
            create_host_configuration
        else
            exit 1
        fi
    fi

    # Validate flake.nix contains the hostname
    if ! grep -q "\"$HOSTNAME\"" "$CONFIG_DIR/flake.nix"; then
        log "WARNING" "Hostname '$HOSTNAME' not found in flake.nix"
        if confirm "Add '$HOSTNAME' to flake.nix?"; then
            update_flake_nix
        fi
    fi
}

create_host_configuration() {
    local host_dir="$CONFIG_DIR/hosts/$HOSTNAME"
    log "INFO" "Creating host configuration for '$HOSTNAME'..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log "INFO" "[DRY RUN] Would create: $host_dir"
        return 0
    fi

    mkdir -p "$host_dir"
    
    # Copy default.nix from blue-pc as template
    cp "$CONFIG_DIR/hosts/blue-pc/default.nix" "$host_dir/default.nix"
    
    # Copy hardware configuration if it exists
    if [[ -f /etc/nixos/hardware-configuration.nix ]]; then
        cp /etc/nixos/hardware-configuration.nix "$host_dir/hardware-configuration.nix"
        log "SUCCESS" "Copied hardware configuration"
    else
        log "WARNING" "No hardware configuration found at /etc/nixos/hardware-configuration.nix"
        log "INFO" "You may need to run 'nixos-generate-config' first"
    fi
}

update_flake_nix() {
    log "INFO" "Updating flake.nix with hostname '$HOSTNAME'..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log "INFO" "[DRY RUN] Would update flake.nix with hostname '$HOSTNAME'"
        return 0
    fi

    # Create backup
    cp "$CONFIG_DIR/flake.nix" "$CONFIG_DIR/flake.nix.backup"
    
    # Add hostname to nixosConfigurations
    local temp_file=$(mktemp)
    awk -v hostname="$HOSTNAME" '
    /nixosConfigurations = {/ {
        print $0
        getline
        print $0
        # Add new host configuration
        print "      " hostname " = nixpkgs.lib.nixosSystem {"
        print "        inherit system;"
        print "        modules = [ ./hosts/" hostname " ];"
        print "        specialArgs = {"
        print "          host = \"" hostname "\";"
        print "          inherit self inputs username;"
        print "        };"
        print "      };"
        next
    }
    { print }
    ' "$CONFIG_DIR/flake.nix" > "$temp_file"
    
    mv "$temp_file" "$CONFIG_DIR/flake.nix"
    log "SUCCESS" "Updated flake.nix"
}

update_username_in_config() {
    if [[ "$USERNAME" == "$DEFAULT_USERNAME" ]]; then
        log "INFO" "Username matches default, no changes needed"
        return 0
    fi

    log "INFO" "Updating username from '$DEFAULT_USERNAME' to '$USERNAME' in configuration..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log "INFO" "[DRY RUN] Would update username in flake.nix"
        return 0
    fi

    # Update flake.nix
    sed -i "s/username = \"$DEFAULT_USERNAME\"/username = \"$USERNAME\"/g" "$CONFIG_DIR/flake.nix"
    
    log "SUCCESS" "Updated username in configuration"
}

# =============================================================================
# INSTALLATION FUNCTIONS
# =============================================================================

setup_directories() {
    log "INFO" "Setting up directories..."
    
    local dirs=(
        "$HOME/Pictures/wallpapers"
        "$HOME/.config"
        "$HOME/.local/bin"
    )
    
    for dir in "${dirs[@]}"; do
        if [[ "$DRY_RUN" == true ]]; then
            log "INFO" "[DRY RUN] Would create directory: $dir"
        else
            mkdir -p "$dir"
            log "SUCCESS" "Created directory: $dir"
        fi
    done
}

install_wallpapers() {
    if [[ "$SKIP_WALLPAPERS" == true ]]; then
        log "INFO" "Skipping wallpaper installation"
        return 0
    fi

    log "INFO" "Installing wallpapers..."
    
    local wallpaper_src="$CONFIG_DIR/wallpapers"
    local wallpaper_dest="$HOME/Pictures/wallpapers"
    
    if [[ ! -d "$wallpaper_src" ]]; then
        log "WARNING" "Wallpaper source directory not found: $wallpaper_src"
        return 0
    fi

    if [[ "$DRY_RUN" == true ]]; then
        log "INFO" "[DRY RUN] Would copy wallpapers from $wallpaper_src to $wallpaper_dest"
        return 0
    fi

    # Copy wallpapers
    cp -r "$wallpaper_src"/* "$wallpaper_dest/"
    log "SUCCESS" "Wallpapers installed to $wallpaper_dest"
}

backup_existing_config() {
    local backup_dir="$HOME/.config/nixos-backup-$(date +%Y%m%d_%H%M%S)"
    
    if [[ -f "$HOME/.config/nixos" ]] || [[ -d "$HOME/.config/nixos" ]]; then
        if [[ "$DRY_RUN" == true ]]; then
            log "INFO" "[DRY RUN] Would backup existing config to: $backup_dir"
        else
            mv "$HOME/.config/nixos" "$backup_dir"
            log "SUCCESS" "Backed up existing config to: $backup_dir"
        fi
    fi
}

build_system() {
    if [[ "$SKIP_BUILD" == true ]]; then
        log "INFO" "Skipping system build"
        return 0
    fi

    log "INFO" "Building NixOS system configuration..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log "INFO" "[DRY RUN] Would run: sudo nixos-rebuild switch --flake .#$HOSTNAME"
        return 0
    fi

    # Build the system
    if ! sudo nixos-rebuild switch --flake "$CONFIG_DIR#$HOSTNAME"; then
        log "ERROR" "System build failed!"
        log "INFO" "Check the error messages above for details."
        log "INFO" "You can try building manually with:"
        log "INFO" "  cd $CONFIG_DIR && sudo nixos-rebuild switch --flake .#$HOSTNAME"
        return 1
    fi

    log "SUCCESS" "System build completed successfully!"
}

build_home_manager() {
    if [[ "$SKIP_BUILD" == true ]]; then
        log "INFO" "Skipping home-manager build"
        return 0
    fi

    log "INFO" "Building home-manager configuration..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log "INFO" "[DRY RUN] Would run: home-manager switch --flake .#$USERNAME"
        return 0
    fi

    # Build home-manager configuration
    if command -v home-manager &> /dev/null; then
        if ! home-manager switch --flake "$CONFIG_DIR#$USERNAME"; then
            log "WARNING" "Home-manager build failed, but continuing..."
            log "INFO" "You can build it manually later with:"
            log "INFO" "  cd $CONFIG_DIR && home-manager switch --flake .#$USERNAME"
        else
            log "SUCCESS" "Home-manager build completed successfully!"
        fi
    else
        log "INFO" "Home-manager not available yet, will be installed with system build"
    fi
}

enable_flakes() {
    log "INFO" "Ensuring Nix flakes are enabled..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log "INFO" "[DRY RUN] Would ensure flakes are enabled"
        return 0
    fi

    # Check if flakes are already enabled
    if nix show-config | grep -q "experimental-features.*flakes"; then
        log "SUCCESS" "Nix flakes already enabled"
        return 0
    fi

    # Enable flakes temporarily for this build
    export NIX_CONFIG="experimental-features = nix-command flakes"
    log "SUCCESS" "Enabled Nix flakes for this session"
}

# =============================================================================
# MAIN INSTALLATION LOGIC
# =============================================================================

run_full_installation() {
    log "HEADER" "Starting full installation..."
    
    enable_flakes
    setup_directories
    install_wallpapers
    backup_existing_config
    update_username_in_config
    validate_configuration
    
    if confirm "Ready to build the system. This may take a while. Continue?"; then
        build_system
        build_home_manager
    else
        log "INFO" "System build skipped. You can build manually later."
    fi
}

run_update_installation() {
    log "HEADER" "Starting configuration update..."
    
    enable_flakes
    update_username_in_config
    validate_configuration
    
    if confirm "Ready to rebuild the system with updates. Continue?"; then
        build_system
        build_home_manager
    else
        log "INFO" "System rebuild skipped."
    fi
}

run_wallpapers_only() {
    log "HEADER" "Installing wallpapers only..."
    
    setup_directories
    install_wallpapers
    
    log "SUCCESS" "Wallpapers installation completed!"
}

post_installation_info() {
    if [[ "$DRY_RUN" == true ]]; then
        log "INFO" "Dry run completed. No changes were made."
        return 0
    fi

    log "HEADER" "Installation completed!"
    echo
    log "INFO" "Next steps:"
    echo "  1. Reboot your system to ensure all changes take effect"
    echo "  2. Log in and verify Hyprland starts correctly"
    echo "  3. Check waybar and other components are working"
    echo
    log "INFO" "Useful commands:"
    echo "  - Rebuild system: sudo nixos-rebuild switch --flake $CONFIG_DIR#$HOSTNAME"
    echo "  - Rebuild home config: home-manager switch --flake $CONFIG_DIR#$USERNAME"
    echo "  - Update flake inputs: nix flake update"
    echo
    log "INFO" "Configuration location: $CONFIG_DIR"
    log "INFO" "Wallpapers installed to: $HOME/Pictures/wallpapers"
    echo
    log "SUCCESS" "Enjoy your new NixOS setup with Hyprland! 🚀"
}

# =============================================================================
# MAIN FUNCTION
# =============================================================================

main() {
    # Parse command line arguments
    parse_arguments "$@"
    
    # Initial checks
    check_root
    check_nixos
    check_dependencies
    
    # Show banner
    print_banner
    
    # Get configuration
    get_user_input
    
    # Set defaults if not provided
    USERNAME="${USERNAME:-$DEFAULT_USERNAME}"
    HOSTNAME="${HOSTNAME:-$DEFAULT_HOSTNAME}"
    INSTALL_MODE="${INSTALL_MODE:-full}"
    
    # Run installation based on mode
    case "$INSTALL_MODE" in
        full)
            run_full_installation
            ;;
        update)
            run_update_installation
            ;;
        wallpapers-only)
            run_wallpapers_only
            ;;
        *)
            log "ERROR" "Unknown installation mode: $INSTALL_MODE"
            exit 1
            ;;
    esac
    
    # Show completion info
    post_installation_info
}

# =============================================================================
# SCRIPT EXECUTION
# =============================================================================

# Only run main if script is executed directly (not sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi