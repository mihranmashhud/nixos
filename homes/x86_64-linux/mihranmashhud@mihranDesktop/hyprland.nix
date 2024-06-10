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
    settings = {
      monitor = [
        "DP-2, highrr, 0x0, 1, vrr, 1"
        "DP-1, highrr, 1920x0, 1, vrr, 0"
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
        hypr.workspaces "DP-2" (map toString (range 1 6))
        ++ hypr.workspaces "DP-1" (map toString (range 5 11));
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
