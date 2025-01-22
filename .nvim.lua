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
               expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.mihranDesktop.options',
            },
            home_manager = {
               expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."mihranmashhud@mihranDesktop".options',
            },
         },
      },
   },
})
