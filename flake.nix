{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgsUnstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    
    # To make home manager using the global nixpkgs source
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; 
  };

  outputs = {nixpkgs, ... } @ inputs: 
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
    pkgsUnstable = inputs.nixpkgsUnstable.legacyPackages.x86_64-linux;
  in
  {

    nixosConfiguration.nixos-nostres-UnowhyY13 = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
      ];
    };

    nixosConfiguration.nixos-nostres-AN515 = nixpkgs.lib.nixosSystem {
      modules = [
        ./configuration.nix
      ];
    };

    # nix run .#default or nix run
    packages.x86_64-linux.hello = pkgs.hello;

    # nix run .#hello
    packages.x86_64-linux.default = pkgs.hello;

    # nix develop
    devShells.x86_64-linux.default = pkgs.mkShell {
      buildInputs = [ pkgs.neovim ];
    };

  };
}
