{
  lib,
  inputs,
  namespace,
  snowfall-inputs,
}:
with lib; rec {
  modulo = number: divisor: number - divisor * (number / divisor);
  range = start: end: builtins.genList (x: x + start) (end - start);
  mkIfElse = p: yes: no:
    mkMerge [
      (mkIf p yes)
      (mkIf (!p) no)
    ];
}
