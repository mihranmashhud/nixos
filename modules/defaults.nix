{
  lib,
  den,
  mm,
  ...
}: {
  den.default.includes = [
    den.batteries.self'
    den.batteries.inputs'
  ];
  den.default.nixos = {
    nixpkgs.config = {
      allowUnfree = true;
    };
    home-manager.useGlobalPkgs = true;
    system.stateVersion = "26.05";
  };
  den.default.homeManager.home.stateVersion = "26.05";

  den.schema.host = {
    includes = [
      den.batteries.hostname
      mm.nix
    ];

    options = with lib;
    with lib.types; {
      device-type = mkOption {type = enum ["desktop" "laptop" "server"];};
      graphical = mkOption {
        type = bool;
        default = true;
      };
    };
  };

  den.schema.user = {
    includes = [
      den.batteries.host-aspects
      den.batteries.define-user
    ];

    options = with lib;
    with lib.types; {
      fullName = mkOption {type = str;};
      email = mkOption {type = str;};
      uid = mkOption {
        default = 1000;
        type = uniq int;
      };
    };

    # enable hm by default
    config.classes = lib.mkDefault ["homeManager"];
  };
}
