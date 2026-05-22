{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ../../modules/core/ollama.nix
  ];

  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
}
