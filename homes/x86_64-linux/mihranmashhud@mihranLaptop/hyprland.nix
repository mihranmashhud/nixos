{
  lib,
  pkgs,
  inputs,
  system,
  config,
  ...
}:
with lib;
with lib.internal;
with lib.internal.hypr; {
  internal.desktop.dms = enabled;
  internal.desktop.hyprland = {
    enable = true;
    type = "laptop";
    settings = {
      monitor = [
        {
          output = "eDP-1";
          mode = "highrr";
          position = "auto";
          scale = 1;
        }
        {
          mode = "preferred";
          postion = "auto";
          scale = 1;
          mirror = "eDP-1";
        }
      ];
    };
    extraConfig =
      autostart
      [
        "vesktop"
        "Telegram"
      ];
  };
}
