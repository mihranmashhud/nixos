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
let
  name = "xwaylandvideobridge";
in
stdenv.mkDerivation {
  pname = name;
  inherit name;

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
