{
  config,
  pkgs,
  ...
}: {
  # Since neovim-config changes so much I have decided to not include it in the nix config.
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    defaultEditor = true;
    # Packages to make available to Neovim
    extraPackages = with pkgs; [
      nixd
      nodejs
      lua-language-server
      luajitPackages.luarocks
      stylua
      alejandra
    ];
  };
}
