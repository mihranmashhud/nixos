{
  mm,
  inputs,
  ...
}: {
  mm.gaming = {
    includes = [
      mm.gaming._
    ];
    nixos = {
      imports = with inputs; [
        nix-gaming.nixosModules.platformOptimizations
      ];
    };
    steam = {
      nixos = {pkgs, ...}: {
        environment.systemPackages = with pkgs; [
          sgdboop
          protontricks
        ];
        programs.steam = {
          enable = true;
          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
          localNetworkGameTransfers.openFirewall = true;
          remotePlay.openFirewall = true;
          extest.enable = true;
          protontricks.enable = true;
          platformOptimizations.enable = true;
          gamescopeSession.enable = true;
        };
        programs.gamescope.enable = true;
        hardware.graphics.enable32Bit = true;
        programs.gamemode.enable = true;
      };
      provides.to-users = {user, ...}: {
        users.users.${user.name}.extraGroups = ["gamemode"];
      };
    };
  };
  flake-file.inputs = {
    nix-gaming.url = "github:fufexan/nix-gaming";
  };
}
