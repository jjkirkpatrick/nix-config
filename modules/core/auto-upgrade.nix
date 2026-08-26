# Automatic system upgrade configuration
{ username, ... }:

let
  # Absolute path to this flake's checkout.
  # The upgrade service runs as root with no working directory of its own, so
  # this must be an absolute path to the real repo. It previously pointed at
  # "/etc/nixos", which on this machine holds only a stale configuration.nix
  # and no flake.nix -- every weekly run died with "could not find a flake.nix".
  flakePath = "/home/${username}/nix-config";
in

{
  # Automated NixOS system upgrades
  # NOTE: This only handles NixOS system packages and configuration
  # For comprehensive upgrades including cargo/npm/pip packages, Docker containers,
  # and other system components, use the `topgrade` CLI utility manually
  # Recommended: Run `topgrade` weekly or monthly for complete system maintenance

  # The upgrade service runs as root against a repo owned by ${username}.
  # Without this exemption git treats the checkout as having "dubious ownership"
  # and refuses to read it.
  # Note: programs.git.config only writes /etc/gitconfig when the module is
  # enabled, so this must stay switched on for the exemption below to apply.
  programs.git.enable = true;
  programs.git.config.safe.directory = [ flakePath ];

  system.autoUpgrade = {
    # Enable automatic system upgrades
    enable = true;

    # Upgrade operation type
    # "switch": Apply updates immediately after download
    # "boot": Only apply updates after next reboot (safer for servers)
    #
    # Deliberately "boot": activating a new NVIDIA driver on a running system
    # makes nvidia-container-toolkit-cdi-generator.service fail, which aborts
    # the whole switch and leaves no new generation. Staging for the next boot
    # sidesteps live-activation failures entirely on this machine.
    operation = "boot";

    # Path to the NixOS flake configuration
    flake = flakePath;

    # Additional flags for the upgrade process
    flags = [
      # Build against the latest nixpkgs rather than the pinned lock file
      "--update-input" "nixpkgs"
      # Resolve the updated input in memory only. Without this, root rewrites
      # flake.lock inside ${username}'s repo and the file ends up root-owned,
      # breaking subsequent `nix flake update` runs by the user.
      # (Deliberately NOT --commit-lock-file: root has no git identity
      # configured, so committing would fail and take the upgrade down with it.)
      "--no-write-lock-file"
      # Full build logs in the journal, so failures are diagnosable after the fact
      "--print-build-logs"
    ];

    # Upgrade schedule
    # Options: "daily", "weekly", "monthly", or systemd timer format
    dates = "weekly";

    # Spread the run out so it does not fire the instant the timer elapses
    randomizedDelaySec = "45min";

    # Catch up on a missed run if the machine was powered off at the scheduled time
    persistent = true;

    # Legacy channel-based updates (commented out)
    # Modern flake-based systems use the flake input instead
    # channel = "https://nixos.org/channels/nixos-unstable";
  };
}
