{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./starCitizen.nix
    ../../modules/core/ollama.nix
  ];

  services.logind = {
    lidSwitch = "ignore";
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
  };
}
