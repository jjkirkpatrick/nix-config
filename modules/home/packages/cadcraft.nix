{ lib, stdenv, fetchurl, autoPatchelfHook, makeWrapper, gcc-unwrapped
, libGL, libxkbcommon, wayland, vulkan-loader, libx11, libxcursor, libxi, libxrandr, fontconfig }:

let
  # GUI dlopens these at runtime (winit/wgpu-style), so expose them via the wrapper.
  runtimeLibs = lib.makeLibraryPath [ libGL libxkbcommon wayland vulkan-loader libx11 libxcursor libxi libxrandr fontconfig ];
in
stdenv.mkDerivation rec {
  pname = "cadcraft";
  version = "0.5.0";

  src = fetchurl {
    url = "https://github.com/storytold/cadcraft/releases/download/v${version}/cadcraft-${version}-linux-x86_64.tar.gz";
    sha256 = "036c3b401987b6a9991b5fc7ba097d5b717e8d18522f7c3f626b0f6a363e208e";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = [ gcc-unwrapped.lib ];

  installPhase = ''
    mkdir -p $out
    cp -r bin share $out/
    wrapProgram $out/bin/cadcraft --prefix LD_LIBRARY_PATH : ${runtimeLibs}
  '';

  meta.mainProgram = "cadcraft";
}
