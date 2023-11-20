{ scripts, ... }:
{
  home.packages = builtins.attrValues scripts;
}
