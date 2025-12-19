{
  lib,
  pkgs,
  inputs,
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  config,
  ...
}:
with lib;
with lib.${namespace}; {
  config = let
    dmsEnabled = config.programs.dankMaterialShell.enable;
  in {
    wayland.windowManager.hyprland = {
      settings = {
        binds.allow_workspace_cycles = true;

        bindd =
          (
            if dmsEnabled
            then [
              # General
              "ALT SHIFT, X, Lock screen, exec, dms ipc call lock lock"
              "CTRL, Grave, Toggle notifications panel, exec, dms ipc call notifications toggle"
            ]
            else [
              # General
              "ALT, W, Choose wallpaper, exec, choose-wallpaper"
              "ALT, R, Random wallpaper, exec, random-wallpaper"
              "ALT SHIFT, X, Lock screen, exec, hyprlock"
              "CTRL, Grave, Restore notification, exec, makoctl restore"
              "CTRL, Space, Dismiss notification, exec, makoctl dismiss"
              "CTRL SHIFT, Space, Dismiss all notifications, exec, makoctl dismiss --all"
            ]
          )
          ++ [
            # General
            "SUPER, B, Open browser, exec, $BROWSER"
            "SUPER, Space, Open launcher, exec, vicinae toggle"
            "SUPER, Return, Open terminal, exec, kitty -1"

            # Hyprland
            "SUPER, W, Close current window, killactive"
            "SUPER SHIFT, C, Cycle to previous window, cyclenext, prev"
            "SUPER, C, Cycle to next window, cyclenext"
            "SUPER, F, Toggle floating, togglefloating"
            "SUPER SHIFT, F, Toggle fullscreen, fullscreen"
            "SUPER, M, Toggle monocle, fullscreen, 1" # Monocle mode
            "SUPER, Tab, Swap to last used workspace, workspace, previous"
          ];
        bind = let
          workspaces = range 1 11;
          directions = [
            ["H" "l"]
            ["Left" "l"]
            ["J" "d"]
            ["Down" "d"]
            ["K" "u"]
            ["Up" "u"]
            ["L" "r"]
            ["Right" "r"]
          ];
        in
          # - Move focus
          (map (x: "SUPER, ${elemAt x 0}, movefocus, ${elemAt x 1}") directions)
          # - Move window
          ++ (map (x: "SUPER SHIFT, ${elemAt x 0}, movewindow, ${elemAt x 1}") directions)
          # - Workspaces
          ++ (map (x: "SUPER, ${toString (modulo x 10)}, workspace, ${toString x}") workspaces)
          # - Move window to workspace
          ++ (map (x: "SUPER SHIFT, ${toString (modulo x 10)}, movetoworkspace, ${toString x}") workspaces);
        bindm = [
          "SUPER, mouse:272, movewindow"
        ];
        binddl = [
          "ALT SHIFT, S, Suspend, exec, systemctl suspend"
          "ALT SHIFT, H, Hibernate, exec, systemctl hibernate"
        ];
        bindde =
          if dmsEnabled
          then [
            # Audio
            ",XF86AudioLowerVolume, Decrease volume, exec, dms ipc call audio decrement 3"
            ",XF86AudioRaiseVolume, Increase volume, exec, dms ipc call audio increment 3"
            ",XF86AudioMute, Mute volume, exec, dms ipc call audio mute"
            ",XF86AudioMicMute, Mute microphone, exec, dms ipc call audio micmute"
            # Brightness
            ",XF86MonBrightnessDown, Increase brightness, exec, dms ipc call brightness decrement 5 ''"
            ",XF86MonBrightnessUp, Decrease brightness, exec, dms ipc call brightness increment 5 ''"
          ]
          else [
            ",XF86AudioLowerVolume, Decrease volume, exec, pamixer -d 5"
            ",XF86AudioRaiseVolume, Increase volume, exec, pamixer -i 5"
            ",XF86MonBrightnessDown, Decrese brightness, exec, brightnessctl set 5%-"
            ",XF86MonBrightnessUp, Increase brightness, exec, brightnessctl set 5%+"
          ];
      };
      extraConfig = with pkgs; ''
        bindd = ,Print, Screenshot, submap,capture

        submap = capture

        bindd = ,G, Screenshot area, exec, ${grimblast}/bin/grimblast --freeze --notify copysave area
        bind = ,G, submap, reset
        bindd = ,Print, Screenshot active window, exec, ${grimblast}/bin/grimblast --freeze --notify copysave active
        bind = ,Print, submap, reset
        bindd = ,S, Screenshot screen, exec, ${grimblast}/bin/grimblast --freeze --notify copysave output
        bind = ,S, submap, reset

        submap = reset
      '';
    };
  };
}
