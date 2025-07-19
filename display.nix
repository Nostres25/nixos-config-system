{ pkgs, ... }:
{
  services.xserver = {
    enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "fr";
      variant = "azerty";
    };
    
    # Enable wayland
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    # Enable gnome
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
    
  # Voir les extensions disponibles sur https://extensions.gnome.org/
  /*environment.systemPackages = with pkgs; [
    #gnomeExtensions.arc-menu
    #gnomeExtensions.battery-health-charging # not compatible with all devices: https://extensions.gnome.org/extension/5724/battery-health-charging/
  ];*/

}
