{ config, pkgs, ... }: {
  imports = [
    ./mako.nix
    ./rofi.nix
    ./wlogout.nix
  ];
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    swayidle
    swaylock
    swww
    libnotify
    hyprkeys
    (nur.repos.mikilio.xwaylandvideobridge.overrideAttrs {
      isHyprland = true;
    })
  ];

  xdg.configFile."waybar".source = ./waybar;
  programs.waybar.enable = true;
  services.kdeconnect.indicator = true;
  services.udiskie.enable = true;
}
