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

  xdg.userDirs = {
    enable = true;
    extraConfig = {
      XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
    };
  };

  programs = {
    home-manager.enable = true;
  };

  home.packages = let
    drvs = (import ./derivations {inherit pkgs;});
  in with (pkgs // drvs); [
    # apps
    gnome.nautilus
    warp
    pavucontrol
    obsidian
    mpv
    zoom-us
    xwaylandvideobridge
    grimblast
    github-desktop

    discord
    telegram-desktop
    teams
    
    libreoffice
    hunspell
    hunspellDicts.en_US
    hunspellDicts.en_CA

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
    killall
    imagemagick

    # dev tools
    rustc
    cargo
    gcc
    nodePackages.pnpm
    
    # nix
    nix-index
    nix-prefetch-git
    nixpkgs-fmt
    nixd

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
