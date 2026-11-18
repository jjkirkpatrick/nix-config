{ lib, stdenv, fetchurl }:

let
  version = "1.0.5";

  # System detection - map Nix systems to grok's naming conventions
  osName =
    if stdenv.isLinux then "linux"
    else if stdenv.isDarwin then "darwin"
    else throw "Unsupported OS for grok";

  archName =
    if stdenv.isx86_64 then "x86_64"
    else if stdenv.isAarch64 then "arm64"
    else throw "Unsupported architecture for grok";

  platform = "${osName}-${archName}";

  # Hashes for different platforms
  hashes = {
    "linux-x86_64" = "9ba87444e1819e8f6104adbbf4676a870c204380aa5c3e1c38a926c4ea677238";
    "linux-arm64" = ""; # Add when available
    "darwin-x86_64" = ""; # Add when available
    "darwin-arm64" = ""; # Add when available
  };

in

stdenv.mkDerivation {
  pname = "grok-build";
  inherit version;

  src = fetchurl {
    url = "https://x.ai/cli/grok-${version}-${platform}";
    sha256 = hashes."${platform}" or (throw "Unsupported platform: ${platform}");
  };

  # Upstream ships a static-pie binary: no interpreter or shared libs to
  # patch, so it runs without nix-ld. It's already stripped upstream.
  dontUnpack = true;
  dontStrip = true;

  installPhase = ''
    install -Dm755 $src $out/bin/grok
    # Create agent symlink (the binary is the same for both)
    ln -s $out/bin/grok $out/bin/agent
  '';

  meta = with lib; {
    description = "Grok Build - coding agent powered by Grok 4.6";
    homepage = "https://x.ai/cli";
    license = licenses.proprietary;
    platforms = [ "x86_64-linux" ];
    maintainers = [];
  };
}
