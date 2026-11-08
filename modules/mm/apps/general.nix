{
  mm.apps.general = {
    nixos = {
      nixpkgs.config.permittedInsecurePackages = [
      ];
      programs.localsend = {
        enable = true;
        openFirewall = true;
      };
    };
    homeManager = {pkgs, ...}: {
      home.packages = with pkgs; [
        kdePackages.dolphin # file manager
        nautilus
        obsidian # note taking
        mpv # video/music player
        inkscape # vector editing
        cheese # webcam viewer
        kdePackages.partitionmanager # drive management
        impression # live usb creation tool
        papers # PDF viewer
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
