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
  flavor = "mocha";
  accent = "mauve";
in {
  options.${namespace}.themes.catppuccin = with types; {
    enable = mkBoolOpt false "Whether to enable catppuccin system theme";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      stylix = {
        autoEnable = false;
        base16Scheme = getScheme pkgs "catppuccin-${flavor}";
        opacity.terminal = 0.8;
      };

      catppuccin = {
        enable = true;
        inherit accent flavor;
      };
      services.displayManager.sddm.package = pkgs.kdePackages.sddm;
    }
    (mkIf theming.graphical rec {
      boot.plymouth.enable = true;
      stylix.cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 24;
      };
      # Required to get cursor working in Hyprland.
      environment.sessionVariables = {
        HYPRCURSOR_THEME = stylix.cursor.name;
        HYPRCURSOR_SIZE = toString stylix.cursor.size;
      };
    })
  ]);
}
