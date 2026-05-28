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
          output = "";
          mode = "preferred";
          position = "auto";
          scale = 1;
          mirror = "eDP-1";
        }
      ];
      config = {
        input.touchpad = {
          natural_scroll = true;
        };
      };
    };
    extraConfig =
      autostart
      [
        "vesktop"
        "Telegram"
      ];
  };
}
