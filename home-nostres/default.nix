{ ... }:

{ # home configuration of my nostres user is linked here (~/.config/nixos/home-nostres/default.nix)

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "nostres";
  home.homeDirectory = "/home/nostres";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
  ./personal-data-vars.nix
  ./packages.nix
  ];

  
}
