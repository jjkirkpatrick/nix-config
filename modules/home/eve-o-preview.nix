# ======================================================================
# EVE-O PREVIEW (Linux) — live multibox thumbnails
# ======================================================================
# Upstream is a single GTK3/PyGObject script (arsin305/eve-o-preview-linux)
# with no Nix/PyPI packaging, so we wrap it ourselves:
#   - python3 + pygobject3/pycairo for the GObject bindings
#   - GI typelibs (Gtk3, Wnck, GtkLayerShell, gdk-pixbuf) collected by
#     wrapGAppsHook3 from buildInputs
#   - wmctrl + xdotool on PATH for upstream's X11 click-to-focus path
#   - hyprctl on PATH for our Hyprland focus bridge (see the patch below)
#
# EVE clients run under Proton -> XWayland, so they are X11 windows that
# libwnck enumerates fine even on Hyprland (verified: all clients show up).
# GtkLayerShell lets the thumbnail overlays sit above the clients on Wayland.
#
# PATCH: upstream click-to-focus uses wmctrl (a silent no-op on Hyprland)
# and `xdotool windowactivate --sync` (HANGS ~2s on Hyprland, never focuses).
# eve-o-preview-hyprland-focus.patch makes a click drive Hyprland directly
# via `hyprctl dispatch focuswindow pid:<pid>`, which both switches to the
# client's workspace AND focuses it. Falls through to X11 off Hyprland.
#
# Config lives at ~/.config/eve-o-preview-linux/config.json (auto-created
# on first run). NOTE: thumbnail panels default to the SAME position and
# stack on top of each other -- drag them apart once and the positions
# persist there.
#
# Run with:  eve-o-preview
# ======================================================================
{ pkgs, inputs, ... }:
let
  # hyprctl from the SAME flake input as the running compositor (see
  # modules/core/hyperland.nix) so the IPC protocol versions always match.
  hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;

  pythonEnv = pkgs.python3.withPackages (ps: with ps; [ pygobject3 pycairo ]);

  eve-o-preview = pkgs.stdenv.mkDerivation {
    pname = "eve-o-preview-linux";
    version = "0-unstable-2026-06-21";

    src = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/arsin305/eve-o-preview-linux/b450ffe71cd6190d19f780eabd2084888d02ebc3/eve_o_preview_linux.py";
      hash = "sha256-TDM5qvaO4zPApGAdMEOIx1gWCkpYxBlscNW9WfOJVAI=";
    };

    # Single-file source: stage it into the build dir so the patch can apply.
    unpackPhase = ''
      runHook preUnpack
      cp "$src" ./eve_o_preview_linux.py
      chmod +w ./eve_o_preview_linux.py
      runHook postUnpack
    '';
    sourceRoot = ".";

    patches = [ ./eve-o-preview-hyprland-focus.patch ];

    nativeBuildInputs = [ pkgs.wrapGAppsHook3 pkgs.gobject-introspection ];

    buildInputs = [
      pythonEnv
      pkgs.gtk3
      pkgs.libwnck
      pkgs.gtk-layer-shell
      pkgs.gdk-pixbuf
      pkgs.glib
    ];

    installPhase = ''
      runHook preInstall
      install -Dm755 eve_o_preview_linux.py "$out/bin/eve-o-preview"
      patchShebangs "$out/bin/eve-o-preview"
      runHook postInstall
    '';

    # These are runtime-only (the script shells out to them); make them visible
    # to the wrapped binary without dragging them into buildInputs.
    preFixup = ''
      gappsWrapperArgs+=( --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.wmctrl pkgs.xdotool hyprland ]} )
    '';
  };
in
{
  home.packages = [ eve-o-preview ];
}
