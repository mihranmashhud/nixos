{
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 {
  name = "wlxoverlay";
  src = fetchurl {
    url = "https://github.com/galister/WlxOverlay/releases/download/v1.4.1/WlxOverlay-v1.4.1-x86_64.AppImage";
    hash = "sha256-/NXI/6c4lZxgFXx+/y3UQPa14rNI1pAvkBTQilO/mlE=";
  };
  extraPkgs = pkgs:
    with pkgs; [
      icu
    ];
}
