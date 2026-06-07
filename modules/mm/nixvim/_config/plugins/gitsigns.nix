{
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}: {
  plugins.gitsigns = {
    enable = true;
    settings = {
      sign_priority = 100;
    };
  };
  extraConfigLua = ''
    set_group_name("<leader>g", "Git")
  '';
  keymaps = [
    {
      mode = ["n" "v"];
      key = "<leader>gu";
      action = "<cmd>Gitsigns reset_hunk<cr>";
      options = {
        desc = "reset hunk";
      };
    }
    {
      mode = ["n" "v"];
      key = "<leader>gp";
      action = "<cmd>Gitsigns preview_hunk<cr>";
      options = {
        desc = "preview hunk";
      };
    }
    {
      mode = ["n" "v"];
      key = "<leader>gb";
      action = "<cmd>Gitsigns blame_line<cr>";
      options = {
        desc = "blame line";
      };
    }
  ];
}
