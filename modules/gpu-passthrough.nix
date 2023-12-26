{...}: let
  nvidiaGpuIDs = [
    "10de:1f82" # Graphics
    "10de:10fa" # Audio
  ];
in {
  boot.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"

    "amdgpu"
  ];
  boot.kernelParams = [
    "amd_iommu=on"
    ("vfio-pci.ids=" + builtins.concatStringsSep "," nvidiaGpuIDs)
  ];
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd.enable = true;
  };
  programs.virt-manager.enable = true;
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 mihranmashhud kvm -"
  ];
}
