{
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}:
with lib;
with lib.${namespace}; let
in {
  extraConfigLuaPre = ''
    local set_kitty_bg = function(bg)
      vim.fn.system("kitty @ set-colors background='"..bg.."'")
    end
    local kitty_bg = vim.fn.system("kitty @ get-colors | grep '^background'")
    kitty_bg = kitty_bg:match("#%x+")
  '';
  autoGroups = {
    highlight_yank.clear = true;
    kitty_background.clear = true;
  };
  autoCmd = [
    {
      event = "TextYankPost";
      group = "highlight_yank";
      callback.__raw = ''
        function() vim.hl.on_yank({ hlgroup = "IncSearch", timeout = 200 }) end
      '';
    }
    {
      event = "VimLeavePre";
      group = "kitty_background";
      callback.__raw = ''
        function()
          if kitty_bg then
            set_kitty_bg(kitty_bg)
          end
        end
      '';
    }
    {
      event = "ColorScheme";
      group = "kitty_background";
      callback.__raw = ''
        function()
          local bg = vim.api.nvim_get_hl(0, {name="Normal"}).bg
          if bg then
            bg = "#"..string.format("%x", bg)
            set_kitty_bg(bg)
          end
        end
      '';
    }
  ];
}
