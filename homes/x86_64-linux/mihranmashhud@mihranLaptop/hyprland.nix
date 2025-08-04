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
      monitor = ",highrr,auto,1";
    };
  };
}
