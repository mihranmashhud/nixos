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
  cfg = config.${namespace}.apps.kitty;
in {
  options.${namespace}.apps.kitty = {
    enable = mkBoolOpt false "Whether to enable kitty configuration.";
  };
  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      settings = {
        background_opacity = "${toString config.stylix.opacity.terminal}";
        font_size = "${toString config.stylix.fonts.sizes.terminal}.0";
        # Bell
        enable_audio_bell = "no";
        visual_bell_duration = "0.1";
        window_alert_on_bell = "yes";

        # Window
        remember_window_size = "yes";
        initial_window_width = 640;
        initial_window_height = 400;
        window_padding_width = "0.5";
        confirm_os_window_close = 0;

        # Cursor
        cursor_shape = "beam";

        # Remote control
        allow_remote_control = "socket-only";
        listen_on = "unix:/tmp/kitty";
      };

      keybindings = {
        "ctrl+plus" = "change_font_size all +1.0";
        "ctrl+minus" = "change_font_size all -1.0";
        "ctrl+equal" = "change_font_size all ${toString config.stylix.fonts.sizes.terminal}.0";
        "super+shift+enter" = "launch --type=os-window --cwd=current";
      };

      shellIntegration = {
        enableZshIntegration = config.${namespace}.cli.zsh.enable;
      };
    };
  };
}
