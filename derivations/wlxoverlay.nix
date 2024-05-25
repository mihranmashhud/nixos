{
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 {
  name = "wlxoverlay";
  src = fetchurl {
    url = "https://github.com/galister/WlxOverlay/releases/download/v1.4.5/WlxOverlay-v1.4.5-x86_64.AppImage";
    hash = "sha256-sQfAqxpxVVC2JpPdK0Fcy5UHGnNWG2rJAgBrk2oWnN4=";
  };
  extraPkgs = pkgs:
    with pkgs; [
      icu
    ];
}
