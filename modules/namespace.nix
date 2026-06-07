{inputs, den, ...}: {
  imports = [ (inputs.den.namespace "mm" true) ];
  _module.args.__findFile = den.lib.__findFile;
}
