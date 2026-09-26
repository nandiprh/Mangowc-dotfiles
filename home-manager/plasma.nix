{ config, pkgs, ... }:

let
  plasmaManager = builtins.fetchTarball {
    url = "https://github.com/nix-community/plasma-manager/archive/a19a2a029fa180911bd89c554dca1616e10f4c1d.tar.gz";
    sha256 = "1m45385zs1bm1f6ligs2r00q4r9zaqr4rp0wggvvfwrh629mk64d";
  };
in
{
  imports = [
    (import "${plasmaManager}/modules")
  ];

  # KDE Plasma 6 desktop environment (installed from Nix; SDDM stays a Portage system service)
  home.packages = with pkgs.kdePackages; [
    plasma-desktop
    plasma-workspace
    plasma-integration
    kdeplasma-addons
    systemsettings
    kscreen
    plasma-nm
    bluedevil
    polkit-kde-agent-1
    xdg-desktop-portal-kde
    sddm-kcm
    konsole
    dolphin
    kate
    okular
    ark
    gwenview
  ];

  programs.plasma.enable = true;
}