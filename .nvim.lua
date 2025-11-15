vim.lsp.config("nixd", {
   cmd = { "nixd" },
   settings = {
      nixd = {
         nixpkgs = {
            expr = "import <nixpkgs> { }",
         },
         options = {
            nixos = {
               expr = '(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.mihranDesktop.options',
            },
            home_manager = {
               expr = '(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.mihranDesktop.options.home-manager.users.type.getSubOptions []',
            },
         },
      },
   },
})
