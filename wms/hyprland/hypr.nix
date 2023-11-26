{
  config,
  pkgs,
  scripts,
  ...
}: {
  imports = [
    ./programs
  ];

  xdg.configFile."hypr" = {
    source = ./config;
    recursive = true;
  };

  wayland.windowManager.hyprland = with config.colorScheme.colors; {
    enable = true;
    settings = {
      "$inactive_color" = "rgb(${base02})";
      "$active_color" = "rgb(${base0D}) rgb(${base0E}) 45deg";
      general = {
        border_size = 2;
        gaps_in = 4;
        gaps_out = 8;
        "col.inactive_border" = "$inactive_color";
        "col.active_border" = "$active_color";
        "col.nogroup_border" = "$inactive_color";
        "col.nogroup_border_active" = "$active_color";
        cursor_inactive_timeout = 15;
        resize_on_border = true;
        no_cursor_warps = true;
        layout = "dwindle";
      };

      dwindle = {
        force_split = 0;
        no_gaps_when_only = true;
      };

      decoration = {
        rounding = 2;
      };

      input = {
        follow_mouse = 2;
      };

      gestures = {
        workspace_swipe = true;
        workspace_swipe_invert = false;
      };

      misc = {
        disable_hyprland_logo = true;
        mouse_move_focuses_monitor = false;
        mouse_move_enables_dpms = true;
        new_window_takes_over_fullscreen = 1;
      };

      binds = {
        allow_workspace_cycles = true;
      };

      # Startup
      exec-once = let
        before-sleep = builtins.concatStringsSep "; " [
          "${scripts.wayland-lockscreen}/bin/wayland-lockscreen -f"
          "${pkgs.playerctl}/bin/playerctl pause"
        ];
      in [
        # Idle start
        "${pkgs.swayidle}/bin/swayidle -w before-sleep '${before-sleep}' &"
        # Wallpaper
        "swww init"
      ];

      source = [
        "./rules.conf"
        "./binds.conf"
      ];
    };
  };
}
