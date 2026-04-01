{
  pkgs,
  inputs,
  pkgs-unstable,
  ...
}: {
  environment.systemPackages =
    (with pkgs; [
      audacity
      nvtopPackages.full
      nmap
      discord
      nodejs
      obs-studio
      obsidian
      wine
      kdePackages.plasma-thunderbolt
      openra
      libreoffice
    ])
    ++ (with pkgs-unstable; [
      inputs.nix-citizen.packages.${pkgs.system}.star-citizen-helper
      inputs.nix-citizen.packages.${pkgs.system}.lug-helper
    ]);
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "dotnet-runtime-6.0.36"
  ];
}
