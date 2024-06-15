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
      m1 = "DP-1";
      m2 = "DP-2";
    in {
      monitor = [
        "${m1}, highrr, 0x0, 1, vrr, 1"
        "${m2}, highrr, 1920x0, 1, vrr, 0"
      ];
      misc.vrr = 1;
      animations = {
        enabled = "yes";
        bezier = [
          "linear,0,0,1,1"
        ];
        animation = [
          "borderangle, 1, 50, linear, loop"
        ];
      };
      workspace =
        hypr.workspaces m1 (map toString (range 1 6))
        ++ hypr.workspaces m2 (map toString (range 6 11));
      exec-once = with pkgs; [
        "[workspace 6 silent] vesktop &"
        "[workspace 10 silent] obs --startreplaybuffer --minimize-to-tray &"
        "[workspace 10 silent] pavucontrol &"
        "${xwaylandvideobridge}/bin/.xwaylandvideobridge-wrapped &"
        "openrgb -p 'cool ice' &"
      ];

      bind = [
        ",F10,exec,obs-cli --password $(cat ~/.config/obs-studio/password) replaybuffer save"
      ];
    };
  };
}
