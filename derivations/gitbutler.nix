{
  appimageTools,
  inputs,
}:
appimageTools.wrapType2 {
  name = "gitbutler";
  src = inputs.gitbutler;
  extraPkgs = pkgs:
    with pkgs; [
      libsoup
      webkitgtk
      glib-networking
    ];
}
