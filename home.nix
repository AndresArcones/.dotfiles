{ config, pkgs, ... }:

{
  home.username = "arconescrespoa";
  home.homeDirectory = "/home/arconescrespoa";
  home.stateVersion = "23.11";

  programs.home-manager.enable = true;

  # Install packages
  home.packages = with pkgs; [
    # Shell and terminal
    zsh
    oh-my-zsh
    tmux
    kitty
    wezterm

    # Editor
    neovim

    # Window manager
    i3
    dunst  # notification daemon

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

    # Utilities
    stow  # for compatibility
    fzf
    ripgrep
    fd
    bat
    exa
    zoxide
   ];

   # Enable oh-my-zsh
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
       icat = "kitty +kitten icat";
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

       # Brew shellenv
       eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
     '';
      profileExtra = ''
        # Additional PATH exports
        export PATH=~/.local/share/coursier/bin:$PATH
        export PATH=~/.local/share/JetBrains/Toolbox/scripts:$PATH
        export PATH=/opt/pulsesecure/bin:$PATH
        export PATH=$PATH:/usr/local/go/bin

        # Terminal
        export TERMINAL=kitty
       '';
   };

   # Symlink dotfiles
   home.file = {
     ".config/nvim".source = ./nvim/.config/nvim;
     ".config/tmux".source = ./tmux/.config/tmux;
     ".config/kitty".source = ./kitty/.config/kitty;
     ".config/wezterm".source = ./wezterm/.config/wezterm;
     ".config/i3".source = ./i3/.config/i3;
     ".ideavimrc".source = ./ideavimrc/.ideavimrc;
     ".config/dunst".source = ./dunst/.config/dunst;
   };

  # Symlink scripts
  home.file."bin/tmux-sessionizer".source = ./bin/.local/scripts/tmux-sessionizer;
  home.file."bin/activity.sh".source = ./bin/activity.sh;

  # Enable services if needed
  # For dunst, might need systemd user service, but home-manager handles it

}
