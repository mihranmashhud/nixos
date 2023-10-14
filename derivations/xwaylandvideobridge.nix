{ inputs
, fetchFromGitLab
, fetchpatch
, cmake
, extra-cmake-modules
, pkg-config
, stdenv
, qtbase
, kdelibs4support
, kpipewire
, qtquickcontrols2
, qtx11extras
, wrapQtAppsHook
}:
stdenv.mkDerivation rec {
  name = "xwaylandvideobridge";
  pname = name;

  src = inputs.xwaylandvideobridge;
  patches = [
    ./patches/cursor-mode.patch
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    kdelibs4support
    kpipewire
    qtquickcontrols2
    qtx11extras
  ];
}
