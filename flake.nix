{
  description = "ZaneyOS";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    username = "zell";
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    lib = nixpkgs.lib;

    hostNames = lib.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./hosts));

    mkHost = host: let
      inherit (import ./hosts/${host}/variables.nix) profile;
    in
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile;
          inherit pkgs-unstable;
        };
        modules = [./profiles/${profile}];
      };
  in {
    nixosConfigurations = lib.genAttrs hostNames mkHost;
  };
}
