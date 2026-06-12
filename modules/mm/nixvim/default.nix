{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    system = pkgs.system;
    nixvim = inputs.nixvim.legacyPackages.${system};
    nixvimModule = {
      module = import ./_config;
      extraSpecialArgs = {
        inherit inputs system;
      };
    };
  in {
    packages.nixvim = nixvim.makeNixvimWithModule nixvimModule;
  };

  mm.dev.nixvim.homeManager = {self', ...}: {
    home.packages = with self'.packages; [
      nixvim
    ];
    home.sessionVariables = {
      EDITOR = "nvim";
      MANPAGER = "nvim +Man!";
    };
    home.shellAliases = {
      vi = "nvim";
      vim = "nvim";
      vimdiff = "nvim -d";
    };
  };

  flake-file.inputs = {
    nixvim.url = "github:mihranmashhud/nixvim";
  };
}
