.PHONY: stow

FOLDER_STOW := nvim/ tmux/ wezterm/ zsh/ bin/

stow:
	stow -D $(FOLDER_STOW)
	stow $(FOLDER_STOW)
