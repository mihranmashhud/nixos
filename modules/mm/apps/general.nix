{
  mm.apps.general = {
    nixos = {
      nixpkgs.config.permittedInsecurePackages = [
        "electron-39.8.10" # for bitwarden-desktop
      ];
    };
    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        kdePackages.dolphin # file manager
        nautilus
        gnome-calculator # calculator
        warpinator # send files around
        obsidian # note taking
        mpv # video/music player
        inkscape # vector editing
        darktable # lighttable editor/darkroom
        transmission_4-gtk # torrenting
        transmission-remote-gtk # remote Transmission control
        teams-for-linux
        cheese # webcam viewer
        kdePackages.partitionmanager # drive management
        bitwarden-desktop # password management
        _1password-gui # password management
        impression # live usb creation tool
        papers # PDF viewer
        seafile-client # file sharing via home server
        deluge

        libreoffice-qt # office Apps
        hunspell
        hunspellDicts.en_US
        hunspellDicts.en_CA
        imv
      ];
    };
  };
}
