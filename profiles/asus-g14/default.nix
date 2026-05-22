{host, ...}: {
  imports = [
    ../../hosts/${host}
    ../../modules/drivers
    ../../modules/core
  ];

  # The G14 GA401IV hardware module from nixos-hardware owns the AMD+iGPU,
  # NVIDIA Turing, PRIME offload bus IDs, asusd, and laptop/SSD defaults.
  # Keep the repo-local generic GPU driver toggles off here so they do not
  # override those upstream hardware-specific defaults.
  drivers.amdgpu.enable = false;
  drivers.nvidia.enable = false;
  drivers.nvidia-prime.enable = false;
  drivers.intel.enable = false;
  vm.guest-services.enable = false;
}
