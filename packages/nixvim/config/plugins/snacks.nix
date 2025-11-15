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
  plugins.snacks = {
    enable = true;
    settings = {
      image = {
        enabled = true;
        inline = false;
        float = true;
      };
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
