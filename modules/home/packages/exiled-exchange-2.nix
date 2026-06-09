{ pkgs, ... }:

let
  exiled-exchange-2 = pkgs.appimageTools.wrapType2 {
    pname = "exiled-exchange-2";
    version = "0.13.10";
    src = pkgs.fetchurl {
      url = "https://github.com/kvan7/Exiled-Exchange-2/releases/download/v0.13.10/Exiled-Exchange-2-0.13.10.AppImage";
      hash = "sha256-mQNUJptaObbEMtBLCgJn7A6nmgVpl4o0JWTg6FH20U0=";
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
