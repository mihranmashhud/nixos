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
      exec-once = [
        "waybar -c ~/.config/waybar/laptop-config.json > /tmp/waybar.log &"
      ];
      monitor = ",highrr,auto,1";
    };
  };
}
