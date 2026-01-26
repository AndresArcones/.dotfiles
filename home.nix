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
    teams-for-linux
    spotify
    slack
    obsidian
    vscode
    dbeaver-bin
    postman

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
    terraform
    docker
    opencode

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
    bazelisk
    sbt

    # i3 dependencies / tools
    dunst
    networkmanagerapplet
    flameshot
    feh
    xss-lock
    dex
    bumblebee-status
    dmenu
    jetbrains-toolbox
    python311Packages.psutil
    xclip

    # NixGL
    nixgl.nixGLIntel # needed for kitty to run in nix
  ];

  ###############
  # Create global wrappers
  ###############
  home.file.".local/bin/nixgl".text = ''
    #!/usr/bin/env bash
    exec ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel "$@"
  '';
  home.file.".local/bin/nixgl".executable = true;
  home.file.".local/bin/kit".text = ''
    #!/usr/bin/env bash
    exec ~/.local/bin/nixgl kitty "$@"
  '';
  home.file.".local/bin/kit".executable = true;

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
      teams = "teams-for-linux";
      icat = "kit +kitten icat";
      kit = "nixgl kitty";
      # Update the nix/home-manager to latest. Will only execute what changed since the last time it was run.
      hm = "home-manager switch --flake '.?submodules=1#${user}'";
      # Backup the conflicting files that are already present on the system and use the ones defined in nix/home-manager
      hmb = "home-manager switch -b backup --flake '.?submodules=1#${user}'";
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
      export GIT_EDITOR="nvim"
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
  };

  ###############
  # USER SERVICES
  ###############
  services.network-manager-applet.enable = true;


