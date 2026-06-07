{
  mm.nix = {
    nixos = {pkgs, ...}: {
      environment.systemPackages = with pkgs; [
        alejandra
      ];
      programs.nix-index.enable = true;
      programs.nix-ld.enable = true;

      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
            "pipe-operators"
          ];

          download-buffer-size = 524288000;
          http-connections = 50;
          log-lines = 50;
          warn-dirty = false;
          auto-optimise-store = true;
          accept-flake-config = true;
        };
        gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 30d";
        };
      };
    };
    provides.to-users = {user, ...}: let
      users = ["root" user.name];
    in {
      nixos = {
        nix = {
          settings = {
            trusted-users = users;
            allowed-users = users;
          };
        };
      };
    };
  };
}
