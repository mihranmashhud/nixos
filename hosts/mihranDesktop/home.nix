{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../home.nix
    ../../wms/hyprland/desktop.nix
  ];
}
