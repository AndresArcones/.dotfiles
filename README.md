How to use

1. Run the bootstrap script:
   ```bash
   wget -qO - https://raw.githubusercontent.com/AndresArcones/.dotfiles/refs/heads/main/bootstrap.sh | bash`
   ```
3. Enjoy - all packages installed and dotfiles symlinked

>If error when executing `1.` or you want a clean nix installation:

```bash
sudo rm -rf /nix ~/.nix-profile ~/.nix-defexpr ~/.nix-channels ~/.local/state/nix ~/.dotfiles && wget -qO - https://raw.githubusercontent.com/AndresArcones/.dotfiles/refs/heads/main/bootstrap.sh | bash
```
