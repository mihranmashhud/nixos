{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./kitty.nix
    ./bat.nix
    ./git.nix
    ./neovim.nix
    ./browsers.nix
    ./zsh.nix
    ./starship.nix
    ./imv.nix
    ./direnv.nix
    ./looking-glass.nix
  ];
  programs.git-credential-oauth.enable = true;
  programs.command-not-found.enable = true;
  services.xembed-sni-proxy.enable = true;
  services.ssh-agent.enable = true;
  services.syncthing.enable = true;
}
