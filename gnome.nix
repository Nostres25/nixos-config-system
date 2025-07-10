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
      
      # To enable fractionnal scaling
      extraGSettingsOverridePackages = [ pkgs.mutter ];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
    };
  };
  
  environment.systemPackages = with pkgs; [
    #gnomeExtensions.arc-menu
    #gnomeExtensions.battery-health-charging # not compatible with all devices: https://extensions.gnome.org/extension/5724/battery-health-charging/
  ];

}
