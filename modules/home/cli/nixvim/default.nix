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
with lib.${namespace}; let
  cfg = config.${namespace}.cli.nixvim;
in {
  imports =
      ([
          ./keymaps.nix
          ./settings.nix
          ./colorschemes.nix
        ]
        ++ (umport {path = ./plugins;}));

  options.${namespace}.cli.nixvim = {
    enable = mkBoolOpt false "Whether to enable nixvim configuration.";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      extraConfigLuaPre = ''
        local set_kitty_bg = function(bg)
          vim.fn.system("kitty @ set-colors background='"..bg.."'")
        end
        local kitty_bg = vim.fn.system("kitty @ get-colors | grep '^background' | tr -s ' ' | cut -d' ' -f2")
        kitty_bg = kitty_bg:sub(1,7)
      '';
      autoGroups = {
        highlight_yank.clear = true;
        kitty_background.clear = true;
      };
      autoCmd = [
        {
          event = "TextYankPost";
          group = "highlight_yank";
          callback.__raw = 
          ''
            function() vim.highlight.on_yank({ hlgroup = "IncSearch", timeout = 200 }) end
          '';
        }
        {
          event = "VimLeavePre";
          group = "kitty_background";
          callback.__raw =
          ''
            function()
              set_kitty_bg(kitty_bg)
            end
          '';
        }
        {
          event = "ColorScheme";
          group = "kitty_background";
          callback.__raw =
          ''
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
    };
  };
}
