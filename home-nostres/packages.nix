{ pkgs, config, ... }:
{
  # Allow unfree packages in home
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    discord
    steam
    thunderbird
    
    octave # i just want to try it

    /*(pkgs.dockerTools.buildImage {
      name = "hello-docker";
      config = {
        Cmd = [ "a/bin/hello" ];
      };
    })*/

    # obs with plugins
    (pkgs.wrapOBS {
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      #obs-vaapi #optional AMD hardware acceleration
      obs-gstreamer
      #obs-vkcaptur doesn't works because ???
      ];
    })

  ];

  # Program configurations
  programs = {


    firefox = {
      enable = true;
      languagePacks = [ "fr" "en-US" ];

      /* ---- POLICIES ---- */
      # Check about:policies#documentation for options.
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisableFirefoxAccounts = true;
        DisableAccounts = true;
        DisableFirefoxScreenshots = true;
        OverrideFirstRunPage = "";
        OverridePostUpdatePage = "";
        DontCheckDefaultBrowser = true;
        DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
        DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
        SearchBar = "unified"; # alternative: "separate"
        SearchEngines = {
          # Doesn't works
          Default = "Ecosia search"; # Name of the search engine like it's writed in firefox settings
        };

        /* ---- EXTENSIONS ---- */
        # Check about:support for extension/add-on ID strings.
        # Valid strings for installation_mode are "allowed", "blocked",
        # "force_installed" and "normal_installed".
        ExtensionSettings = {
          "*".installation_mode = ""; # blocks all addons except the ones specified below
          # uBlock Origin:
          "uBlock0@raymondhill.net" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
            installation_mode = "normal_installed";
          };
          # Dark Reader:
          "addon@darkreader.org" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
            installation_mode = "normal_installed";
          };
          # Bitwarden: doesn't works
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden_password_manager/latest.xpi";
            installation_mode = "normal_installed";
          };

          # Ecosia
          "{d04b0b40-3dab-4f0b-97a6-04ec3eddbfb0}" = {
            install_url = "https://addons.mozilla.org/firefox/downloads/file/4519632/ecosia_the_green_search-6.0.0.xpi";
            installation_mode = "normal_installed";
          };
        };
      };
    };

    zsh = {
      enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = { # Todo change for nixos-config-system
        ll = "ls -l";
        update = "sudo nixos-rebuild switch";
        nixconf = "codium ~/.config/nixos";
      };
      history.size = 10000; 

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
        ];
        theme = "robbyrussell";
      };
    };


    git = {
      enable = true;
      userName = "Nostres25";
      userEmail = config.variables.email;
    };
  };
}