{ config, pkgs, ... }: {
  imports = [
    ./hypr.nix
  ];
  home.packages = with pkgs; [
    obs-studio
    obs-studio-plugins.obs-websocket
    obs-cli
  ];
  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "DP-1, highrr, auto, 1"
        "HDMI-A-1, 1920x1080, auto, 1"
      ];
      animations = {
        enabled = "yes";
        bezier = [
          "linear,0,0,1,1"
        ];
        animation = [
          "borderangle, 1, 50, linear, loop"
        ];
      };
      workspace = [
        "1, monitor:DP-1, default:true"
        "2, monitor:DP-1"
        "3, monitor:DP-1"
        "4, monitor:DP-1"
        "5, monitor:DP-1"
        "6, monitor:HDMI-A-1, default:true"
        "7, monitor:HDMI-A-1"
        "8, monitor:HDMI-A-1"
        "9, monitor:HDMI-A-1"
        "10, monitor:HDMI-A-1"
      ];
      exec-once = [
        "waybar -c ~/.config/waybar/desktop-config.json > /tmp/waybar.log &"
        "[workspace 6 silent] discord &"
        "obs --startreplaybuffer --minimize-to-tray &"
        "[workspace 10 silent] pavucontrol &"
        "xwaylandvideobridge &"
      ];
    };
  };
}
