{ config, pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "Tokyonight-Dark-BL";
      package = pkgs.tokyo-night-gtk;
    };

    iconTheme = {
      name = "Honken-Hybrid";
    };

    cursorTheme = {
      name = "Google-dot-blue";
      size = 24;
    };

    font = {
      name = "Noto Sans";
      size = 11;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-cursor-theme-size = 24;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
}
