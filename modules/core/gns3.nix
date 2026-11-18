# GNS3 network simulator
#
# Mirrors the upstream Linux install (docs.gns3.com/docs/getting-started/installation/linux):
# the GUI launches a *local* gns3server as our user, so projects/images live
# in ~/GNS3 and QEMU VMs get /dev/kvm through the user's kvm group. We don't
# use services.gns3-server (a system daemon on :3080) because it would clash
# with the GUI's local server and its ProtectHome hardening hides ~/GNS3.
#
# nixpkgs pins GNS3 to the 2.2 series; we override to 3.x because the
# gns3-mcp server only speaks the v3 API. GUI and server must match versions.
{ pkgs, username, ... }:
let
  gns3Version = "3.0.6";

  gns3-server = pkgs.gns3-server.overridePythonAttrs (old: {
    version = gns3Version;
    src = pkgs.fetchFromGitHub {
      owner = "GNS3";
      repo = "gns3-server";
      tag = "v${gns3Version}";
      hash = "sha256-p5RevZ4XSqQvzzCmjlxYEFdYkzj/GRulJk/K2EvDT1M=";
    };
    # 3.x pins exact versions; nixpkgs' newer releases are API-compatible.
    pythonRelaxDeps = true;
    dependencies = with pkgs.python3Packages; [
      aiofiles
      aiohttp
      aiosqlite
      alembic
      bcrypt
      distro
      email-validator
      fastapi
      greenlet
      jinja2
      joserfc
      platformdirs
      psutil
      py-cpuinfo
      pydantic
      python-multipart
      sentry-sdk
      sqlalchemy
      truststore
      uvicorn
      watchdog
      websockets
      zstandard
    ];
    # nixpkgs' FastAPI dropped add_event_handler; run the same startup and
    # shutdown handlers through the lifespan context instead.
    patches = (old.patches or [ ]) ++ [ ./gns3-server-fastapi-lifespan.patch ];
    # 3.x no longer ships gns3loopback
    postInstall = "";
    # Upstream's test suite targets the pinned deps; skip it
    doCheck = false;
    doInstallCheck = false;
  });

  gns3-gui = pkgs.gns3-gui.overridePythonAttrs (old: {
    version = gns3Version;
    src = pkgs.fetchFromGitHub {
      owner = "GNS3";
      repo = "gns3-gui";
      tag = "v${gns3Version}";
      hash = "sha256-rAD//G7ukIB1KiF/yr8VjjNvOy7TzILznDN+PMi4fII=";
    };
    # The 2.2 test fix is already upstream in 3.x. nixpkgs' PyQt6 rejects the
    # float deltas middle-click panning passes to QScrollBar.setValue.
    patches = [ ./gns3-gui-pan-int.patch ];
    pythonRelaxDeps = true;
    doCheck = false;
    doInstallCheck = false;
  });
in
{
  environment.systemPackages = with pkgs; [
    gns3-gui
    gns3-server
    dynamips  # Cisco IOS router emulator
    vpcs      # Virtual PC simulator
    inetutils # telnet client for node consoles
    winbox4   # MikroTik WinBox (reaches lab nodes over the gns3-oob tap)
  ];

  # ubridge links nodes together and needs raw sockets / TAP access; like the
  # upstream packages, ship it with capabilities, executable by the ubridge group.
  users.groups.ubridge = { };
  security.wrappers.ubridge = {
    capabilities = "cap_net_raw,cap_net_admin=eip";
    group = "ubridge";
    owner = "root";
    permissions = "u=rwx,g=rx,o=r";
    source = "${pkgs.ubridge}/bin/ubridge";
  };

  # Packet capture on GNS3 links
  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  users.users.${username}.extraGroups = [ "ubridge" "wireshark" ];

  # Host leg into a lab's OOB network. A GNS3 Cloud node attaches to this tap
  # (via ubridge), so WinBox/SSH on the desktop reach devices' mgmt ports.
  # 10.190.0.0/24 is the Vozora MCR2 colo lab's OOB range.
  networking.interfaces.gns3-oob = {
    virtual = true;
    virtualType = "tap";
    virtualOwner = username;
    ipv4.addresses = [ { address = "10.190.0.100"; prefixLength = 24; } ];
  };
  networking.dhcpcd.denyInterfaces = [ "gns3-oob" ];
  # WinBox neighbour discovery (MNDP) and MAC-WinBox reply to broadcasts
  # conntrack can't match, so trust the lab-only interface.
  networking.firewall.trustedInterfaces = [ "gns3-oob" ];
}
