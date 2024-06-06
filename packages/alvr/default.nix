{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libva,
  alsa-lib,
  vulkan-loader,
  libvdpau,
  libunwind,
  wayland,
  libGL,
  libxkbcommon,
  openssl,
  x264,
  libdrm,
  ffmpeg,
  brotli,
  xvidcore,
  soxr,
  vulkan-headers,
  bzip2,
  jack2,
  lame,
  xorg,
  libogg,
  libpng,
  libtheora,
}: let
  desktopEntry = ./alvr.desktop;
  icons = ./icons;
in
  stdenv.mkDerivation rec {
    pname = "alvr-latest";
    version = "20.8.0";

    src = fetchurl {
      url = "https://github.com/alvr-org/ALVR/releases/download/v${version}/alvr_streamer_linux.tar.gz";
      hash = "sha256-qEbHFmh0iDv+Pc/w+NF8gehHw47QZ71xjnBl2j8zFiE=";
    };

    nativeBuildInputs = [
      autoPatchelfHook
    ];

    buildInputs = [
      alsa-lib
      libunwind
      libva
      libvdpau
      stdenv.cc.cc
      vulkan-loader
    ];

    runtimeDependencies = [
      brotli
      bzip2
      ffmpeg
      jack2
      lame
      libdrm
      libGL
      libogg
      libpng
      libtheora
      xorg.libX11
      libxkbcommon
      xorg.libXrandr
      openssl
      soxr
      vulkan-headers
      wayland
      x264
      xvidcore
    ];

    sourceRoot = ".";

    installPhase = "
    runHook preInstall

    mkdir $out
    cp -r alvr_streamer_linux/* $out
    install -Dm444 ${desktopEntry} -t $out/share/applications
    cp -r ${icons} $out/share

    runHook postInstall
  ";
  }
