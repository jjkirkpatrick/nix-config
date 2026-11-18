# Official OpenAI ChatGPT desktop app for Linux (Chat + Work + Codex).
# Packaged from the .deb OpenAI publishes for Ubuntu/Debian; the nixpkgs
# `chatgpt` package is an unofficial repack of the macOS build instead.
#
# To update: bump `version`, then
#   nix hash to-sri --type sha256 $(nix-prefetch-url <url>)
# Current version is listed at
#   https://persistent.oaistatic.com/codex-app-prod/linux/deb/dists/stable/main/binary-amd64/Packages
{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  libappindicator-gtk3,
  libdrm,
  libgbm,
  libnotify,
  libsecret,
  libusb1,
  libuuid,
  libxkbcommon,
  nspr,
  nss,
  pango,
  systemd,
  vulkan-loader,
  xdg-utils,
  xz,
  libx11,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxtst,
  libxcb,
  addDriverRunpath,
  python3,
}:

stdenv.mkDerivation rec {
  pname = "chatgpt-desktop";
  version = "26.901.51231";

  src = fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/pool/main/c/chatgpt/chatgpt_${version}_amd64.deb";
    hash = "sha256-YlgBiNh8PTqTadq3xztCqKMlGNTfii1brmRm3erFwF4=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
    python3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libGL
    libappindicator-gtk3
    libdrm
    libgbm
    libnotify
    libsecret
    libusb1
    libuuid
    libxkbcommon
    nspr
    nss
    pango
    stdenv.cc.cc
    systemd
    vulkan-loader
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxrender
    libxscrnsaver
    libxtst
    libxcb
  ];

  # Qt shims (dlopened only under KDE) and musl-only node prebuilds are
  # never used on glibc NixOS; don't fail the build over them.
  autoPatchelfIgnoreMissingDeps = [
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
    "libQt6Core.so.6"
    "libQt6Gui.so.6"
    "libQt6Widgets.so.6"
    "libc.musl-x86_64.so.1"
  ];

  # libsecret / libnotify are dlopened at runtime (sign-in + notifications).
  runtimeDependencies = [
    libnotify
    libsecret
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/chatgpt $out/bin $out/share/applications $out/share/pixmaps
    cp -a usr/lib/chatgpt/. $out/opt/chatgpt/
    cp -a usr/share/applications/chatgpt.desktop $out/share/applications/
    cp -a usr/share/pixmaps/chatgpt.png $out/share/pixmaps/

    # detect-libc (under @parcel/watcher, loaded by the Codex "git" worker)
    # sniffs the libc family by reading the first 2 KiB of /proc/self/exe for
    # the ELF interpreter, then /usr/bin/ldd, then process.report.getReport().
    # autoPatchelf moves PT_INTERP ~300 MB into the binary and NixOS has no
    # /usr/bin/ldd, so it falls through to getReport(), which SIGILLs inside
    # this Electron build's node-report code and takes the whole app down.
    # Neuter the `if (isLinux())` guards with a same-length replacement so the
    # asar's file offsets stay valid; @parcel/watcher then picks the glibc
    # binding (anything other than MUSL). Asar integrity is not enforced on
    # Linux, so no repack is needed.
    python3 - "$out/opt/chatgpt/resources/app.asar" <<'PY'
    import sys
    path = sys.argv[1]
    old = b"if (isLinux()) {"
    new = b"if (false    ) {"
    assert len(old) == len(new)
    data = open(path, "rb").read()
    n = data.count(old)
    assert n == 4, f"expected 4 detect-libc isLinux() guards, found {n}"
    open(path, "wb").write(data.replace(old, new))
    PY

    # chrome-sandbox cannot be SUID in the Nix store; Chromium falls back
    # to user namespaces, which NixOS enables by default.
    if [ -e $out/opt/chatgpt/chrome-sandbox ]; then
      chmod 0755 $out/opt/chatgpt/chrome-sandbox
    fi

    makeWrapper $out/opt/chatgpt/ChatGPT $out/bin/chatgpt \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}:$out/opt/chatgpt:${addDriverRunpath.driverLink}/lib \
      --prefix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name} \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils xz ]} \
      --add-flags "\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}"

    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "ChatGPT desktop app for Linux (Chat, Work, Codex)";
    homepage = "https://developers.openai.com/codex/app";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "chatgpt";
  };
}
