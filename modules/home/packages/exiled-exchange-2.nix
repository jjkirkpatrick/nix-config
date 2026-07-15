{ pkgs, ... }:

let
  exiled-exchange-2 = pkgs.appimageTools.wrapType2 {
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
in
{
  home.packages = [ exiled-exchange-2 ];
}
