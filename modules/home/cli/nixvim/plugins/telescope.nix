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
    extraPackages = with pkgs; [
      ripgrep
    ];
    plugins.telescope = {
      enable = true;
      extensions.fzy-native.enable = true;
      settings = {
        defaults = {
          file_ignore_patterns = [
            "node_modules"
          ];
        };
      };
    };
    extraConfigLua = 
    # lua
    ''
      set_group_name("<leader>s", "Search")
    '';
    keymaps = [
      {
        mode = "n";
        key = "<leader>f";
        action = "<cmd>Telescope find_files<cr>";
        options = {
          desc = "files";
        };
      }
      {
        mode = "n";
        key = "<leader>sw";
        action = "<cmd>Telescope live_grep<cr>";
        options = {
          desc = "live grep";
        };
      }
    ];
  };
}
