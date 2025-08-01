**Bienvenue dans ma configuration NixOs !**
Ce document contient :
- [Une brève présentation de Nix et NixOs](#introduction-à-nix-et-à-nixos)
- [Une présentation détaillée de l'organisation de mon système NixOs](#organisation-du-système)
- [Enfin une liste des problématiques rencontrées avec les solutions trouvées](#problématiques-rencontrées)

# Introduction à Nix et à NixOs

Si vous ne connaissez pas, NixOs est une [distributions linux](https://fr.wikipedia.org/wiki/Distribution_Linux) pas comme les autres.</br>
En effet, contrairement à la plupart des distributions linux, il ne respecte pas [la norme de la hiérarchie des systèmes de fichiers (FHS)](https://fr.wikipedia.org/wiki/Filesystem_Hierarchy_Standard).</br>
Il est basé sur le [gestionnaire de paquets Nix](https://fr.wikipedia.org/wiki/Nix_(gestionnaire_de_paquets)), qui promet la reproductibilité, la robustesse, la portabilité et la stabilité. On a l'habitude de le présenter comme un système qu'on peut coder. C'est-à-dire que sa configuration est déclarative.</br>
Pour en savoir plus, je vous invite à vous renseigner sur [NixOs](https://fr.wikipedia.org/wiki/NixOS) et [Nix](https://fr.wikipedia.org/wiki/Nix_(gestionnaire_de_paquets)) à travers wikipedia, des vidéos ou autre.
###### Car oui, le gestionnaire de paquets Nix est également utilisable sur les autres distributions linux

## Nix/NixOs : difficile et chronophage ?

J'ai découvert NixOs grâce à un bon ami qui m'en a parlé. J'ai par la suite souhaité l'essayer, pour finir par l'adopter !
Ma crainte initiale était qu'il faille passer par des étapes compliquées et/ou très chronophages pour installer le moindre paquet ou pour changer de petites options.</br>
Et en effet NixOs demande un certain temps de compréhension et requiert beaucoup de temps pour le personnaliser exactement comme on le souhaite, en passant par des paramètres avancés. Surtout si on tient à tout configurer en déclaratif afin d'avoir un système reproductible au maximum.

Mais en réalité ce n'est pas une nécéssité. Si on installes NixOs avec un [environnement de bureau](https://fr.wikipedia.org/wiki/Environnement_de_bureau) comme Gnome ou Plasma KDE, le système sera **en apparence** identique à un autre système linux utilisant le même environnement de bureau. Firefox y est préinstallé et beaucoup de paramètres sont modifiables via l'application "Paramètres". La différence se situe surtout dans la gestion des paquets et dans les options du système qu'on souhaite reproductibles.
###### Les paramètres modifiés via les applications, les différents paquets ou depuis l'application "Paramètres" ne seront pas dans la configuration Nix et ne seront donc pas exportés si vous transférez votre configuration Nix dans un autre appareil. (ce qui est l'un des avantages de Nix)

Par exemple, pour ajouter un paquet de manière déclarative il faut l'ajouter dans le fichier de configuration `/etc/nixos/configuration.nix`. Mais c'est très simple. Cela ne demande que de chercher l'existence du paquet et son nom exact (sur [MyNixOs](https://mynixos.com/) par exemple) et d'ajouter une ligne dans un fichier pré-remplit. 
Si on souhaite modifier une option de manière déaclarative, on va devoir chercher cette option sur [MyNixOs](https://mynixos.com/) ou plus largement sur internet concernant des paquets spécifiques. Sachant qu'il y a beaucoup de guides sur le [Wiki NixOs](https://wiki.nixos.org/wiki/NixOS_Wiki/fr) et le [manuel NixOs](https://nixos.org/manual/nixos/stable/).
Et si installer des applications via Nix pose problème pour x ou y raison. Il est possible [d'utiliser les flatpaks](https://nixos.wiki/wiki/Flatpak).

La difficulté se présente surtout lorsque certaines solutions qu'on trouve sur internet ne concernent que les configurations avec un [home manager](https://nixos.wiki/wiki/Home_Manager) ou les [flakes](https://wiki.nixos.org/wiki/Flakes) alors que ce n'est pas votre cas ou inversement.
Même s'il est recommandé d'utiliser un home-manager et les flakes pour un meilleur système, avec plus de possibilités.
###### Même si lorsque j'écris ce document les flakes sont experimentaux, ils sont fiables et beaucoup les utilisent. Ils permettent d'ailleurs une meilleur stabilité du système.


## Organisation du système

## État du système
Tout d'abord et pour faire court, mon système utilise Gnome comme environnement de bureau, un [home manager](https://nixos.wiki/wiki/Home_Manager), et je compte utiliser les flakes à l'avenir. Pour débloquer de nouvelles fonctionnalités, pour garantire une meilleure staibilité de mon système et pour maîtriser davantage Nix.

## Développement Nix
je tiens à préciser que par souci de praticité, j'ai une organisation un peu particulière pour ma configuration Nix.
J'utilise `vscodium` (Vscode) pour modifier ma configuration NixOs et pour cela j'ai dû déplacer mes fichiers de configuration Nix dans le répertoire personnel de mon compte utilisateur (plus précisément dans `~/.config/nixos`).

Mon fichier `/etc/nixos/configuration.nix` ressemble désormais à ceci:
```nix
{ config, pkgs, ... }:
{
  imports =
    [ # Répertoire dans lequel se trouve tous mes fichiers de configuration nixos
      /home/nostres/.config/nixos
    ]; 
}
```
###### Vous l'aurez remarqué, l'importation se fait depuis un répertoire. Dans cette situation, cela prend en réalité le fichier `default.nix` présent dans ce répertoire. 

Et j'ai du rediriger la configuration de mon utilisateur (nostres) vers `~/.config/nixos/home-nostres` à l'aide de cette ligne dans [`home-manager.nix`](./home-manager.nix):
```nix
{
  home-manager.users.nostres = import ./home-nostres;
}
```


Trouvant la configuration NixOs archaïque, j'ai cherché à simplifier la configuration en Nix avec des outils supplémentaires.
J'ai donc :
1. installé l'extension Vscode Nix IDE
2. ajouté le formateur nix [`nixfmt-rfc-style`](https://github.com/NixOS/nixfmt) dans les paquets à installer
3. pareil pour le serveur de langage Nix [`nixd`](https://github.com/nix-community/nixd) (mais il y a aussi `nil`)
4. configuré le fichier settings.json de l'extension Nix IDE comme ceci:
```json
{
  "nix.serverPath": "nixd",
  "nix.enableLanguageServer": true,
  "nixpkgs": {
    "expr": "import <nixpkgs> { }"
  },
  "formatting": {
    "command": [
      "nixfmt"
    ]
  },
  "nix.formatterPath": "nixfmt"
}
```

Et ça me fait de l'auto-complétion, de la correction syntaxique et du formattage de code automatique pour Nix !

## Problématiques rencontrées
Pour "Déplacer le fichier .home.nix avec un home manager", "Coder sa configuration nix avec vscode (ou vscodium)", "Coder avec plusieurs fichiers Nix / importer des fichiers Nix" ou "Simplifier le code Nix / utiliser un formatteur Nix / utiliser un LSP Nix", la solution se trouve dans la partie [Développement](#développement-nix) juste au dessus

Pour les problèmes et astuces autour des ordinateurs portables, il y a [une page dédiée aux ordinateurs portables](https://nixos.wiki/wiki/Laptop) sur le wiki de NixOs.

### Vscodium/Vscode: Définir des extensions et paramètres utilisateur (userSettings)
Pour cela ajoutez dans votre fichier utilisateur (`home.nix`) ceci:
```nix
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium; # à remplacer par pkgs.vscode si vous ne voulez pas de vscodium
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        # ... <-- Vos extensions. Format: <éditeur>.<nom>. Vous pouvez la trouver sur https://mynixos.com/packages/vscode-extensions/2
        # Exemple:
        jnoortheen.nix-ide
      ];
      
      userSettings = {
        # ... <-- Paramètres vscode comme dans le fichier settings.json
        # Exemple:
        "nix.serverPath" = "nixd";
        "nix.enableLanguageServer" = true;
        "nixpkgs" = {
          "expr" ="import <nixpkgs> { }";
        };
        "formatting" = {
          "command" = [
            "nixfmt"
          ];
        };
        "nix.formatterPath" = "nixfmt";
        "git.autofetch" = true;
        "update.showReleaseNotes" = false;
      };
    };
  };
}
```

> [!INFO]
> Si vous avez une erreur du service du home manager lorsque vous faites `sudo nixos-rebuild switch`, c'est probablement parce que vous aviez déjà ouvert vscodium/vscode et que le home manager n'arrive pas à remplacer le fichier `settings.json` existant. Pour régler cela vous devez supprimer le fichier `~/.config/VSCodium/User/settings.json` ou le fichier rm `/home/nostres/.config/VSCode/User/settings.json` pour VsCode.



### Laptop: Arrêt du chargement de la batterie à 80% pour préserver sa durée de vie
Solution trouvée : 
```nix
{
  services.power-profiles-daemon.enable = false; #Désactivé pour éviter les conflits avec tlp
  services.tlp = {
      enable = true;
      settings = {

        START_CHARGE_THRESH_BAT0 = 40; # à 40% et en dessous, il commencer le chargement
        STOP_CHARGE_THRESH_BAT0 = 80; # à 80% et au desssus il arrête le chargement

      };
  };
}
```
Seulement, mon ordinateur portable (Unowhy Y13) n'est pas compatible en vu de ses pilotes de gestion de la batterie :/

### Définir des extensions firefox
Pour la configuration Nix de firefox en général, je vous invite à regarder ma configuration dans le fichier [`home-nostres/packages.nix`](./home-nostres/packages.nix). Ici on s'intéresse surtout à l'ajout d'extensions firefox en déclaratif.</br>
La solution est la suivante:

```nix
{
  # [...]
  programs.firefox = {
    enable = true;

      /* ---- EXTENSIONS ---- */
      # - installation_mode ne prend que: "allowed", "blocked",
      #   "force_installed" ou "normal_installed".
      ExtensionSettings = {
        "*".installation_mode = ""; # blocks all addons except the ones specified below

        # Format:
        # "<extensionID>" = {
        #   install_url = "<extension_url>"
        #   insallation_mode = "<installation_mode>"
        # }

        # Exemples:
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
        # Bitwarden:
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden_password_manager/latest.xpi";
          installation_mode = "normal_installed";
        };

        # Ecosia search
        "{d04b0b40-3dab-4f0b-97a6-04ec3eddbfb0}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4519632/ecosia_the_green_search-6.0.0.xpi";
          installation_mode = "normal_installed";
        };
      };
    };
}
```

1. Pour récupérer l'identifiant des extensions déjà installées, mettez "about:support" dans la barre d'URL.
2. Pour récupérer l'URL de l'extension, rendez-vous sur la page https://addons.mozilla.org/fr/firefox/ de l'extension voulue, puis copier le lien du bouton "ajouter". 
> [!TIP]
> Vous allez ensuite très probablement récupérer un lien comme celui ci: `https://addons.mozilla.org/firefox/downloads/file/<fichierId>/<extensionNom>-<numéroVersion>.xpi`. Ce lien fonctionnera mais si vous souhaitez garantire de toujours avoir la dernière version de l'extension sans changer l'URL, vous pouvez reprendre le nom de l'extension dans l'url récupérée pour l'utiliser dans l'url suivante: `https://addons.mozilla.org/firefox/downloads/latest/<extensionNom>/latest.xpi`. Toutefois j'ai observé que l'extension latest n'existe pas pour toutes les extensions comme pour Ecosia par exemple. 


### Définir un moteur de recherche par défaut (ex: Ecosia)
Pour la configuration Nix de firefox en général, je vous invite à regarder ma configuration dans le fichier [`home-nostres/packages.nix`](./home-nostres/packages.nix). Ici on s'intéresse surtout au paramétrage du moteur de recherche par défaut.</br>
La solution est la suivante:

```nix
{
  # [...]
  programs.firefox = {
    enable = true;

    /* ---- POLICIES ---- */
    # Mettez "about:policies#documentation" dans la barre d'URL pour plus d'options.
    policies = {
      SearchEngines = {
        Default = "Ecosia search"; # Nom du moteur de recherche affiché dans les paramètres firefox
      };
    };
  };
}
```

Ecosia, n'est pas installé par défaut sur firefox. Ainsi, si vous souhaitez utiliser un moteur de recherche autre comme Ecosia, il faut également l'ajouter en tant qu'extension [comme cela a été fait juste au dessus](#définir-des-extensions-firefox).



### Définir des variables utilisables dans d'autres fichiers Nix.
J'ai cherché à définir des variables dans un fichier pour les utiliser dans d'autres fichiers pour des raisons de confidentialité.
En effet, j'ai besoin de certaines données personnelles dans ma configuration mais je ne souhaite pas qu'elles soient présentes sur ce GitHub affichant publiquement ma configuration Nix.

La solution trouvée est d'ajouter un fichier `personal-data-vars.nix` qui contient ceci:
```nix
{ lib, ... }:
{
  options = {
    variables = lib.mkOption {
      type = lib.types.attrs;
      default = { };
    };
  };

  # Initialisation des variables
  # Format: config.variables.<nom> = valeur;
  # Ex:
  config.variables.username = "nostres";
  config.variables.email = "maconfig@nixos.com";
}
```

Les variables définies sont ensuites utilisables dans d'autres fichier à condition que le fichier `personal-data-vars.nix` soit importé au préalable.

Par exemple dans `packages.nix`:
```nix
{ pkgs, config, ... }:
{
  imports = [
    ./personal-data-vars.nix
  ];

  programs.git = {
    enable = true;
    userName = config.variables.username;
    userEmail = config.variables.email;
  };
}
```

Et pour ne pas publier `personal-data-vars.nix` publiquement, j'ai crée un fichier `.gitignore` dans lequel j'ai ajouté une ligne `personal-data-vars.nix` 

### Régler des freeze récurrents lors de la saturation de la mémoire vive (RAM)
La solution a été d'ajouter [un swap](https://fr.wikipedia.org/wiki/Espace_d%27%C3%A9change). Voici comment: 

`hardware-configuration.nix`
```nix
{
  swapDevices = [{
    device = "/swapfile";
    size = 8 * 1024; # 8GB
  }];

  # [...]
}
```
Vous devrez ensuite redémarrer votre appareil après avoir exécuté `sudo nixos-rebuild switch` pour activer le swap.


### Pouvoir définir une échelle d’affichage plus précise sur Gnome
Par défaut, à l'installation de NixOs, je pouvais définir uniquement 100% ou 200% comme échelle d'affichage.</br>
Pour pouvoir définir une échelle plus précise sur Gnome. Comme 125%, j'ai du faire ceci:

`gnome.nix`
```nix
{ pkgs, ... }:
{
# Enable the GNOME Desktop Environment.
  services.xserver = {
  enable = true;
  displayManager.gdm = {
    enable = true;
    wayland = true;
  };
  desktopManager.gnome = {
    enable = true;
      
      # To enable fractional scaling
      extraGSettingsOverridePackages = [ pkgs.mutter ];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
    };
  };
}
```
Après un `sudo nixos-rebuild switch`, et un redémarrage de l'ordinateur (`reboot`), il est possible de définir une échelle d'affichage plus précise dans l'application "Paramètres", et dans la section "Écrans".

![Paramètre Gnome de la configuration d'une échelle d'écran fractionnelle](./assets/gnome_fractional_scaling.png "Paramètre Gnome de la configuration d'une échelle d'écran fractionnelle")

### Mises à jours automatiques
Pour mettre à jour les paquets automatiquement, il suffit d'ajouter :

`configuration.nix`
```nix
{
  # [...]

  system.autoUpgrade = {
    enable = true;
    dates = "weekly"; #Voir https://mynixos.com/nixpkgs/option/system.autoUpgrade.dates pour les formats
  };

  # [...]
}
```
Cela mettra à jour les paquets toutes les semaines.

### Suppression des anciennes images Nix pour libérer de l'espace
Lorsqu'on fait `nixos-rebuild switch`, Nix va créer une nouvelle [image du système](https://fr.wikipedia.org/wiki/Image_syst%C3%A8me) et sauvegarder les anciennes.
Cela permet de récupérer une ancienne configuration en cas de problème mais ça prend évidemment de l'espace de stockage.

Pour supprimer les ancinnes images:
`configuration.nix`
```nix
{
  # [...]

  # Voir https://mynixos.com/options/nix.gc pour plus de personnalisation
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d"; 
  };
  nix.settings.auto-optimise-store = true;

  # [...]
}
```
Ceci va supprimer tous les jours les images sysèmes ayant plus de 10 jours d'ancienneté.

### Affichage des mises à jours
Par défaut, lorqu'une mise à jour d'un paquet est effecutée, les paquets mis à jours ne sont pas précisés.
Pour remédier à cela, voici la solution:

`configuration.nix`
```nix
{
  pkgs, lib, ...
}:
{
  # [...]

  environment.systemPackages = with pkgs; [
    # [...]

    nvd
  ];

  system.activationScripts.report-changes = ''
    PATH=$PATH:${lib.makeBinPath [pkgs.nvd pkgs.nix]}
    nvd diff $(ls -d1v /nix/var/nix/profiles/system-*-link|tail -n 2)
  '';

  # [...]
}
```

Ceci va configurer un script qui va préciser avec de la couleur les paquets qui ont changés et précisant leur version (et l'ancienne version pour les paquets mis à jours).

### Autoriser les paquets non libres (unfree) avec ou sans home manager
La solution est d'ajouter la ligne `nixpkgs.config.allowUnfree = true;`.
Seulement si ça a été fait dans `configuration.nix`, ça ne s'appliquera pas pour les utilisateur du home manager. Il faudra re préciser cette ligne dans les fichiers Nix de chaque utilisateur (dans `home.nix` par exemple).

### Configurer zsh avec un home manager (bientôt)

### Configurer des plugins obs avec home manager (bientôt)

### Activation et configuration de docker avec containers en déclaratif (solution inconnue)


