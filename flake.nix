{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      disko,
      ...
    }:
    let
      hostname = nixpkgs.lib.fileContents ./hostname;
    in
    {
      nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
        modules = [
          disko.nixosModules.disko
          ./disko-config.nix
          ./configuration.init.nix
          ./configuration.nix
        ];
        specialArgs = { inherit hostname; };
      };
    };
}
