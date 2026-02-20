{ config, lib, pkgs, user, ... }:


{
  home.username = user;
  home.homeDirectory = "/Users/" + user;
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
  ];

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
      icat = "kitty +kitten icat";
      # Update the nix/home-manager to latest. Will only execute what changed since the last time it was run.
      hm = "home-manager switch --flake '.?submodules=1#${user}'";
      # Backup the conflicting files that are already present on the system and use the ones defined in nix/home-manager
      hmb = "home-manager switch -b backup --flake '.?submodules=1#${user}'";
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
      export PATH=$PATH:/usr/local/go/bin

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
    ".config/aerospace".source = ./aerospace/.config/aerospace;
    ".ideavimrc".source = ./ideavimrc/.ideavimrc;

    # Scripts
    "bin/tmux-sessionizer".source = ./bin/.local/scripts/tmux-sessionizer;
    "bin/activity.sh".source = ./bin/activity.sh;
  };

}
