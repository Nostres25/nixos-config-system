# Bienvenue dans ma configuration de mon système personel NixOs

## Organisation
Tout d'abord je tiens à préciser que par souci de praticité, j'utilise Vscodium (Vscode) pour modifier ma configuration NixOs. Pour cela j'ai d'ailleurs déplacé mes fichiers de configuration Nix dans le répertoire personnel de mon compte utilisateur (`~/.config/nixos`).

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


Trouvant la configuration NixOs archaïque, non pas que m'aider d'une [documentation]() me dérange mais que ça manque peut-être un peu d'autocomplétion et de correction syntaxique, j'ai cherché à simplifier la configuration en Nix avec des outils supplémentaires... (to be continued)

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
> TLP est un outil de gestion de l'alimentation et de la batterie