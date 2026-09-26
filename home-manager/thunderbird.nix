{ config, pkgs, ... }:

{
  # Thunderbird Declarative Mail Ecosystem
  programs.thunderbird = {
    enable = true;
    
    # 1. Global enterprise policies to handle extensions and security
    policies = {
      DisableTelemetry = true;
      DisablePocket = true;
      
      # Automatically downloads, installs, and locks your requested extensions
      ExtensionSettings = {
        # uBlock Origin installation mapping via Firefox Addon ID
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://mozilla.org";
        };
      };
    };

    # 2. Configure your primary user profile environment details
    profiles.honken = {
      isDefault = true;
      
      # Force internal configuration choices (user.js preferences)
      settings = {
        # Enforce dark theme variant integration across the modern UI layer
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "devtools.theme" = "dark";
        "browser.theme.content-theme" = 2; # 2 forces dark styling everywhere
        
        # Performance and Privacy tuning
        "privacy.donottrackheader.enabled" = true;
        "mail.spellcheck.inline" = true;
      };
    };
  };

  # Declarative Email Account Configuration
  accounts.email.accounts."Personal" = {
    primary = true;
    realName = "Pratyush";
    address = "nandipratyush1917@gmail.com";
    userName = "nandipratyush1917@gmail.com";
    
    thunderbird = {
      enable = true;
      profiles = [ "honken" ];
    };

    imap = {
      host = "://gmail.com";
      port = 993;
      tls.enable = true;
    };
    smtp = {
      host = "://gmail.com";
      port = 587;
      tls = {
        enable = true;
        useStartTls = true;
      };
    };
  };
}

