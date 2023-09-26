{
  fetchFromGitLab,
  fetchpatch,
  cmake,
  extra-cmake-modules,
  pkg-config,
  stdenv,
  qtbase,
  kdelibs4support,
  kpipewire,
  qtquickcontrols2,
  qtx11extras,
  wrapQtAppsHook
}: 
let
  name = "xwaylandvideobridge";
in
stdenv.mkDerivation {
  pname = name;
  inherit name;

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "system";
    repo = "xwaylandvideobridge";
    rev = "1b5c5d3dc7e3110592469ceda459ff8ef6610e22";
    hash = "sha256-r3rUcVQhyN/13gRPpmhaKtrnchd3aHTnX3SMJG5+8iI=";
  };

  patches = [
    (fetchpatch {
      name = "cursor-mode.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/cursor-mode.patch?h=xwaylandvideobridge-cursor-mode-2-git";
      hash = "sha256-649kCs3Fsz8VCgGpZ952Zgl8txAcTgakLoMusaJQYa4=";
      stripLen = 1;
    })
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
