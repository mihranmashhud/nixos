{
  mm,
  lib,
  ...
}: let
  monitor_workspaces = m: ws:
    [
      {
        workspace = "${builtins.head ws}";
        monitor = m;
        default = true;
      }
    ]
    ++ (map (w: {
      workspace = "${w}";
      monitor = m;
    }) (builtins.tail ws));
  args = list: {
    _args = list;
  };
  autostart = commands:
  # lua
  ''
    hl.on("hyprland.start", function ()
      ${lib.strings.join "\n  " (map (cmd: "hl.exec_cmd(\"${cmd}\")") commands)}
    end)'';
in {
  mm.hyprland = {
    includes = [
      mm.hyprland._
    ];

    meta.helpers = {
      inherit autostart monitor_workspaces;
    };

    nixos = {pkgs, ...}: {
      programs.hyprland.enable = true;

      environment.systemPackages = with pkgs; [
        xdg-utils
      ];
      services.udisks2.enable = true; # Required for udiskie
      services.accounts-daemon.enable = true; # For user account information
      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config.hyprland = {
          default = [
            "hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [
            "gtk"
          ];
        };
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
      };
    };
    homeManager = {
      config,
      inputs',
      ...
    }: {
      wayland.windowManager.hyprland = with config.lib.stylix.colors; {
        enable = true;

        settings = let
          inactive_color = "rgb(${base02})";
          active_color = lib.generators.mkLuaInline ''{ colors = {"rgb(${base0D})", "rgb(${base0E})"}, angle = 45 }'';
        in {
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
              touchpad = {
                natural_scroll = true;
              };
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
          monitor = lib.mkAfter [
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
        };
        # Startup
        extraConfig = lib.mkMerge [
          # lua
          ''
            hl.animation({ leaf = "windows", enabled = true, speed = 8, bezier = "default", style = "popin 80%" })
          ''
          (
            autostart
            ["${inputs'.dms.packages.default}/bin/dms run"]
          )
        ];
      };

      services.cliphist.enable = true; # Clipboard history for wayland
      services.udiskie.enable = true; # USB automount
      services.hyprpolkitagent.enable = true; # Polkit agent
    };
  };
}
