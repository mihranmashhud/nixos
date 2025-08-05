{
  writeShellApplication,
}:
writeShellApplication {
  name = "swap";
  text =
    /*
    bash
    */
    ''
      mv "$1" "$1._tmp" && mv "$2" "$1" && mv "$1._tmp" "$2";
    '';
}
