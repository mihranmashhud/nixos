{...}: {
  programs.zsh.shellAliases = {
    cd = "z";
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
}
