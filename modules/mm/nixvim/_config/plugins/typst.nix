{
  lib,
  namespace,
  inputs,
  pkgs,
  config,
  ...
}: {
  dependencies.typst.enable = true;
  lsp.servers.tinymist.enable = true;
  plugins.typst-preview.enable = true;
}
