{ config, pkgs, ... }: {
  imports = [
    ./programs
    ./theming
  ];

  home = {
    username = "mihranmashhud";
    homeDirectory = "/home/mihranmashhud";
  };

  xresources.properties = {
    "Xcursor.size" = 16;
  };

  programs = {
    home-manager.enable = true;
  };

  home.packages = with pkgs; [

    # archives
    zip
    xz
    unzip
    gnutar

    # utils
    ripgrep
    jq
    yq-go
    eza

    # dev tools
    rustup
    gcc
    
    # system tools
    sysstat
    lm_sensors # sensors
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  home.stateVersion = "23.05";
}
