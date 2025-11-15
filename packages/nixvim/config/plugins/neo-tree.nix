{
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}: {
  plugins.neo-tree = {
    enable = true;
    settings.event_handlers = let
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
}
