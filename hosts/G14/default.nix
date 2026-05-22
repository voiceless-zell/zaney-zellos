{inputs, ...}: {
  imports = [
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga401iv
    ./hardware.nix
    ./host-packages.nix
  ];
}
