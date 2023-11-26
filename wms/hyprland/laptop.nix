{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hypr.nix
  ];
  wayland.windowManager.hyprland = {
    settings = {
      misc = {
        vfr = true;
      };
      exec-once = [
        "waybar -c ~/.config/waybar/laptop-config.json > /tmp/waybar.log &"
      ];
      monitor = ",highrr,auto,1";
    };
  };
}
