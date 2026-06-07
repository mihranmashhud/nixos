{
  lib,
  den,
  mm,
  ...
}: {
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
      mm.system
      mm.nix
    ];
  };

  den.schema.user = {
    includes = [
      den.batteries.host-aspects
      den.batteries.define-user
    ];
    # enable hm by default
    classes = lib.mkDefault ["homeManager"];
  };
}
