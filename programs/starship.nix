{
  config,
  pkgs,
  ...
}: {
  programs.starship = {
    enable = true;
    settings =
      (with builtins; fromTOML (readFile ./starship-nf-symbols.toml))
      // {
        add_newline = true;
      };
  };
}
