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
    plugins.snacks = {
      enable = true;
      settings = {
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
  };
}
