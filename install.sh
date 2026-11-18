#!/usr/bin/env bash
# =============================================================================
# nix-config installer
#
# Applies this flake to a machine that is already running NixOS (fresh
# install or existing system). Home Manager runs as a NixOS module, so one
# system build sets up the user environment and dotfiles too.
#
#   ./install.sh                 # build host "blue-pc", activate on next boot
#   ./install.sh -H mybox        # another host (scaffolds hosts/mybox if new)
#   ./install.sh --switch        # activate immediately instead of next boot
#   ./install.sh --wifi          # also write the WiFi secrets file
#
# From the NixOS installer ISO instead, after partitioning/mounting /mnt:
#   nixos-generate-config --root /mnt --show-hardware-config \
#     > hosts/<host>/hardware-configuration.nix
#   nixos-install --flake .#<host>
# =============================================================================
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST="blue-pc"
ACTION="boot"
WIFI=0
WIFI_SECRETS="/etc/nixos/wireless-secrets"

red()   { printf '\033[31m%s\033[0m\n' "$*"; }
green() { printf '\033[32m%s\033[0m\n' "$*"; }
info()  { printf '\033[34m==>\033[0m %s\n' "$*"; }
die()   { red "error: $*" >&2; exit 1; }
confirm() { read -rp "$1 [y/N] " r; [[ "$r" =~ ^[Yy]$ ]]; }

usage() { sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; exit 0; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    -H|--host)   HOST="${2:?missing host}"; shift 2 ;;
    -s|--switch) ACTION="switch"; shift ;;
    -w|--wifi)   WIFI=1; shift ;;
    -h|--help)   usage ;;
    *) die "unknown option: $1 (see --help)" ;;
  esac
done

[[ $EUID -ne 0 ]] || die "run as your normal user; sudo is used where needed"
[[ -f /etc/NIXOS ]] || die "this isn't NixOS (use nixos-install from the ISO, see header)"
command -v git >/dev/null || die "git is required (nix-shell -p git)"
cd "$REPO"

# Flakes may not be enabled yet on a fresh install.
export NIX_CONFIG="experimental-features = nix-command flakes"

# --- host scaffolding --------------------------------------------------------
hostdir="hosts/$HOST"
if [[ ! -d "$hostdir" ]]; then
  info "New host '$HOST': creating $hostdir"
  mkdir -p "$hostdir"
  cat > "$hostdir/default.nix" <<'EOF'
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
  ];
}
EOF
fi

hw="$hostdir/hardware-configuration.nix"
if [[ ! -f "$hw" ]]; then
  info "Generating $hw"
  sudo nixos-generate-config --show-hardware-config > "$hw"
elif confirm "Regenerate $hw from this machine? (current file is backed up)"; then
  cp "$hw" "$hw.bak.$(date +%s)"
  sudo nixos-generate-config --show-hardware-config > "$hw"
fi

if ! grep -q "nixosConfigurations.$HOST\b\|^\s*$HOST = " flake.nix; then
  red "flake.nix has no nixosConfigurations.$HOST yet. Add one, e.g.:"
  cat <<EOF
      nixosConfigurations.$HOST = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/$HOST ];
        specialArgs = { host = "$HOST"; inherit self inputs username; };
      };
EOF
  exit 1
fi

# --- optional WiFi secrets ---------------------------------------------------
# wpa_supplicant runs unprivileged, so the file must be readable by its group.
if [[ $WIFI -eq 1 ]]; then
  read -rp "WiFi secret name (e.g. psk_TheDuke): " key
  read -rsp "Passphrase: " psk; echo
  sudo install -d -m 755 "$(dirname "$WIFI_SECRETS")"
  printf '%s=%s\n' "$key" "$psk" | sudo tee "$WIFI_SECRETS" >/dev/null
  sudo chown root:wpa_supplicant "$WIFI_SECRETS" 2>/dev/null \
    || red "group wpa_supplicant doesn't exist yet; re-run chown after enabling networking.wireless"
  sudo chmod 640 "$WIFI_SECRETS"
  green "Wrote $WIFI_SECRETS (root:wpa_supplicant 640). Enable it in modules/core/network.nix."
fi

# --- build -------------------------------------------------------------------
# Flakes only see git-tracked files.
git add -A hosts/

info "Building .#$HOST"
nix build --no-link ".#nixosConfigurations.$HOST.config.system.build.toplevel"

info "Activating ($ACTION)"
sudo nixos-rebuild "$ACTION" --flake ".#$HOST"

green "Done."
[[ "$ACTION" == boot ]] && echo "Reboot to start the new system."
echo "Afterwards: rebuild with 'nh os switch .' (or 'nh os boot .' for driver updates)."
