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
  cfg = config.${namespace}.themes.catppuccin;
  theming = config.${namespace}.theming;
in {
  # Currently using catpuccin-mocha theme for the most part.
  options.${namespace}.themes.catppuccin = with types; {
    enable = mkBoolOpt false "Whether to enable catppuccin user theme";
  };

  config = mkIf cfg.enable {
    stylix = {
      autoEnable = false;
      # base16Scheme = getScheme pkgs "catppuccin-mocha";
      opacity.terminal = 0.8;
    };

    catppuccin.enable = true;
    catppuccin.accent = "blue";
    gtk.enable = mkIf theming.graphical true;
    gtk.theme = mkIf theming.graphical {
      name = "Catppuccin-GTK-Dark";
      package = pkgs.magnetic-catppuccin-gtk;
    };
    catppuccin.gtk.icon = {
      accent = "blue";
    };
    qt.enable = true;
    qt.style.name = "kvantum";
    qt.platformTheme.name = "kvantum";

    # Disable for these targets
    catppuccin = {
      cursors.enable = false;
      rofi.enable = false;
      nvim.enable = false;
      firefox.profiles.mihranmashhud.enable = false;
    };
  };
}
