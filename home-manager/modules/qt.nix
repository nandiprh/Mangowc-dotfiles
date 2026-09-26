# ~/.config/home-manager/modules/qt.nix
{ config, pkgs, lib, ... }:

{
  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
  };

  # Theme engines required for both Qt5 and Qt6 applications
  home.packages = with pkgs; [
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
    kdePackages.qt6ct
    libsForQt5.qt5ct
  ];

  xdg.configFile = {
    # 1. Set the active Kvantum theme registry to OrchisDark
    "Kvantum/kvantum.kvconfig".text = ''
      [General]
      theme=OrchisDark
    '';

    # 2. Map your local Orchis assets directly into Kvantum's expected layout namespaces
    "Kvantum/OrchisDark/OrchisDark.kvconfig".source = "${config.home.homeDirectory}/.local/share/themes/Orchis/OrchisDark.kvconfig";
    "Kvantum/OrchisDark/OrchisDark.svg".source = "${config.home.homeDirectory}/.local/share/themes/Orchis/OrchisDark.svg";

    # 3. Configure qt6ct interface to utilize the Kvantum layer
    "qt6ct/qt6ct.conf".text = ''
      [Appearance]
      style=kvantum
      custom_palette=false
      icon_theme=Honken_Hybrid

      [Fonts]
      fixed="JetBrains Mono,11,-1,5,50,0,0,0,0,0"
      general="JetBrains Mono,11,-1,5,50,0,0,0,0,0"
    '';

    # 4. Standardize settings mirror for legacy Qt5 apps
    "qt5ct/qt5ct.conf".text = ''
      [Appearance]
      style=kvantum
      icon_theme=Honken_Hybrid
    '';
  };

  # Environmental exports required for your Gentoo compositor/desktop to route styling
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
  };

  systemd.user.sessionVariables = {
    QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";
  };
}

