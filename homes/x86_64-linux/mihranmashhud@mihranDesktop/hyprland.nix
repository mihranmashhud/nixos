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
    type = "desktop";
    settings = let
      m1 = "desc:Acer Technologies XB253Q TH5AA0038521";
      m2 = "desc:Sceptre Tech Inc Sceptre M24 0x00000001";
    in {
      monitor = [
        {
          output = m1;
          mode = "highrr";
          vrr = 1;
          cm = "auto";
          supports_wide_color = -1;
          supports_hdr = 1;
          sdrbrightness = 1.0;
          sdrsaturation = 1.0;
          sdr_min_luminance = 0.005;
          sdr_max_luminance = 200;
          min_luminance = 0;
          max_luminance = 400;
        }
        {
          output = m2;
          mode = "highrr";
          position = "auto-right";
          vrr = 0;
        }
      ];
      config = {
        general = {
          allow_tearing = true;
        };
        render = {
          direct_scanout = 2;
        };
      };
      window_rule = [
        {
          name = "Deadlock";
          match.class = "^(steam_app_1422450)$";
          fullscreen_state = "2 2";
          allows_input = true;
          immediate = true;
        }
      ];
      workspace_rule =
        monitor_workspaces m1 (map toString (range 1 6))
        ++ monitor_workspaces m2 (map toString (range 6 11));
    };
    extraConfig = mkMerge [
      # lua
      ''
        hl.curve("linear", { type = "bezier", points = {{0.0,0.0},{1.0,1.0}}})
        hl.animation({ leaf = "borderangle", enabled = true, speed = 0.1, bezier = "linear", style = "loop"})
      ''
      (autostart [
        "${pkgs.vesktop}/bin/vesktop"
        "${pkgs.telegram-desktop}/bin/Telegram"
        "${pkgs.openrgb}/bin/openrgb -p 'cool ice'"
      ])
    ];
  };
}
