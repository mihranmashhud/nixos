{
  config,
  pkgs,
  ...
}: let
  system-sounds = "${pkgs.deepin.deepin-sound-theme}/share/sounds/deepin/stereo";
in {
  services.mako = with config.colorScheme.colors; {
    enable = true;
    defaultTimeout = 2000;
    backgroundColor = "#${base00}";
    borderColor = "#${base0D}";
    borderRadius = 5;
    borderSize = 2;
    textColor = "#${base07}";
    layer = "overlay";
    extraConfig = ''
      on-button-left=exec makoctl menu -n "$id" rofi -dmenu -p 'Select action: '
      on-notify=exec mpv ${system-sounds}/message.wav
    '';
  };
}
