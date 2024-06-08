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
  cfg = config.${namespace}.apps.waybar;
in {
  options.${namespace}.apps.waybar = {
    enable = mkBoolOpt false "Whether to enable waybar configuration.";
  };
  config = mkIf cfg.enable {
    xdg.configFile."waybar/modules.json".source = ./config/modules.json;
    xdg.configFile."waybar/desktop-config.json".source = ./config/desktop-config.json;
    xdg.configFile."waybar/laptop-config.json".source = ./config/laptop-config.json;
    xdg.configFile."waybar/style.css".source = mkForce ./config/style.css;
    xdg.configFile."waybar/colors.css".text = with config.lib.stylix.colors; ''
      @define-color base00 #${base00}; /* base */
      @define-color base01 #${base01}; /* mantle */
      @define-color base02 #${base02}; /* surface0 */
      @define-color base03 #${base03}; /* surface1 */
      @define-color base04 #${base04}; /* surface2 */
      @define-color base05 #${base05}; /* text */
      @define-color base06 #${base06}; /* rosewater */
      @define-color base07 #${base07}; /* lavender */
      @define-color base08 #${base08}; /* red */
      @define-color base09 #${base09}; /* peach */
      @define-color base0A #${base0A}; /* yellow */
      @define-color base0B #${base0B}; /* green */
      @define-color base0C #${base0C}; /* teal */
      @define-color base0D #${base0D}; /* blue */
      @define-color base0E #${base0E}; /* mauve */
      @define-color base0F #${base0F}; /* flamingo */
    '';
    programs.waybar = {
      enable = true;
      package = inputs.waybar.packages.${system}.waybar;
    };
  };
}
