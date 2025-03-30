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
    plugins.neo-tree = {
      enable = true;
      eventHandlers = let
        on_rename_handler =
          # lua
          ''
            function (data)
              if Snacks then
                Snacks.rename.on_rename_file(data.source, data.destination)
              end
            end
          '';
      in {
        file_moved = on_rename_handler;
        file_renamed = on_rename_handler;
      };
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>ae";
        action = "<cmd>Neotree toggle reveal<cr>";
        options = {
          desc = "file explorer";
        };
      }
      {
        mode = "n";
        key = "<leader>as";
        action = "<cmd>Neotree document_symbols<cr>";
        options = {
          desc = "symbols explorer";
        };
      }
    ];
  };
}
