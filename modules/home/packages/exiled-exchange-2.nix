{ pkgs, ... }:

let
  ee2-appimage = pkgs.appimageTools.wrapType2 {
    pname = "exiled-exchange-2";
    version = "0.15.8";
    src = pkgs.fetchurl {
      url = "https://github.com/Kvan7/Exiled-Exchange-2/releases/download/v0.15.8/Exiled-Exchange-2-0.15.8.AppImage";
      hash = "sha256-xmEvKJkRFJokzOa/6qRqT4+QKfnfjIoAfqP+oDqyxH8=";
    };
    meta = {
      description = "Path of Exile 2 trade and price checking tool";
      homepage = "https://github.com/kvan7/Exiled-Exchange-2";
      mainProgram = "exiled-exchange-2";
    };
  };

  # On native Wayland the electron-overlay-window can't toggle click-through
  # (it relies on X11 APIs), so the overlay stays on top and grabs input, and
  # Hyprland blurs the transparent pane. Forcing the app onto XWayland restores
  # click-through. Blur is separately disabled via a Hyprland windowrule.
  # See EE2 issues #794, #788, #115.
  exiled-exchange-2 = pkgs.symlinkJoin {
    name = "exiled-exchange-2";
    paths = [ ee2-appimage ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/exiled-exchange-2 \
        --set XDG_SESSION_TYPE x11 \
        --add-flags "--ozone-platform=x11"
    '';
    inherit (ee2-appimage) meta;
  };
in
{
  home.packages = [ exiled-exchange-2 ];
}
