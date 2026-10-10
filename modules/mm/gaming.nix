{
  mm,
  inputs,
  ...
}: {
  mm.gaming = {
    includes = [
      mm.gaming.steam
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
        nixos.users.users.${user.name}.extraGroups = ["gamemode"];
      };
    };
    stream-server = {
      nixos = {
        services.moonshine = {
          enable = true;
          user = "mihranmashhud";
          settings = {
            application = [
              {
                title = "Steam";
                command = [
                  "/run/current-system/sw/bin/steam"
                  "steam://open/bigpicture"
                ];
              }
            ];
          };
        };
        users.users.mihranmashhud.extraGroups = ["input"];
      };
    };
    stream-client = {
      nixos = {
        programs.moonlight-qt = {
          enable = true;
          capSysNice = true;
        };
      };
    };
  };
  flake-file.inputs = {
    nix-gaming.url = "github:fufexan/nix-gaming";
    moonshine.url = "github:hgaiser/moonshine";
  };
}
