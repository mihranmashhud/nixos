return {
	cmd = { "nixd" },
	file_types = {
		"nix",
	},
	root_markers = {
		"flake.nix",
		".git",
	},
	settings = {
		nixd = {
			nixpkgs = {
				expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs {}",
			},
			options = {
				nixos = {
					expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.mihranDesktop.options",
				},
				home_manager = {
					expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.mihranDesktop.options.home-manager.users.type.getSubOptions []",
				},
				nixvim = {
					expr = "(builtins.getFlake (builtins.toString ./.)).packages.${system}.nixvim.options",
				},
			},
		},
	},
}
