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
          (
            if dmsEnabled
            then [
              # General
              "ALT SHIFT, X, exec, dms ipc call lock lock"
              "CTRL, Grave, exec, dms ipc call notifications toggle"
            ]
            else [
              # General
              "ALT, W, exec, choose-wallpaper"
              "ALT, R, exec, random-wallpaper"
              "ALT SHIFT, X, exec, hyprlock"
              "CTRL, Grave, exec, makoctl restore"
              "CTRL, Space, exec, makoctl dismiss"
              "CTRL SHIFT, Space, exec, makoctl dismiss --all"
            ]
          )
          ++ [
            # General
            "SUPER, B, exec, $BROWSER"
            "SUPER, Space, exec, vicinae toggle"
            "SUPER, Return, exec, kitty -1"

            # Hyprland
            "SUPER, W, killactive"
            "SUPER SHIFT, C, cyclenext, prev"
            "SUPER, C, cyclenext"
            "SUPER, F, togglefloating"
            "SUPER SHIFT, F, fullscreen"
            "SUPER, M, fullscreen, 1" # Monocle mode
            "SUPER, Tab, workspace, previous"
          ]
          # - Move focus
          ++ (map (x: "SUPER, ${elemAt x 0}, movefocus, ${elemAt x 1}") directions)
          # - Move window
          ++ (map (x: "SUPER SHIFT, ${elemAt x 0}, movewindow, ${elemAt x 1}") directions)
          # - Workspaces
          ++ (map (x: "SUPER, ${toString (modulo x 10)}, workspace, ${toString x}") workspaces)
          # - Move window to workspace
          ++ (map (x: "SUPER SHIFT, ${toString (modulo x 10)}, movetoworkspace, ${toString x}") workspaces);
        bindm = [
          "SUPER, mouse:272, movewindow"
        ];
        bindl = [
          "ALT SHIFT, S, exec, systemctl suspend"
          "ALT SHIFT, H, exec, systemctl hibernate"
        ];
        binde =
          if dmsEnabled
          then [
            # Audio
            ",XF86AudioLowerVolume, exec, dms ipc call audio decrement 3"
            ",XF86AudioRaiseVolume, exec, dms ipc call audio increment 3"
            ",XF86AudioMute, exec, dms ipc call audio mute"
            ",XF86AudioMicMute, exec, dms ipc call audio micmute"
            # Brightness
            ",XF86MonBrightnessDown, exec, dms ipc call brightness decrement 5 ''"
            ",XF86MonBrightnessUp, exec, dms ipc call brightness increment 5 ''"
          ]
          else [
            ",XF86AudioLowerVolume, exec, pamixer -d 5"
            ",XF86AudioRaiseVolume, exec, pamixer -i 5"
            ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
            ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
          ];
      };
      extraConfig = with pkgs; ''
        bind = ,Print,submap,capture

        submap = capture

        bind = ,G, exec, ${grimblast}/bin/grimblast --freeze --notify copysave area
        bind = ,G, submap, reset
        bind = ,Print, exec, ${grimblast}/bin/grimblast --freeze --notify copysave active
        bind = ,Print, submap, reset
        bind = ,S, exec, ${grimblast}/bin/grimblast --freeze --notify copysave output
        bind = ,S, submap, reset

        submap = reset
      '';
    };
  };
}
