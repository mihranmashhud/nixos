{
  mm.apps.kitty.homeManager = {config, ...}: {
    programs.kitty = {
      enable = true;
      settings = {
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
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
        cursor_trail = 3;
        cursor_trail_decay = "0.1 0.4";

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
        enableZshIntegration = config.programs.zsh.enable;
      };
    };
  };
}
