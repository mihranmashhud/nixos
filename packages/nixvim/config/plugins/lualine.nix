{
  lib,
  namespace,
  inputs,
  pkgs,
  config,
  ...
}: {
  # Enables treesitter related plugins as well
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        theme = lib.mkDefault "auto";
        icons_enabled = true;
        component_separators = {
          left = "";
          right = "";
        };
        section_separators = {
          left = "";
          right = "";
        };
        globalstatus = true;
        refresh = {
          statusline = 100;
          tabline = 100;
          winbar = 100;
        };
      };
      sections = {
        lualine_a = ["mode"];
        lualine_b = ["branch" "diagnostics"];
        lualine_c = [];
        lualine_x = [
          {
            __unkeyed-1 = "filename";
            path = 1;
          }
          "filetype"
        ];
        lualine_y = ["location"];
        lualine_z = ["progress"];
      };
      tabline = {
        lualine_a = [];
        lualine_b = [
          {
            __unkeyed-1 = "tabs";
            mode = 2;
          }
        ];
        lualine_c = [];
        lualine_x = [];
        lualine_y = [
          {
            __unkeyed-1 = "filetype";
            icon_only = true;
          }
          "filename"
        ];
        lualine_z = [];
      };
      winbar = {
        lualine_a = [];
        lualine_b = ["filename"];
        lualine_c = [];
        lualine_x = [];
        lualine_y = [];
        lualine_z = [];
      };
      inactive_winbar = {
        lualine_a = [];
        lualine_b = [
          {
            __unkeyed-1 = "filename";
            path = 1;
          }
        ];
        lualine_c = [];
        lualine_x = [];
        lualine_y = [];
        lualine_z = [];
      };
      extensions =
        []
        ++ (lib.optional config.plugins.neo-tree.enable "neo-tree");
    };
  };
}
