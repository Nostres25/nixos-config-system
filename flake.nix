{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgsUnstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";

      # To not download two different versions of nixpkgs
      inputs.nixpkgs.follows = "nixpkgs"; 
    };
  };

  outputs = {self, nixpkgs, ... } @ inputs: 
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
    /*pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };*/
    pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-linux;
  in
  {

    nixosConfigurations = {
      default = lib.nixosSystem {
        #extraSpecialArgs = { inherit inputs; };
        modules = [
          ./hosts/default/configuration.nix
          inputs.home-manager.nixosModules.default
        ];

        homeManagerModules.default = ./modules/home-manager;

      };  

      lowPowerMachine = lib.nixosSystem {
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./hosts/lowPowerMachine/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };  

      gamingMachine = lib.nixosSystem {
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./hosts/gamingMachine/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };  
    };
    /*
    # nix run .#default or nix run
    packages.x86_64-linux.hello = pkgs.hello;

    # nix run .#hello
    packages.x86_64-linux.default = pkgs.hello;

    # nix develop
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [ pkgs.neovim ];
    };*/

  };
}
