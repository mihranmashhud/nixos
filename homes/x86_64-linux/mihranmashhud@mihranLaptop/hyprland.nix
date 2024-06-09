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
      misc = {
        vfr = true;
      };
      monitor = ",highrr,auto,1";
    };
  };
}
