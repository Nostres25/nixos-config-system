{ inputs, ... }:
{
  /*home-manager = {
    extraSpecialArgs = {inherit inputs; };
    users = {
      "nostres" = import ../../home-nostres/home.nix;
    };
  };*/

  home-manager."nostres" = {
    extraSpecialArgs = {inherit inputs; };
    users = {
      modules = [
        ../../home-nostres/home.nix
        inputs.self.outputs.homeManagerModules.default
      ];
    };
  };
}