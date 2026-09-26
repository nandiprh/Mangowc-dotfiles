{ config, pkgs, inputs, ... }:

let
  nixGLWrap = pkg: pkgs.runCommand "${pkg.name}-nixgl" {} ''
    mkdir -p $out/bin $out/share/applications
    for bin in ${pkg}/bin/*; do
      binname=$(basename $bin)
      cat > $out/bin/$binname << EOF
#!/bin/sh
exec ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel $bin "\$@"
EOF
      chmod +x $out/bin/$binname
    done
    if [ -d ${pkg}/share/applications ]; then
      for d in ${pkg}/share/applications/*.desktop; do
        sed "s|Exec=${pkg}/bin/|Exec=$out/bin/|g" $d \
          > $out/share/applications/$(basename $d)
      done
    fi
  '';
in

{
  imports = [ /home/honken/.config/home-manager/modules/gtk.nix
              /home/honken/.config/home-manager/modules/qt.nix
            ];

  home.username = "honken";
  home.homeDirectory = "/home/honken";
  home.stateVersion = "26.05";

  nixpkgs.config.allowUnfree = true;

  # Graphical and CLI User Tools
  home.packages = with pkgs; [
    ripgrep
    fd
    btop
    htop
    weechat
    aria2
    dconf
    yt-dlp
    gallery-dl
    blanket
    libreoffice
    proton-pass
    ytm-player
    monophony
    super-productivity
    opencode
    zsh-powerlevel10k
    kdePackages.dolphin
    pcmanfm
    (nixGLWrap gthumb)
    materialgram
    brave-origin
    (nixGLWrap kdePackages.kdeconnect-kde)
    yaziPlugins.kdeconnect-send
    ciscoPacketTracer9
  ];

  # Git Configuration
  programs.git = {
    enable = true;
    settings.user = {
      name = "Pratyush";
      email = "nandiprh@gmail.com";
    };
  };

  # Shell Configuration
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" ];
    };
  };

  programs.zsh.dotDir = "${config.xdg.configHome}";  
  programs.zsh.initContent = ''
  # Powerlevel10k Zsh theme  
  source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme  
  test -f ~/.config/zsh/.p10k.zsh && source ~/.config/zsh/.p10k.zsh 
'';

  # Enable fzf and automatically hook it into Zsh
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # Enable tmux and plugins
  programs.tmux = {
      enable = true;
      mouse = true;
      historyLimit = 5000;
      disableConfirmationPrompt = true;
      clock24 = true;
      extraConfig = ''
        # Split panels cleanly using logical layout indicators that preserve current path state
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        unbind '"'
        unbind %

        # Force tmux-fzf popup window layout size bindings
        set -g @tmux-fzf-popup-width '80%'
        set -g @tmux-fzf-popup-height '60%'
        '';

        plugins = with pkgs.tmuxPlugins; [
        sensible              # Standard operational parameters and optimization controls
        resurrect             # Restores running panel configurations across host system reboots
        tmux-fzf              # Pulls up fzf workspace control dialogs (Prefix + F)
        ];
      }; 

  # mpv (MPlayer and Video)
  programs.mpv = {
    enable = true;
    package = nixGLWrap pkgs.mpv; # wrap mpv with mesa
    config = {
      cache = "yes";
      demuxer-max-bytes = 150000000; # 150MB buffer limit (Safe for streaming)
      force-window = true;
      profile = "gpu-hq";
      ytdl-format = "bestvideo+bestaudio";
    };
  };

  services.jellyfin-mpv-shim.enable = true;

  # Generic Linux System Integration Settings
  targets.genericLinux.enable = true;
  targets.genericLinux.gpu.enable = true;
  targets.genericLinux.nixGL.installScripts = "mesa";
  targets.genericLinux.nixGL.defaultWrapper = "mesa";
  targets.genericLinux.nixGL.vulkan.enable = true;

  # Home Manager setup rules (Flake mode compatible)
  programs.home-manager = {
    enable = true;
  };

  services.home-manager.autoUpgrade.useFlake = true;
  systemd.user.sessionVariables = config.home.sessionVariables;

  # Environmental adjustments for Wayland
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # Forces electron apps to use native Wayland
  };

  qt.enable = true;
  gtk.enable = true;

  # Setting up XDG freedesktop conventions
  xdg = {
    enable = true;
    mime.enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    
    # Correct way to append extra paths into XDG_DATA_DIRS safely
    systemDirs.data = [
      "/home/honken/.local/share/flatpak/exports/share"
      "/var/lib/flatpak/exports/share"
      "/usr/local/share"
      "/usr/share"
      "${config.home.homeDirectory}/.nix-profile/share"
    ];
  };


  # Setting up systemd functionality for user background automation
  systemd.user = {
    enable = true;

    services.my-background-script = {
      Unit = {
        Description = "Run my custom sync script on startup";
        After = [ "network.target" ];
      };
      Service = {
        ExecStart = "${pkgs.writeShellScript "sync-script" ''
          echo "Doing background work..."
        ''}";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "default.target" ];
    };
  };


  # for bluetooth
  services.mpris-proxy.enable = true;
}

