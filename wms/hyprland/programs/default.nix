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
    udiskie
    libnotify
    hyprkeys
  ];

  xdg.configFile."waybar".source = ./waybar;
  programs.waybar.enable = true;
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };
}
