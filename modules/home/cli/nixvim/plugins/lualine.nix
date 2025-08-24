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
with lib.${namespace}; {
  config.programs.nixvim = {
    # Enables treesitter related plugins as well
    plugins.lualine = {
      enable = true;
      settings = {
        options = {
          theme = mkDefault "auto";
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
          ++ (
            if config.programs.nixvim.plugins.neo-tree.enable
            then ["neo-tree"]
            else []
          );
      };
    };
  };
}
