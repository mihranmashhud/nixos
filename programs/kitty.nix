{
  config,
  pkgs,
  ...
}: {
  programs.kitty = let
    font_size = "12.0";
  in {
    enable = true;
    settings = with config.colorScheme.colors; {
      inherit font_size;

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

      # Theme
      background_opacity = "0.8";
      foreground = "#${base07}";
      background = "#${base00}";
      selection_foreground = "#${base01}";
      selection_background = "#${base06}";
      url_color = "#${base0D}";
      cursor = "#${base07}";
      cursor_text_color = "#${base03}";

      # black + darkgrey
      color0 = "#${base00}";
      color8 = "#${base04}";

      # red
      color1 = "#${base08}";
      color9 = "#${base0F}";

      # green
      color2 = "#${base0B}";
      color10 = "#${base0B}";

      # yellow
      color3 = "#${base0A}";
      color11 = "#${base0A}";

      # blue
      color4 = "#${base0D}";
      color12 = "#${base0D}";

      # magenta
      color5 = "#${base0E}";
      color13 = "#${base0E}";

      # cyan
      color6 = "#${base0C}";
      color14 = "#${base0C}";

      # white
      color7 = "#${base07}";
      color15 = "#${base06}";
    };

    keybindings = {
      "ctrl+plus" = "change_font_size all +1.0";
      "ctrl+minus" = "change_font_size all -1.0";
      "ctrl+equal" = "change_font_size all ${font_size}";
      "super+shift+enter" = "launch --type=os-window --cwd=current";
    };

    shellIntegration = {
      enableZshIntegration = true;
    };
  };
}
