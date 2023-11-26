{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../home.nix
    ../../wms/hyprland/laptop.nix
  ];
}
