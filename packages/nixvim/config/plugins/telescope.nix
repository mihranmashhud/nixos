{
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}: {
  extraPackages = with pkgs; [
    ripgrep
    fd
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
}
