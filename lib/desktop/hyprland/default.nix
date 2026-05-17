{
  lib,
  inputs,
  namespace,
  snowfall-inputs,
}:
with lib; rec {
  hypr = {
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
      flags,
    }:
      args [
        keys
        (lib.generators.mkLuaInline dispatcher)
        flags
      ];
    bind_exec = {
      keys,
      command,
      flags,
    }: (bind {
      inherit keys flags;
      dispatcher = "hl.dsp.exec_cmd(\"${command}\")";
    });
    autostart = commands: (args [
      "hyprland.start"
      (lib.generators.mkLuaInline
        # lua
        ''
          function ()
            ${lib.strings.join "\n" (map (cmd: "hl.dsp.exec_cmd(\"${cmd}\")"))}
          end
        '')
    ]);
  };
}
