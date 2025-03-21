{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    audacity
    nmap
    discord
    nodejs
    obs-studio
    obsidian
    inputs.nix-citizen.packages.${system}.star-citizen-helper
    inputs.nix-citizen.packages.${system}.lug-helper
    openra
    transmission_4
    wine
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "dotnet-runtime-6.0.36"
  ];
}
