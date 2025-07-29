{ ... }:
{
  imports = [
    ./nvidia-laptop.nix
  ];

  # Disable automatic mouse sleep mode 
  boot.kernelParams = [ 
    # example kernel module parameter
    "usbcore.autosuspend=-1"
  ];
}