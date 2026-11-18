# Detuks OSRS client - AppImage bundling its own (WoW64) wine-tkg + launcher.exe.
# Not on a public URL; add the downloaded file to the store first:
#   nix-store --add-fixed sha256 ~/Downloads/DetuksClient-x86_64.AppImage
{ appimageTools, requireFile }:
let
  pname = "detuks-client";
  version = "unstable-2026-11-06";
  src = requireFile {
    name = "DetuksClient-x86_64.AppImage";
    hash = "sha256-1kQScHaycUa2YNbR5SK4QElmc0W+nXMJzNiMAM+82XU=";
    message = "nix-store --add-fixed sha256 ~/Downloads/DetuksClient-x86_64.AppImage";
  };
  contents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;
  # Wine needs to write into the game process; breaks inside a separate PID namespace
  unsharePid = false;
  # Wine's schannel needs gnutls, or the game fails with "Error connecting to server"
  extraPkgs = pkgs: [ pkgs.gnutls ];
  extraInstallCommands = ''
    install -Dm444 ${contents}/detuks-client.desktop $out/share/applications/detuks-client.desktop
    install -Dm444 ${contents}/detuks-client.png $out/share/pixmaps/detuks-client.png
    substituteInPlace $out/share/applications/detuks-client.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=detuks-client' \
      --replace-fail 'Name=BotClient' 'Name=Detuks Client'
  '';
  meta.mainProgram = "detuks-client";
}
