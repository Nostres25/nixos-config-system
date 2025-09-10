# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../default/configuration.nix
  ];

  # Attempt to fix sound on unowhy Y13 laptop (initially a driver issue on windows but on linux it's... different ?)
  # hardware.enableAllFirmware  = true; # useless ?
  boot.extraModprobeConfig = ''
    options snd-intel-dspcfg dsp_driver=1
  '';

}
