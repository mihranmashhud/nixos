{
  lib,
  namespace,
  inputs,
  pkgs,
  ...
}: {
  extraPackages = with pkgs; [
    ghostscript # Required to render PDF files
    tectonic # Required to render LaTeX math expressions
  ];
  extraConfigLua = ''
    set_group_name("<leader>s", "Search")
  '';
  keymaps = [
    {
      mode = "n";
      key = "<leader>at";
      action.__raw = ''
        function()
          if Snacks.dim.enabled then
            Snacks.dim.disable()
          else
            Snacks.dim.enable()
          end
        end
      '';
      options = {
        silent = true;
        desc = "toggle dimming";
      };
    }

    # Search/Pickers
    {
      mode = "n";
      key = "<leader>f";
      action.__raw = "Snacks.picker.files";
      options = {
        desc = "files";
      };
    }
    {
      mode = "n";
      key = "<leader>sw";
      action.__raw = "Snacks.picker.grep";
      options = {
        desc = "live grep";
      };
    }
    {
      mode = "n";
      key = "<leader>sb";
      action.__raw = "Snacks.picker.git_branches";
      options = {
        desc = "git branches";
      };
    }

    # Toggle terminal
    {
      mode = "n";
      key = "<leader>t";
      action.__raw = "Snacks.terminal.toggle";
      options = {
        desc = "toggle terminal";
      };
    }
  ];
  plugins.snacks = {
    enable = true;
    settings = {
      picker = {
        layout.preset = "telescope";
      };
      notifier.enabled = true;
      image = {
        enabled = true;
        inline = false;
        float = true;
      };
      scroll.enabled = true;
      indent.enabled = true;
      chunk = {
        enabled = true;
        char = {
          corner_top = "╭";
          corner_bottom = "╰";
        };
      };
      dashboard = {
        preset = {
          header = ''
            ⠀⠀⠀⢀⣴⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⣦⡀   
            ⠀⢀⣴⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣦⡀ 
            ⣴⣌⢻⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣦
            ⣿⣿⣦⠹⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿
            ⣿⣿⣿⣷⡘⢿⣿⣿⣿⣿⣷⡀⠀⠀⠀⣿⣿⣿⣿⣿
            ⣿⣿⣿⣿⣿⠈⢿⣿⣿⣿⣿⣿⣄⠀⠀⣿⣿⣿⣿⣿
            ⣿⣿⣿⣿⣿⠀⠀⠻⣿⣿⣿⣿⣿⣦⠀⣿⣿⣿⣿⣿
            ⣿⣿⣿⣿⣿⠀⠀⠀⠙⣿⣿⣿⣿⣿⣷⡙⣿⣿⣿⣿
            ⣿⣿⣿⣿⣿⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣷⡌⢿⣿⣿
            ⢿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣆⠻⡿
            ⠀⠙⢿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⡿⠃ 
            ⠀⠀⠀⠙⢿⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⡿⠋   '';
        };
        sections = [
          {section = "header";}
          {
            section = "keys";
            gap = 1;
            padding = 1;
          }
        ];
      };
    };
  };
}
