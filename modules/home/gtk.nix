{ pkgs, ... }:

{
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Set system color-scheme preference to dark.
  # This is the dconf key that xdg-desktop-portal-gtk reads and exposes over
  # D-Bus as org.freedesktop.appearance.color-scheme, which is what browsers
  # (Firefox, Chrome/Brave) and libadwaita apps query for prefers-color-scheme.
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}