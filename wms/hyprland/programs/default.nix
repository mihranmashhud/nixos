{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.ags.homeManagerModules.default
    # ./ags.nix
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
    wdisplays
  ];

  xdg.configFile."waybar".source = ./waybar;
  programs.waybar.enable = true;
  services.kdeconnect.indicator = true;
  services.udiskie.enable = true;
  services.cliphist.enable = true;
}
