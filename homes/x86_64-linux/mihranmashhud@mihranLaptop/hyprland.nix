{
  lib,
  pkgs,
  inputs,
  system,
  config,
  ...
}:
with lib;
with lib.internal; {
  internal.desktop.hyprland = {
    enable = true;
    type = "laptop";
    settings = {
      monitor = [
        "eDP-1,highrr,auto,1"
        ", preferred, auto, 1, mirror, eDP-1"
      ];
    };
  };
}
