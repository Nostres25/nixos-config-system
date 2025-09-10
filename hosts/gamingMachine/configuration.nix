# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../default/configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    # The Nano editor is also installed by default.
    # Missing packages: 
    # - marionnet (https://www.marionnet.org/site/index.php/)
    # - Game Maker Studio 2 (https://gamemaker.io/fr/blog/introducing-gamemaker-studio-2)
    # - pnpm2nix or bun2nix 

    # monitoring system
    monitorets
    mission-center
  ];

}
