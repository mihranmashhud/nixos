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
with lib.${namespace}.hypr; {
  config = let
    dmsEnabled = config.programs.dank-material-shell.enable;
  in {
    wayland.windowManager.hyprland = {
      settings = {
        config.binds.allow_workspace_cycles = true;

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
          (map bind_exec (
            if dmsEnabled
            then [
              # General
              {
                keys = "ALT + SHIFT + X";
                command = "dms ipc call lock lock";
                flags = {
                  description = "Lock screen";
                };
              }
              {
                keys = "CTRL + Grave";
                command = "dms ipc call notifications toggle";
                flags = {
                  description = "Toggle notifications panel";
                };
              }
            ]
            else [
              # General
              {
                keys = "ALT + W";
                command = "choose-wallpaper";
                flags = {
                  description = "Choose wallpaper";
                };
              }
              {
                keys = "ALT + R";
                command = "random-wallpaper";
                flags = {
                  description = "Random wallpaper";
                };
              }
              {
                keys = "ALT + SHIFT + X";
                command = "hyprlock";
                flags = {
                  description = "Lock screen";
                };
              }
              {
                keys = "CTRL + Grave";
                command = "makoctl restore";
                flags = {
                  description = "Restore notification";
                };
              }
              {
                keys = "CTRL + Space";
                command = "makoctl dismiss";
                flags = {
                  description = "Dismiss notification";
                };
              }
              {
                keys = "CTRL SHIFT + Space";
                command = "makoctl dismiss --all";
                flags = {
                  description = "Dismiss all notifications";
                };
              }
            ]
          ))
          ++ (map bind_exec [
            # General
            {
              keys = "SUPER + B";
              command = "${config.home.sessionVariables.BROWSER}";
              flags = {
                description = "Open browser";
              };
            }
            {
              keys = "SUPER + Space";
              command = "dms ipc call spotlight toggle";
              flags = {
                description = "Open launcher";
              };
            }
            {
              keys = "SUPER + Return";
              command = "kitty -1";
              flags = {
                description = "Open terminal";
              };
            }

            # Hyprland
            {
              keys = "SUPER + W";
              dispatcher = "hl.dsp.window.close()";
              flags = {
                description = "Close current window";
              };
            }
            {
              keys = "SUPER SHIFT + C";
              dispatcher = "hl.dsp.window.cycle_next({ next = false })";
              flags = {
                description = "Cycle to previous window";
              };
            }
            {
              keys = "SUPER + C";
              dispatcher = "hl.dsp.window.cycle_next()";
              flags = {
                description = "Cycle to next window";
              };
            }
            {
              keys = "SUPER + F";
              dispatcher = "hl.dsp.window.float({ action = \"toggle\" })";
              flags = {
                description = "Toggle floating";
              };
            }
            {
              keys = "SUPER + SHIFT + F";
              dispatcher = "hl.dsp.window.fullscreen({ action = \"toggle\" })";
              flags = {
                description = "Toggle fullscreen";
              };
            }
            # TODO: Figure out how to swap between monocle layout. Requires special cycle function.
            # {
            #   keys = "SUPER + M";
            #   command = "1";
            #   flags = {
            #     description = "Toggle monocle";
            #   };
            # }
            {
              keys = "SUPER + Tab";
              dispatcher = "hl.dsp.focus({ workspace = \"previous\" })";
              flags = {
                description = "Swap to last used workspace";
              };
            }
            {
              keys = "Print";
              dispatcher = "hl.dsp.submap(\"screenshot\")";
              flags = {
                description = "Screenshot";
              };
            }
          ])
          # - Move focus
          ++ (map (x: (bind {
              keys = "SUPER + ${elemAt x 0}";
              dispatcher = "hl.dsp.focus({ direction = ${elemAt x 1} })";
            }))
            directions)
          # - Move window
          ++ (map (x: (bind {
              keys = "SUPER + SHIFT + ${elemAt x 0}";
              dispatcher = "hl.dsp.window.move({ direction = ${elemAt x 1} })";
            }))
            directions)
          # - Workspaces
          ++ (map (x: (bind {
              keys = "SUPER + ${toString (modulo x 10)}";
              dispatcher = "hl.dsp.focus({ workspace = ${toString x} })";
            }))
            workspaces)
          # - Move window to workspace
          ++ (map (x: (bind {
              keys = "SUPER + SHIFT + ${toString (modulo x 10)}";
              dispatcher = "hl.dsp.window.move({ workspace = ${toString x} })";
            }))
            workspaces)
          ++ [
            # Drag window
            (bind {
              keys = "SUPER + mouse:272";
              dispatcher = "hl.dsp.window.drag()";
              flags = {
                mouse = true;
              };
            })
            (bind_exec {
              keys = "ALT + SHIFT + S";
              command = "systemctl suspend";
              flags = {
                description = "Suspend";
                locked = true;
              };
            })
            (bind_exec {
              keys = "ALT + SHIFT + H";
              command = "systemctl hibernate";
              flags = {
                description = "Hibernate";
                locked = true;
              };
            })
          ]
          ++ (map bind_exec (
            if dmsEnabled
            then [
              # Audio
              {
                keys = "XF86AudioLowerVolume";
                command = "dms ipc call audio decrement 3";
                flags = {
                  description = "Decrease volume";
                  repeating = true;
                };
              }
              {
                keys = "XF86AudioRaiseVolume";
                command = "dms ipc call audio increment 3";
                flags = {
                  description = "Increase volume";
                  repeating = true;
                };
              }
              {
                keys = "XF86AudioMute";
                command = "dms ipc call audio mute";
                flags = {
                  description = "Mute volume";
                  repeating = true;
                };
              }
              {
                keys = "XF86AudioMicMute";
                command = "dms ipc call audio micmute";
                flags = {
                  description = "Mute microphone";
                  repeating = true;
                };
              }
              # Brightness
              {
                keys = "XF86MonBrightnessDown";
                command = "dms ipc call brightness decrement 5";
                flags = {
                  description = "Increase brightness";
                  repeating = true;
                };
              }
              {
                keys = "XF86MonBrightnessUp";
                command = "dms ipc call brightness increment 5 ";
                flags = {
                  description = "Decrease brightness";
                  repeating = true;
                };
              }
            ]
            else [
              {
                keys = "XF86AudioLowerVolume";
                command = "pamixer -d 5";
                flags = {
                  description = "Decrease volume";
                  repeating = true;
                };
              }
              {
                keys = "XF86AudioRaiseVolume";
                command = "pamixer -i 5";
                flags = {
                  description = "Increase volume";
                  repeating = true;
                };
              }
              {
                keys = "XF86MonBrightnessDown";
                command = "brightnessctl set 5%-";
                flags = {
                  description = "Decrese brightness";
                  repeating = true;
                };
              }
              {
                keys = "XF86MonBrightnessUp";
                command = "Increase brightness";
                flags = {
                  description = "brightnessctl set 5%+";
                  repeating = true;
                };
              }
            ]
          ));
      };
      submaps = {
        screenshot.settings.bind = [
          (bind {
            keys = "G";
            dispatcher =
              # lua
              ''
                function()
                  hl.dsp.exec("${grimblast}/bin/grimblast --freeze --notify copysave area")
                  hl.dsp.submap("reset")
                end
              '';
            flags = {
              description = "Screenshot area";
            };
          })
          (bind {
            keys = "G";
            dispatcher =
              # lua
              ''
                function()
                  hl.dsp.exec("${grimblast}/bin/grimblast --freeze --notify copysave area")
                  hl.dsp.submap("reset")
                end
              '';
            flags = {
              description = "Screenshot area";
            };
          })
          (bind {
            keys = "Print";
            dispatcher =
              # lua
              ''
                function()
                  hl.dsp.exec("${grimblast}/bin/grimblast --freeze --notify copysave active")
                  hl.dsp.submap("reset")
                end
              '';
            flags = {
              description = "Screenshot window";
            };
          })
          (bind {
            keys = "Print";
            dispatcher =
              # lua
              ''
                function()
                  hl.dsp.exec("${grimblast}/bin/grimblast --freeze --notify copysave output")
                  hl.dsp.submap("reset")
                end
              '';
            flags = {
              description = "Screenshot screen";
            };
          })
        ];
      };
    };
  };
}
