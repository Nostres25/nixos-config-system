{ ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];
  home-manager.users.nostres = import ./home-nostres;
}
