{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ../../modules/core/ollama.nix
  ];
}
