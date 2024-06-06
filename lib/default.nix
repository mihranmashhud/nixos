{
  lib,
  inputs,
  namespace,
  snowfall-inputs,
}:
with lib; rec {
   modulo = number: divisor: number - divisor * (number / divisor);
}
