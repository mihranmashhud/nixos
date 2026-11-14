{
  perSystem = {pkgs, ...}: {
    packages = {
      dualsense-udev-rules = pkgs.callPackage ./_dualsense-udev-rules.nix {};
      g920-wheel-udev-rules = pkgs.callPackage ./_g920-wheel-udev-rules.nix {};
      sb3-nvidia-pm-udev-rules = pkgs.callPackage ./_sb3-nvidia-pm-udev-rules.nix {};
      swap = pkgs.callPackage ./_swap.nix {};
      vial-udev-rules = pkgs.callPackage ./_vial-udev-rules.nix {};
    };
  };
}
