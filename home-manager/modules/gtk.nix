{ config, pkgs, ... }:

{
  gtk = {
    enable = true;

    theme = {
      name = "Fluent-Dark";
      package = pkgs.fluent-gtk-theme;
    };

    iconTheme = {
      name = "Honken_Hybrid";
    };

    cursorTheme = {
      name = "GoogleDot-Blue";
      size = 24;
      package = pkgs.google-cursor;
    };

    font = {
      name = "JetBrains Mono";
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

  /* xdg.configFile = {
    "gtk-4.0/gtk.css".source = 
        "
      #"${config.home.homeDirectory}/.local/share/themes/Everforest-B-LB-Dark/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source =
        "pkgs.fluent-gtk-theme"
      #"${config.home.homeDirectory}/.local/share/themes/Everforest-B-LB-Dark/gtk-4.0/gtk-dark.css";
  }; */

   xdg.configFile = {
    "gtk-4.0/assets".source = "${pkgs.fluent-gtk-theme}/share/themes/Fluent-Dark/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${pkgs.fluent-gtk-theme}/share/themes/Fluent-Dark/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${pkgs.fluent-gtk-theme}/share/themes/Fluent-Dark/gtk-4.0/gtk-dark.css";
  };


  home.sessionVariables = {
    GTK_THEME = "Fluent";
    XCURSOR_THEME = "GoogleDot-Blue";
    XCURSOR_SIZE = "24";
  };

  gtk.gtk3.extraCss = ''
    * {
        padding: 2px;
    }

    .view {
        padding: 2px;
    }

    row {
        padding: 1px 4px;
    }

    label {
        padding: 1px 2px;
    }
'';
}
