_: {
  plugins.undotree.enable = true;
  keymaps = [
    {
      mode = "n";
      key = "<leader>au";
      action = "<cmd>UndotreeToggle<cr>";
      options = {
        desc = "undo tree";
      };
    }
  ];
}
