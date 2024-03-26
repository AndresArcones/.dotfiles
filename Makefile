.PHONY: stow

FOLDER_STOW := nvim/ tmux/ wezterm/ zsh/ bin/ kitty/ i3/ ideavimrc/

stow:
	stow -R $(FOLDER_STOW)
