{ config, pkgs, ... }: {
  imports = [
    ./programs
    ./theming
    ./scripts
  ];

  home = {
    username = "mihranmashhud";
    homeDirectory = "/home/mihranmashhud";
    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/scripts"
    ];
  };

  xresources.properties = {
    "Xcursor.size" = 16;
  };

  programs = {
    home-manager.enable = true;
  };

  home.packages = with pkgs; [
    # apps
    discord
    telegram-desktop
    gnome.nautilus
    warp
    pavucontrol
    lutris
    steam
    obsidian
    mpv
    
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
    rmtrash
    pamixer
    nix-prefetch-git
    killall

    # dev tools
    rustup
    gcc
    nodePackages.pnpm
    
    # system tools
    monitor
    sysstat
    lm_sensors # sensors
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];

  home.stateVersion = "23.05";
}
