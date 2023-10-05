{ inputs
, lib
, stdenv
, fetchFromGitHub
, scdoc
, hyprland
, grim
, slurp
, hyprpicker
, jq
, libnotify
, wl-clipboard
, makeWrapper
, coreutils
,
}:
let
  name = "grimblast";
in
stdenv.mkDerivation {
  pname = name;
  inherit name;

  src = inputs.grimblast;
  nativeBuildInputs = [
    scdoc
    makeWrapper
  ];
  buildPhase = ''
    cd grimblast
    scdoc < grimblast.1.scd > $TMP/grimblast.1
  '';
  installPhase = ''
    install -Dm 644 $TMP/grimblast.1 "$out/share/man/man1/grimblast.1"
    install -Dm 755 $src/grimblast/grimblast "$out/bin/grimblast"
  '';
  postFixup = ''
    wrapProgram $out/bin/grimblast \
      --set PATH ${lib.makeBinPath [
        hyprland
        grim
        slurp
        hyprpicker
        jq
        libnotify
        wl-clipboard
        coreutils
      ]}
  '';
}
