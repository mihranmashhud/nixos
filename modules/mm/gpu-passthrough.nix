{lib, ...}: {
  mm.gpu-passthrough = {
    platform,
    vfioIDs,
  }: {
    nixos = {pkgs, ...}: {
      hardware.graphics.enable = true;
      hardware.amdgpu.initrd.enable = lib.mkIf (platform == "amd") false;
      boot = {
        initrd.kernelModules = lib.mkBefore [
          "kvm-${platform}"
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
        ];
        kernelParams = [
          "${platform}_iommu=on"
          "${platform}_iommu=pt"
          "kvm.ignore_msrs=1"
          ("vfio-pci.ids=" + builtins.concatStringsSep "," vfioIDs)
        ];
      };

      environment.systemPackages = with pkgs; [
        virt-manager
        looking-glass-client
      ];
    };
    provides.to-users = {user, ...}: {
      nixos = {pkgs, ...}: {
        # Add a file for looking-glass to use later. This will allow for viewing the guest VM's screen in a
        # performant way.
        systemd.tmpfiles.rules = [
          "f /dev/shm/looking-glass 0660 ${user.name} qemu-libvirtd -"
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
              verbatimConfig = ''
                namespaces = []
                user = "+${toString user.uid}"
              '';
            };
          };
        };
        users.users.${user.name}.extraGroups = [
          "kvm"
          "libvirt"
          "input"
          "qemu-libvirtd"
          "libvirtd"
          "disk"
        ];
      };
    };
  };
}
