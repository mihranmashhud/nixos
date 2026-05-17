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
        animations = {
          enabled = "yes";
          bezier = [
            "linear,0,0,1,1"
          ];
          animation = [
            "borderangle, 1, 50, linear, loop"
          ];
        };
        render = {
          direct_scanout = 2;
        };
      };
      window_rule = [
        {
          name = "Deadlock";
          match.class = "^(steam_app_1422450)$";
          fullscreen = "2 2";
          allows_input = true;
          immediate = true;
        }
      ];
      workspace_rule =
        workspaces m1 (map toString (range 1 6))
        ++ workspaces m2 (map toString (range 6 11));
      on = autostart [
        "vesktop"
        "Telegram"
        "openrgb -p 'cool ice'"

        # "hyprctl output create headless" # for sunshine
      ];
    };
  };
}
