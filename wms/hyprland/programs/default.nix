{ config, pkgs, ... }: {
  imports = [
    ./mako.nix
    ./rofi.nix
    ./wlogout.nix
  ];
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    swaylock
    swww
    libnotify
    hyprkeys
    xwaylandvideobridge
  ];

  xdg.configFile."waybar".source = ./waybar;
  programs.waybar.enable = true;
  services.kdeconnect.indicator = true;
  services.udiskie.enable = true;
}
