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
    type = "desktop";
    settings = let
      m1 = "desc:Acer Technologies XB253Q TH5AA0038521";
      m2 = "desc:Sceptre Tech Inc Sceptre M24 0x00000001";
    in {
      monitor = [
        "${m1}, highrr, 0x0, 1, vrr, 1"
        "${m2}, highrr, 1920x0, 1, vrr, 0"
      ];
      animations = {
        enabled = "yes";
        bezier = [
          "linear,0,0,1,1"
        ];
        animation = [
          "borderangle, 1, 50, linear, loop"
        ];
      };
      windowrulev2 = hypr.windowrules [
        # Deadlock
        {
          windows = ["class:^(steam_app_1422450)$"];
          rules = [
            "fullscreen"
            "allowsinput 1"
          ];
        }
      ];
      workspace =
        hypr.workspaces m1 (map toString (range 1 6))
        ++ hypr.workspaces m2 (map toString (range 6 11));
      exec-once = with pkgs; [
        "[workspace 6 silent] vesktop &"
        "[workspace 10 silent] pwvucontrol &"
        "${kdePackages.xwaylandvideobridge}/bin/.xwaylandvideobridge-wrapped &"
        "openrgb -p 'cool ice' &"
      ];
    };
  };
}
