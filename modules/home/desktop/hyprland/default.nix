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
  imports = [
    ./keybinds.nix
  ];

  options.${namespace}.desktop.hyprland = with types; {
    enable = mkEnableOption "Hyprland configuration";
    type = mkOpt (enum ["desktop" "laptop"]) "desktop" "Whether this is a desktop or laptop.";
    settings = mkOpt attrs {} "Extra Hyprland settings.";
    extraConfig = mkOpt lines "" "Extra Hyprland config lines.";
    hyprlock = mkOpt attrs {} "Extra Hyprlock settings.";
    hypridle = mkOpt attrs {} "Extra Hypridle settings.";
  };

  config = let
    dmsEnabled = config.programs.dankMaterialShell.enable;
  in
    mkIf cfg.enable {
      home.packages = with pkgs;
      with pkgs.${namespace};
        mkMerge [
          (mkIf (!dmsEnabled) [
            wl-clipboard
            cliphist
            libnotify
            choose-wallpaper
            random-wallpaper
          ])
          [
            pwvucontrol
            grimblast
          ]
        ];

      ${namespace} = {
        theming.graphical = true;
        apps =
          if dmsEnabled
          then {
            waybar = enabled;
            mako = enabled;
            wlogout = enabled;
            vicinae = enabled;
          }
          else {
            vicinae = enabled;
          };
      };

      wayland.windowManager.hyprland = with config.lib.stylix.colors; {
        enable = true;

        settings = let
          inactive_color = "rgb(${base02})";
          active_color = "rgb(${base0D}) rgb(${base0E}) 45deg";
        in
          mkMerge
          [
            {
              general = {
                border_size = 2;
                gaps_in = 4;
                gaps_out = 8;
                "col.inactive_border" = inactive_color;
                "col.active_border" = active_color;
                "col.nogroup_border" = inactive_color;
                "col.nogroup_border_active" = active_color;
                resize_on_border = true;
                layout = "dwindle";
              };

              cursor = {
                inactive_timeout = 15;
                no_warps = true;
              };

              dwindle = {
                force_split = 0;
              };

              decoration = {
                rounding = 2;
              };

              input = {
                follow_mouse = 2;
              };

              gestures = {
                workspace_swipe_invert = false;
              };

              gesture = [
                "3, horizontal, workspace"
              ];

              misc = {
                disable_hyprland_logo = true;
                mouse_move_focuses_monitor = false;
                mouse_move_enables_dpms = true;
                new_window_takes_over_fullscreen = 1;
                anr_missed_pings = 5;
              };

              # Startup
              exec-once =
                if dmsEnabled
                then (mkAfter ["${getExe inputs.dms-cli.packages.${system}.dms-cli} run"])
                else [
                  # Top bar
                  "waybar -c ~/.config/waybar/${cfg.type}-config.json > /tmp/waybar.log &"
                ];

              windowrulev2 = hypr.windowrules [
                {
                  windows = [
                    "class:^(discord)$"
                    "class:^(vesktop)$"
                    "class:^(Slack)$"
                    "class:^(org.telegram.desktop)$"
                  ];
                  rules = ["workspace 6"];
                }
                {
                  windows = ["class:^(com.saivert.pwvucontrol)$"];
                  rules = ["workspace 10"];
                }
                {
                  windows = ["title:^()$,class:^(steam)$"];
                  rules = [
                    "stayfocused"
                    "minsize 1 1"
                  ];
                }
                {
                  windows = ["initialTitle:^(Steam Big Picture Mode)$, class:^(steam)$"];
                  rules = [
                    "fullscreen"
                  ];
                }
                {
                  windows = ["title:^(Picture-in-Picture)$"];
                  rules = [
                    "size 448 252"
                    "float"
                  ];
                }
                {
                  windows = ["class:(zoom),initialTitle:(menu window)"];
                  rules = [
                    "stayfocused"
                  ];
                }
              ];

              layerrule = [
                "blur, vicinae"
                "ignorealpha 0, vicinae"
                "noanim, vicinae"
              ];
            }
            cfg.settings
          ];

        extraConfig = with pkgs;
          mkMerge [
            # For Monocle Mode
            ''
              workspace = w[tv1], gapsout:0, gapsin:0
              workspace = f[1], gapsout:0, gapsin:0
              windowrulev2 = bordersize 0, floating:0, onworkspace:w[tv1]
              windowrulev2 = rounding 0, floating:0, onworkspace:w[tv1]
              windowrulev2 = bordersize 0, floating:0, onworkspace:f[1]
              windowrulev2 = rounding 0, floating:0, onworkspace:f[1]
            ''
            cfg.extraConfig
          ];
      };

      programs.hyprlock = mkMerge [
        {
          enable = !dmsEnabled;
          settings = {
            background = [
              {
                monitor = "";
                path = "$HOME/.cache/background-img";
              }
            ];
          };
        }
        cfg.hyprlock
      ];

      services.hypridle = mkMerge [
        {
          enable = !dmsEnabled;
          settings = {
            general = {
              lock_cmd = "pidof hyprlock || hyprlock";
              unlock_cmd = "pkill -USR1 hyprlock";
              before_sleep_cmd = builtins.concatStringsSep "; " [
                "loginctl lock-session"
                "${pkgs.playerctl}/bin/playerctl pause"
              ];
            };
          };
        }
        cfg.hypridle
      ];

      services.kdeconnect = {
        enable = true;
        indicator = true; # Phone integration
      };
      services.cliphist.enable = true; # Clipboard history for wayland
      services.udiskie.enable = true; # USB automount
      services.swww.enable = !dmsEnabled; # Wallpaper daemon
    };
}
