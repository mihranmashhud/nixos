{
  usb-modeswitch,
  writeTextFile,
}:
writeTextFile {
  name = "g920-wheel-udev-rules";
  text = ''
    # Logitech G920 Racing Wheel
    ATTR{idVendor}=="046d", ATTR{idProduct}=="c261", RUN+="${usb-modeswitch}/bin/usb_modeswitch -v 046d -p c261 -M 0f00010142 -C 0x03 -m 01 -r 01"
  '';
  destination = "/etc/udev/rules.d/99-g920-wheel.rules";
}
