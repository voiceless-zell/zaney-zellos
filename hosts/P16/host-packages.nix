{
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    audacity
    nvtopPackages.full
    nmap
    discord
    nodejs
    obs-studio
    obsidian
    inputs.nix-citizen.packages.${system}.star-citizen-helper
    inputs.nix-citizen.packages.${system}.lug-helper
    openra
    wine
  ];
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "dotnet-runtime-6.0.36"
  ];
}
