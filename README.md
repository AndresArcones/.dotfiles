# How to use

1. Run the bootstrap script:
   ```bash
   wget -qO - https://raw.githubusercontent.com/AndresArcones/.dotfiles/refs/heads/main/bootstrap.sh | bash`
   ```
3. Enjoy - all packages installed and dotfiles symlinked

>If error when executing `1.` or you want a clean nix installation:

```bash
sudo rm -rf /nix ~/.nix-profile ~/.nix-defexpr ~/.nix-channels ~/.local/state/nix ~/.dotfiles && wget -qO - https://raw.githubusercontent.com/AndresArcones/.dotfiles/refs/heads/main/bootstrap.sh | bash
```

# How to work with the repo

## Update all submodules to their latest commits
```bash
git submodule update --remote --recursive && git commit -am "Update submodules"
```

## Update some of the submodules to their latest commits without touching the rest
1. Fetches each submodule latest status:
```bash
git submodule update --remote --recursive
```
2. Check wich modules you want to update:
```bash
git status
```
3. Add whatever module you like to update:
e.g to update tmux module:
```bash
git add tmux/.config/tmux
```
4. Commit the new module pointers:
```bash
git commit -m "Update tmux submodule to latest"
` 
