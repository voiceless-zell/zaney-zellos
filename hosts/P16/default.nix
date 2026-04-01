{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./starCitizen.nix
    ../../modules/core/ollama.nix
  ];
}
