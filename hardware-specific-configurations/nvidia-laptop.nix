{ config, pkgs, ... }:
/* TODO need to lean flakes & modularize nixos
let nvidia-offload = pkgs.writeShellScriptBin "nbidia-offload" ''
  export __NV_PRIME_RENDER_OFFLOAD=1
  export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
  export __GLX_VENDOR_LIBRARY_NAME=nvidia
  export __VK_LAYER_NV_optimus=NVIDIA_only
  exec "$@"
  '';
in*/ {


  
  # For offloading, `modesetting` is needed additionally,
  # otherwise the X-server will be running permanently on nvidia,
  # thus keeping the GPU always on (see `nvidia-smi`).
  # (For hybrid graphics configurations inte/nvidia or amd/nvidia)
  services.xserver.videoDrivers = [
    "modesetting"  # example for Intel iGPU; use "amdgpu" here instead if your iGPU is AMD
    "nvidia"
  ];
  
  # Nvidia driver configuration - More details here --> https://nixos.wiki/wiki/Nvidia
  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true; # Activate that have fixed waking up from stand by freezes

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = true; # true only for an older architecture than Turing (older than the RTX 20-Series). 

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Only for laptop with hybrid graphics configuration (intel/nvidia or amd/nvidia) :
    # Nvidia Optimus PRIME configuration
    prime = {
      # Make sure to use the correct Bus ID values for your system with "sudo lshw -c display" command
      # Watch out for the formatting; convert them from hexadecimal to decimal, remove the padding (leading zeroes), replace the dot with a colon :
      # 00:02.0 --> 0:2:0
      # 01:00.0 --> 1:0:0
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
      # amdgpuBusId = "PCI:54:0:0"; For AMD GPU

      # To use Nvidia GPU only for required app
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # More performance but constantly more power consumption. Incompatible with offload mode
      sync.enable = false;
    };
  };


  # Nvidia Optimus PRIME compatibilities with steam
  nixpkgs.config.nvidia.acceptLicense = true;
  programs.steam.package = pkgs.steam.override {
      extraPkgs = pkgs': with pkgs'; [ bumblebee primus ];
  }; 

  # fan control
  environment.systemPackages = with pkgs; [ 
    nbfc-linux # read: https://github.com/nbfc-linux/nbfc-linux
 ];
}