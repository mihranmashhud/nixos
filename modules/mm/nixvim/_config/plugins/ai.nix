{
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}: {
  plugins = {
    snacks.settings.input.enabled = true;
    snacks.settings.terminal.enabled = true;
    opencode.enable = true;
  };
  globals.opencode_opts = let
    opencode_cmd = "opencode --port";
    win_opts =
      # lua
      ''
        {
          win = {
            position = 'right',
            enter = false,
            on_win = function(win)
              -- Set up keymaps and cleanup for an arbitrary terminal
              require('opencode.terminal').setup(win.win)
            end,
          },
        }'';
  in {
    server = {
      start.__raw =
        # lua
        ''
          function()
            require('snacks.terminal').open("${opencode_cmd}", ${win_opts})
          end
        '';
      stop.__raw =
        # lua
        ''
          function()
            require('snacks.terminal').get("${opencode_cmd}", ${win_opts}):close()
          end
        '';
      toggle.__raw =
        # lua
        ''
          function()
            require('snacks.terminal').toggle("${opencode_cmd}", ${win_opts})
          end
        '';
    };
  };
  extraConfigLua = ''
    set_group_name("<leader>o", "OpenCode")
  '';
  keymaps = [
    {
      mode = ["n" "x"];
      key = "<leader>oa";
      action.__raw = ''
        function() require("opencode").ask("@this: ", { submit = true }) end
      '';
      options.desc = "Ask OpenCode";
    }
    {
      mode = ["n" "x"];
      key = "<leader>os";
      action.__raw = ''
        function() require("opencode").select() end
      '';
      options.desc = "Select OpenCode";
    }
    {
      mode = "n";
      key = "<leader>ot";
      action.__raw = ''
        function() require("opencode").toggle() end
      '';
      options.desc = "Toggle OpenCode";
    }
    {
      mode = ["n" "x"];
      key = "go";
      action.__raw = ''
        function() return require("opencode").operator("@this ") end
      '';
      options = {
        desc = "Add range to OpenCode";
        expr = true;
      };
    }
    {
      mode = "n";
      key = "goo";
      action.__raw = ''
        function() return require("opencode").operator("@this ") .. "_" end
      '';
      options = {
        desc = "Add line to OpenCode";
        expr = true;
      };
    }
  ];
}
