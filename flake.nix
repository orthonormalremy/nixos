{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      hostname = nixpkgs.lib.fileContents ./hostname;
    in
    {
      nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.init.nix
          ./configuration.nix
        ];
        specialArgs = { inherit hostname; };
      };
    };
}
