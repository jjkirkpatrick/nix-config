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
  libuuid,
  libxkbcommon,
  nspr,
  nss,
  pango,
  systemd,
  xdg-utils,
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
}:

stdenv.mkDerivation rec {
  pname = "grok-bot";
  version = "0.29.0";

  # Cursor still publishes Linux packages on the CDN even though x.ai/bot
  # only advertises macOS/Windows. Commit is the Linux build id from the
  # AUR grok-bot-bin package / win32 update feed for this version.
  src = fetchurl {
    url = "https://downloads.cursor.com/grokbot/stable/f0e5bfcee649ea84c0c61369cf896cd146d72136/linux/x64/Grok_Bot_${version}.deb";
    hash = "sha256-0iO1gwKCrvEdXEbY9NHt0jm/mS4zZAXL0ojUR2uSM9Q=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
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
    libuuid
    libxkbcommon
    nspr
    nss
    pango
    stdenv.cc.cc
    systemd
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

    mkdir -p $out/opt/grok-bot $out/bin $out/share
    cp -a "opt/Grok Bot/." $out/opt/grok-bot/
    cp -a usr/share/applications $out/share/
    cp -a usr/share/icons $out/share/

    substituteInPlace $out/share/applications/grok-bot.desktop \
      --replace-fail '"/opt/Grok Bot/grok-bot" %U' 'grok-bot %U'

    # chrome-sandbox cannot be SUID in the Nix store; Chromium falls back
    # to user namespaces, which NixOS enables by default.
    chmod 0755 $out/opt/grok-bot/chrome-sandbox

    makeWrapper $out/opt/grok-bot/grok-bot $out/bin/grok-bot \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs}:$out/opt/grok-bot:${addDriverRunpath.driverLink}/lib \
      --prefix XDG_DATA_DIRS : ${gtk3}/share/gsettings-schemas/${gtk3.name} \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --add-flags "\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}"

    runHook postInstall
  '';

  dontStrip = true;

  meta = {
    description = "Grok Bot desktop agent";
    homepage = "https://x.ai/bot";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "grok-bot";
  };
}
