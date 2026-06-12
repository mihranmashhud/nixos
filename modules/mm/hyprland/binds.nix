{lib, ...}: let
  args = list: {
    _args = list;
  };
  bind = {
    keys,
    dispatcher,
    flags ? {},
  }:
    args [
      keys
      (lib.generators.mkLuaInline dispatcher)
      flags
    ];
  bind_exec = {
    keys,
    command,
    flags ? {},
  }: (bind {
    inherit keys flags;
    dispatcher = "hl.dsp.exec_cmd(\"${command}\")";
  });
  modulo = number: divisor: number - divisor * (number / divisor);
in {
  mm.hyprland.binds.homeManager = {
    pkgs,
    config,
    ...
  }: {
    wayland.windowManager.hyprland = {
      settings = {
        config.binds.allow_workspace_cycles = true;

        bind = let
          workspaces = lib.lists.range 1 10;
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
          (map bind_exec
            [
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
            ])
          ++ (map bind [
            # Hyprland
            {
              keys = "SUPER + W";
              dispatcher = "hl.dsp.window.close()";
              flags = {
                description = "Close current window";
              };
            }
            {
              keys = "SUPER + SHIFT + C";
              dispatcher = "hl.dsp.window.cycle_next({ next = false })";
              flags = {
                description = "Cycle to previous window";
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
              keys = "SUPER + ${builtins.elemAt x 0}";
              dispatcher = "hl.dsp.focus({ direction = \"${builtins.elemAt x 1}\" })";
            }))
            directions)
          # - Move window
          ++ (map (x: (bind {
              keys = "SUPER + SHIFT + ${builtins.elemAt x 0}";
              dispatcher = "hl.dsp.window.move({ direction = \"${builtins.elemAt x 1}\" })";
            }))
            directions)
          # - Workspaces
          ++ (map (x: (bind {
              keys = "SUPER + ${toString (modulo x 10)}";
              dispatcher = "hl.dsp.focus({ workspace = \"${toString x}\" })";
            }))
            workspaces)
          # - Move window to workspace
          ++ (map (x: (bind {
              keys = "SUPER + SHIFT + ${toString (modulo x 10)}";
              dispatcher = "hl.dsp.window.move({ workspace = \"${toString x}\" })";
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
          ++ (map bind_exec
            [
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
            ]);
      };
      submaps = {
        screenshot = {
          onDispatch = "reset";
          settings.bind = [
            (bind_exec {
              keys = "G";
              command = "${pkgs.grimblast}/bin/grimblast --freeze --notify copysave area";
              flags = {
                description = "Screenshot area";
              };
            })
            (bind_exec {
              keys = "W";
              command = "${pkgs.grimblast}/bin/grimblast --freeze --notify copysave active";
              flags = {
                description = "Screenshot window";
              };
            })
            (bind_exec {
              keys = "S";
              command = "${pkgs.grimblast}/bin/grimblast --freeze --notify copysave output";
              flags = {
                description = "Screenshot screen";
              };
            })
          ];
        };
      };
      extraConfig =
        # lua
        ''
          local function layout_bind(bind_table)
            return function ()
              local workspace = hl.get_active_special_workspace() or
              hl.get_active_workspace()

              if not workspace then
                return
              end

              local layout = workspace.tiled_layout

              if bind_table[layout] then
                hl.dispatch(bind_table[layout])
              end
            end
          end
          -- Cycle windows
          hl.bind("SUPER + C", layout_bind({
            dwindle = hl.dsp.window.cycle_next(),
            monocle = hl.dsp.layout("cyclenext")
          }))
          hl.bind("SUPER + SHIFT + C", layout_bind({
            dwindle = hl.dsp.window.cycle_next({ next = false }),
            monocle = hl.dsp.layout("cycleprev"),
          }))

          -- Toggle Monocle layout
          hl.bind("SUPER + M", function()
            local workspace = hl.get_active_workspace()

            if not workspace then return end

            if workspace.tiled_layout == "dwindle" then
              hl.workspace_rule({ workspace = workspace.name, layout = "monocle" })
            else
              hl.workspace_rule({ workspace = workspace.name, layout = "dwindle" })
            end
          end)
        '';
    };
  };
}
