# Bienvenue dans ma configuration de mon système personel NixOs
## Contexte
Pour ceux qui ne connaissent pas, NixOs est une distribution linux pas comme les autres.
En effet, contrairement à la plupart des distributions linux, il ne respecte pas [la norme de la hiérarchie des systèmes de fichiers (FHS)](https://fr.wikipedia.org/wiki/Filesystem_Hierarchy_Standard).
En effet, il est basé sur le systèmes de packets Nix, qui promet la reproductibilité, la robustesse, la portabilité et la stabilité. 
On a l'habitude de le présenter comme un système qu'on peut coder. C'est-à-dire que sa configuration est déclarative.
Pour en savoir plus, je vous invite à vous renseigner sur [NixOs](https://fr.wikipedia.org/wiki/NixOS) à travers wikipedia, des vidéos ou autre.

J'ai découvert NixOs grâce à un bon ami. J'ai donc voulu l'essayer, et j'ai fini par l'adopter !
Ma crainte était qu'il faille passer par des étapes compliquées et/ou très chronophages pour installer le moindre packet ou pour changer de petites options.
Et en effet NixOs demande certes un temps de compréhension et requiert beaucoup de temps pour le personnaliser exactement comme on le souhaite, en passant par des paramètres avancées, surtout si on souhaite qu'il soit un maximum reproductible. C'est à dire qu'on tient à tout configurer en déclaratif.

Mais en réalité ce n'est pas nécéssaire. Si on installes NixOs avec un environnement de bureau comme Gnome ou KDE, le système sera en apparence comme un autre système linux utilisant gnome ou KDE. Firefox y est préinstallé et beaucoup de paramètres sont modifiables via l'application "Paramètres". La différence se situe surtout dans la gestion des packets et dans les options du système qu'on souhaite reproductibles.

Par exemple, pour ajouter un packet il faut l'ajouter dans le fichier de configuration `/etc/nixos/configuration.nix`. Mais c'est très simple, cela ne demande que de chercher l'existence du packet et son nom exact (sur [NixOs Search](https://search.nixos.org/packages) par exemple) et d'ajouter une ligne dans un fichier pré-remplit. 
Si on souhaite modifier une option de manière déaclarative, on va devoir chercher cette option sur **NixOs Search** ou plus largement sur internet concernant des packets spécifiques. Sachant qu'il y a beaucoup de guides sur le [Wiki NixOs](https://wiki.nixos.org/wiki/NixOS_Wiki/fr) et le [manuel NixOs](https://nixos.org/manual/nixos/stable/). (à venir : trouver une solution pour connaître les options des applications quoi qu'il arriver).
Et si installer des applications via Nix pose problème pour x ou y raison. Il est possible [d'utiliser les flatpacks](https://nixos.wiki/wiki/Flatpak).

La difficulté se présente surtout lorsque certaines solutions que vous allez trouver sur internet ne concernent que les configurations utilisant un [home manager](https://nixos.wiki/wiki/Home_Manager) ou les [flakes](https://wiki.nixos.org/wiki/Flakes) alors que ce n'est pas votre cas ou inversement.
Même s'il est recommander d'utiliser un home-manager et les flakes pour un meilleur système, avec plus de possibilités.
-# Même si lorsque j'écris ce document les flakes sont experimentaux, ils sont fiables et beaucoup les utilisent. Ils permettent d'ailleurs une meilleur stabilitédu système.


## Organisation
### État du système
Tout d'abord et pour faire court, mon système utilise gnome comme environnement de bureau et un [home manager](https://nixos.wiki/wiki/Home_Manager). Je compte utiliser les flakes à l'avenir pour débloquer de nouvelles fonctionnalités, pour garantir une meilleure staibilité de mon système et pour maîtriser davantage Nix.

### Développement
je tiens à préciser que par souci de praticité, j'utilise `vscodium` (Vscode) pour modifier ma configuration NixOs. Pour cela j'ai d'ailleurs déplacé mes fichiers de configuration Nix dans le répertoire personnel de mon compte utilisateur (`~/.config/nixos`).

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
-# Vous l'aurez remarqué, l'importation se fait depuis un répertoire. Dans cette situation, cela prend en réalité le fichier `default.nix` présent dans ce répertoire. 


Trouvant la configuration NixOs archaïque, non pas que m'aider d'internet me dérange mais que ça manque peut-être un peu d'autocomplétion et de correction syntaxique, j'ai cherché à simplifier la configuration en Nix avec des outils supplémentaires.
J'ai donc :
1. installé l'extension Vscode Nix IDE
2. ajouté le formateur nix [`nixfmt-rfc-style`](https://github.com/NixOS/nixfmt) dans les packets à installer
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

Et ça me fait de l'auto complétion et du formattage de code automatique pour Nix ! (ps: c'est pas fini)

## Problématiques rencontrées
Pour les problèmes et astuces autour des ordinateurs portables, il y a [une page dédiée aux ordinateurs portables](https://nixos.wiki/wiki/Laptop) sur le wiki de NixOs.

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
Seulement mon ordinateur portable (Unowhy Y13) n'est pas compatible en vu de ses pilotes de gestion de la batterie.

