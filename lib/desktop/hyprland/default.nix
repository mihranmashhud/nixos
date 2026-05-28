{
  lib,
  inputs,
  namespace,
  snowfall-inputs,
}:
with lib; {
  hypr = rec {
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
    autostart = commands:
    # lua
    ''
      hl.on("hyprland.start", function ()
        ${lib.strings.join "\n  " (map (cmd: "hl.exec_cmd(\"${cmd}\")") commands)}
      end)'';
  };
}
