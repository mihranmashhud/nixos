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
with lib.${namespace}; let
  cfg = config.${namespace}.desktop.hyprland;
in {
  options.${namespace}.desktop.hyprland = {
    enable = mkBoolOpt false "Whether to enable hyprland configuration. Includes everything required to feel like a desktop environment.";
    type = mkOpt (types.enum ["desktop" "laptop"]) "desktop" "Whether this is a desktop or laptop.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
    with pkgs.${namespace}; [
      wl-clipboard
      cliphist
      swww
      libnotify
      hyprkeys
      xwaylandvideobridge
      wdisplays
      choose-wallpaper
      random-wallpaper
      grimblast
      pavucontrol
    ];

    services.displayManager = {
      sddm.wayland.enable = true;
      sddm.enable = true;
    };

    ${namespace} = {
      nix.extra-substituters = [
        {
          url = "https://hyprland.cachix.org";
          key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
        }
      ];

      apps = {
        waybar = enabled;
        mako = enabled;
        wlogout = enabled;
        rofi = enabled;
      };

      polkit = enabled;

      home.extraOptions = {
        wayland.windowManager.hyprland = with config.stylix.base16Scheme; {
          enable = true;

          settings = let
            inactive_color = "rgb(${base02})";
            active_color = "rgb(${base0D}) rgb(${base0E}) 45deg";
          in {
            general = {
              border_size = 2;
              gaps_in = 4;
              gaps_out = 8;
              "col.inactive_border" = inactive_color;
              "col.active_border" = active_color;
              "col.nogroup_border" = inactive_color;
              "col.nogroup_border_active" = active_color;
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
              kb_layout = "us,ara";
              kb_options = "grp:ctrls_toggle";
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
            exec-once = [
              # Wallpaper
              "swww init"
              # Top bar
              "waybar -c ~/.config/waybar/${cfg.type}-config.json"
            ];

            windowrulev2 = hypr.windowrules [
              {
                windows = [
                  "class:^(discord)$"
                  "class:^(Slack)$"
                  "class:^(org.telegram.desktop)$"
                ];
                rules = ["workspace 6"];
              }
              {
                windows = ["class:^(pavucontrol)$"];
                rules = ["workspace 10"];
              }
              {
                # TODO: delete once Vanguard is implemented in league.
                windows = ["class:^(leagueclientux.exe)$"];
                rules = [
                  "workspace 4"
                  "float"
                  "center"
                  "size 1600 900"
                  "nomaxsize"
                ];
              }
              {
                windows = ["class:^(league of legends.exe)$"];
                rules = [
                  "fullscreen"
                ];
              }
              {
                windows = ["class:^(xwaylandvideobridge)$"];
                rules = [
                  "opacity 0.0 override 0.0 override"
                  "noanim"
                  "nofocus"
                  "noinitialfocus"
                ];
              }
              {
                windows = ["title:^()$,class:^(steam)$"];
                rules = [
                  "stayfocused"
                  "minsize 1 1"
                ];
              }
            ];

            # TODO: use binaries directly from store for each binding.
            bind = let
              workspaces = builtins.genList (x: x + 1) 10;
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
              with builtins;
                [
                  # General
                  "ALT, W, exec, choose-wallpaper"
                  "ALT, R, exec, random-wallpaper"
                  "ALT SHIFT, X, exec, hyprlock"
                  "SUPER, B, exec, $BROWSER"
                  "SUPER, Space, exec, rofi -show drun"
                  "SUPER, Return, exec, kitty -1"
                  "CTRL, Grave, exec, makoctl restore"
                  "CTRL, Space, exec, makoctl dismiss"
                  "CTRL SHIFT, Space, exec, makoctl dismiss --all"

                  ## Hyprland ##
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
            binde = [
              ",XF86AudioLowerVolume, exec, pamixer -d 5"
              ",XF86AudioRaiseVolume, exec, pamixer -i 5"
              ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
              ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
            ];
          };

          extraConfig = with pkgs; ''
            bind = ,Print,submap,capture

            submap = capture

            bind = ,G, exec, ${grimblast}/bin/grimblast --notify copysave area
            bind = ,G, submap, reset
            bind = ,Print, exec, ${grimblast}/bin/grimblast --notify copysave active
            bind = ,Print, submap, reset
            bind = ,S, exec, ${grimblast}/bin/grimblast --notify copysave output
            bind = ,S, submap, reset

            submap=reset
          '';
        };

        programs.hyprlock = {
          enable = true;
          backgrounds = [
            {
              monitor = "";
              path = "$HOME/.cache/background-img";
            }
          ];
          images = [
            {
              monitor = "";
              path = "$HOME/.face.icon";
              size = 200;
            }
          ];
        };

        services.hypridle = {
          enable = true;
          settings = {
            general = {
              lock_cmd = "pidof hyprlock || hyprlock";
              before_sleep_cmd = builtins.concatStringsSep "; " [
                "loginctl lock-session"
                "${pkgs.playerctl}/bin/playerctl pause"
              ];
            };
          };
        };

        services.kdeconnect.indicator = true; # Phone integration
        services.cliphist.enable = true; # Clipboard history for wayland
        services.udiskie.enable = true; # USB automount
      };
    };
  };
}
