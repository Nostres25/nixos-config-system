{ ... }:
{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      clock-show-seconds = true;
      clock-show-weekday = true;
    };
    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = ["disabled"]; # use lists for keybinds
    };
  };
}