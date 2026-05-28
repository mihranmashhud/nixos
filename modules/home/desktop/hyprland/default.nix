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
with lib.${namespace};
with lib.${namespace}.hypr; let
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
    dmsEnabled = config.programs.dank-material-shell.enable;
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
          }
          else {
          };
      };

      wayland.windowManager.hyprland = with config.lib.stylix.colors; {
        enable = true;

        settings = let
          inactive_color = "rgb(${base02})";
          active_color = lib.generators.mkLuaInline ''{ colors = {"rgb(${base0D})", "rgb(${base0E})"}, angle = 45 }'';
        in
          mkMerge
          [
            {
              env = map args [
                ["NIXOS_OZONE_WL" "1"]
                ["XDG_CURRENT_DESKTOP" "Hyprland"]
                ["XDG_SESSION_TYPE" "wayland"]
                ["XDG_SESSION_DESKTOP" "Hyprland"]
                ["QT_AUTO_SCALE_FACTOR" "1"]
                ["QT_QPA_PLATFORM" "wayland;xcb"]
                ["QT_WAYLAND_DISABLE_WINDOWDECORATION" "1"]
              ];
              config = {
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

                misc = {
                  disable_hyprland_logo = true;
                  disable_splash_rendering = true;
                  mouse_move_focuses_monitor = false;
                  mouse_move_enables_dpms = true;
                  on_focus_under_fullscreen = 1;
                  anr_missed_pings = 5;
                };
              };
              gesture = [
                {
                  fingers = 3;
                  direction = "horizontal";
                  action = "workspace";
                }
              ];
              monitor = mkAfter [
                {
                  output = "";
                  mode = "preferred";
                  position = "auto";
                  scale = 1;
                }
              ];
              window_rule = [
                {
                  name = "messaging";
                  match.class = "^(discord|vesktop|Slack|org\\.telegram\\.desktop)$";

                  workspace = 6;
                }
                {
                  name = "misbehaved-dropdowns-steam";
                  match.title = "^()$";
                  match.class = "class:^(steam)$";

                  stay_focused = true;
                  min_size = "1 1";
                }
                {
                  name = "misbehaved-dropdowns-zoom";
                  match.initial_title = "(menu window)";
                  match.class = "class:^(zoom)$";

                  stay_focused = true;
                  min_size = "1 1";
                }
                {
                  name = "fullscreen-bigpicture-mode";
                  match.initial_title = "^(Steam Big Picture Mode)$";
                  match.class = "^(steam)$";

                  fullscreen_state = "2 2";
                }
                {
                  name = "picture-in-picture";
                  match.title = "^(Picture-in-Picture)$";

                  size = "448 252";
                  move = lib.generators.mkLuaInline "{\"(monitor_w-window_w-10)\", \"(monitor_h-window_h-10)\"}";
                  float = true;
                }
                # Smart Gaps
                {
                  match = {
                    float = false;
                    workspace = "w[tv1]";
                  };
                  border_size = 0;
                }
                {
                  match = {
                    float = false;
                    workspace = "w[tv1]";
                  };
                  rounding = 0;
                }
                {
                  match = {
                    float = false;
                    workspace = "f[1]";
                  };
                  border_size = 0;
                }
                {
                  match = {
                    float = false;
                    workspace = "f[1]";
                  };
                  rounding = 0;
                }
              ];
              workspace_rule = [
                # Smart Gaps
                {
                  workspace = "w[tv1]";
                  gaps_out = 0;
                  gaps_in = 0;
                }
                {
                  workspace = "f[1]";
                  gaps_out = 0;
                  gaps_in = 0;
                }
              ];
            }
            cfg.settings
          ];
        # Startup
        extraConfig =
          mkMerge
          [
            # lua
            ''
              hl.animation({ leaf = "windows", enabled = true, speed = 8, bezier = "default", style = "popin 80%" })
            ''
            (autostart
              (
                if dmsEnabled
                then ["${inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/dms run"]
                else [
                  # Top bar
                  "${lib.getBin pkgs.waybar} -c ~/.config/waybar/${cfg.type}-config.json > /tmp/waybar.log"
                ]
              ))
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
      services.awww.enable = !dmsEnabled; # Wallpaper daemon
    };
}
