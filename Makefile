.PHONY: stow

FOLDER_STOW := nvim/ tmux/ wezterm/

stow:
	stow -D $(FOLDER_STOW)
	stow $(FOLDER_STOW)
