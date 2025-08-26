# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, lib, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ./display.nix
    ./home-manager.nix
  ];
  hardware.enableAllFirmware  = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # ... your Open GL, Vulkan and VAAPI drivers
      
      # Intel Graphics Quick Sync Video :
      # more details : https://nixos.wiki/wiki/Intel_Graphics
      # vpl-gpu-rt          # for newer GPUs on NixOS >24.05 or unstable, with Xe graphics
      # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
      intel-media-sdk   # for older GPUs, with intel graphics, like with Tiger Lake for AN515-57 with i5 11400H
    ];
  };

  # Auto updating
  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
  };

  # Auto cleanup
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  nix.settings.auto-optimise-store = true;

  # To enable flakes
  nix.extraOptions = ''experimental-features = nix-command flakes'';

  # Bootloader.
  #  For dual boot
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
    };
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };

  networking.hostName = "nixos-nostres"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    nostres = {
      isNormalUser = true;
      description = "nostres";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
      ];
      /*
        packages = with pkgs; [ # Using home manager ?
          thunderbird
        ];
      */
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable docker
  # more details on https://nixos.wiki/wiki/Docker
  virtualisation.docker = {
    enable = true;
    daemon.settings = { 
      fixed-cidr-v6 = "fd00::/80";
      ipv6 = true; 
      live-restore = true;
    };
  };

  # Enable virtualbox 
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # The Nano editor is also installed by default.
    # Missing packages: 
    # - marionnet (https://www.marionnet.org/site/index.php/)
    # - Game Maker Studio 2 (https://gamemaker.io/fr/blog/introducing-gamemaker-studio-2)
    # - pnpm2nix or bun2nix 


    # Dev
    nodejs
    pnpm
    husky
    postgresql
    jdk21
    eclipses.eclipse-jee
    
    # CLI
    git
    zsh
    btop
    zip
    unzip
    wget

    # To make nix configuration easier
    nixfmt-rfc-style # Nix formatter
    nixd # Another nix language server

    # for everyone
    libreoffice
    gimp

    # for disk formatting
    gparted

    # To run windows app
    wineWowPackages.stable

    # Virtual device
    virtualbox
    
    # To display upgrades
    nvd

    # monitoring system
    monitorets
    mission-center
  ];
  
  # Script for display upgrades
  system.activationScripts.report-changes = ''
      PATH=$PATH:${lib.makeBinPath [pkgs.nvd pkgs.nix]}
      nvd diff $(ls -d1v /nix/var/nix/profiles/system-*-link|tail -n 2)
    '';

  # TODO if using flakes nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  programs.zsh.enable = true;
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;

  # see https://nixos.wiki/wiki/Fwupd
  services.fwupd.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # power management for laptop
  services.power-profiles-daemon.enable = false; # conflict with tlp & cpufreq
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
    battery = {
      governor = "powersave";
      turbo = "never";
    };
    charger = {
      governor = "performance";
      turbo = "auto";
    };
  };


  powerManagement.powertop.enable = true;

  hardware.bluetooth.powerOnBoot = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.niiix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
