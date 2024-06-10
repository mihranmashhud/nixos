{
  lib,
  pkgs,
  inputs,
  namespace, # The namespace used for your flake, defaulting to "internal" if not set.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  config,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.gpu-passthrough;
  user = config.${namespace}.user;
in {
  options.${namespace}.gpu-passthrough = with types; {
    enable = mkBoolOpt false "Whether to enable gpu-passthrough configuration.";
    platform = mkOpt (enum ["amd" "intel"]) "amd" "Which CPU platform is being used.";
    vfioIDs = mkOpt (listOf str) [] "VFIO IDs of the GPU to passthrough";
  };

  config = mkIf cfg.enable {
    hardware.opengl.enable = true;
    boot = {
      initrd.kernelModules = mkBefore [
        "kvm-${cfg.platform}"
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];
      kernelParams = [
        "${cfg.platform}_iommu=on"
        "${cfg.platform}_iommu=pt"
        "kvm.ignore_msrs=1"
        ("vfio-pci.ids=" + builtins.concatStringsSep "," cfg.vfioIDs)
      ];
    };

    # Add a file for looking-glass to use later. This will allow for viewing the guest VM's screen in a
    # performant way.
    systemd.tmpfiles.rules = [
      "f /dev/shm/looking-glass 0660 ${user.name} qemu-libvirtd -"
    ];

    environment.systemPackages = with pkgs; [
      virt-manager
      looking-glass-client
    ];

    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        extraConfig = ''
          user="${user.name}"
        '';

        # Don't start any VMs automatically on boot.
        onBoot = "ignore";
        # Stop all running VMs on shutdown.
        onShutdown = "shutdown";

        qemu = {
          package = pkgs.qemu_kvm;
          ovmf = enabled;
          verbatimConfig = ''
            namespaces = []
            user = "+${builtins.toString user.uid}"
          '';
        };
      };
    };
    ${namespace}.user.extraGroups = [
      "qemu-libvirtd"
      "libvirtd"
      "disk"
    ];
  };
}
