{ config, lib, pkgs, user, ... }:


{
  home.username = user;
  home.homeDirectory = "/home/" + user;
  home.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  ###############
  # PACKAGES
  ###############
  home.packages = with pkgs; [
    # Shell and terminal
    zsh
    oh-my-zsh
    tmux
    kitty
    wezterm

    # Applications
    microsoft-edge

    # Editor
    neovim

    # Utilities
    stow
    fzf
    ripgrep
    fd
    bat
    zoxide

    # Development tools
    git
    curl
    wget

    # Languages and runtimes
    nodejs
    python310
    ruby
    go
    rustc
    cargo
    luarocks
    jdk
    julia
    powershell

    # Build tools
    gcc
    gnumake
    cmake

    # i3 dependencies / tools
    dunst
    networkmanagerapplet
    flameshot
    feh
    xss-lock
    i3lock
    dex
    bumblebee-status
    dmenu

    # NixGL
    nixgl.nixGLIntel
  ];

  ###############
  # Create global nixgl wrapper
  ###############
  home.file.".local/bin/nixgl".text = ''
    #!/usr/bin/env bash
    exec ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel "$@"
  '';
  home.file.".local/bin/nixgl".executable = true;

  ###############
  # ZSH
  ###############
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };
    shellAliases = {
      wezterm = "flatpak run org.wezfurlong.wezterm";
      obsidian = "flatpak run md.obsidian.Obsidian";
      icat = "kit +kitten icat";
      kit = "nixgl kitty";
      hm = "home-manager switch --flake ~/.dotfiles?submodules=1#andres";
      nixgl = "~/.local/bin/nixgl";
    };
    initExtra = ''
      # Keybindings
      bindkey -s ^p "tmux-sessionizer\n"

      # SDKMAN
      export SDKMAN_DIR="$HOME/.sdkman"
      [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

      # NVM
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

      # Custom functions
      clean_scala_deps() {
        echo "Removing Scala and SBT caches..."
        rm -rf ~/.m2 ~/.ivy2 ~/.cache/coursier ~/.sbt/1.0/plugins/target
        echo "Cleanup complete!"
      }
    '';
    profileExtra = ''
      export PATH=~/.local/share/coursier/bin:$PATH
      export PATH=~/.local/share/JetBrains/Toolbox/scripts:$PATH
      export PATH=/opt/pulsesecure/bin:$PATH
      export PATH=$PATH:/usr/local/go/bin

      export TERMINAL=kitty
    '';
  };

  ###############
  # DOTFILES / CONFIG
  ###############
  home.file = {
    ".config/nvim".source = ./nvim/.config/nvim;
    ".config/tmux".source = ./tmux/.config/tmux;
    ".config/kitty".source = ./kitty/.config/kitty;
    ".config/wezterm".source = ./wezterm/.config/wezterm;
    ".config/i3".source = ./i3/.config/i3;
    ".ideavimrc".source = ./ideavimrc/.ideavimrc;
    ".config/dunst".source = ./dunst/.config/dunst;

    # Scripts
    "bin/tmux-sessionizer".source = ./bin/.local/scripts/tmux-sessionizer;
    "bin/activity.sh".source = ./bin/activity.sh;

    # X11 start (if using startx)
    ".xinitrc".text = ''
      exec i3
    '';

    # Desktop entry for i3 session
    ".local/share/xsessions/i3-nix.desktop".text = ''
      [Desktop Entry]
      Name=i3 (Nix)
      Comment=Lightweight tiling window manager from Nix
      Exec=/home/${user}/.xsession
      TryExec=/home/${user}/.xsession
      Type=Application
    '';
  };

  ###############
  # XSESSION / I3
  ###############
  xsession = {
    enable = true;

    windowManager.i3 = {
      enable = true;
      package = pkgs.i3;
    };
  };

  ###############
  # USER SERVICES
  ###############
  services.network-manager-applet.enable = true;

}
