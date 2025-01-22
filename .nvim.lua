local nvim_lsp = require("lspconfig")
nvim_lsp.nixd.setup({
   cmd = { "nixd" },
   settings = {
      nixd = {
         nixpkgs = {
            expr = "import <nixpkgs> { }",
         },
         options = {
            nixos = {
               expr = '(builtins.getFlake "/home/mihranmashhud/nixos").nixosConfigurations.mihranDesktop.options',
            },
            home_manager = {
               expr = '(builtins.getFlake "/home/mihranmashhud/nixos").homeConfigurations."mihranmashhud@mihranDesktop".options',
            },
         },
      },
   },
})
