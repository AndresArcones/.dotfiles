# How to use

## macOS (AeroSpace)

1. Install Xcode Command Line Tools:
   ```bash
   xcode-select --install
   ```
2. Install [Nix](https://nixos.org/download/):
   ```bash
   sh <(curl -L https://nixos.org/nix/install)
   ```
3. Install [AeroSpace](https://github.com/nikitabobko/AeroSpace) (tiling window manager):
   ```bash
   brew install --cask nikitabobko/tap/aerospace
   ```
4. Run the bootstrap script:
   ```bash
   wget -qO - https://raw.githubusercontent.com/AndresArcones/.dotfiles/refs/heads/macos-aerospace/bootstrap.sh | bash
   ```
5. Enjoy - all packages installed and dotfiles symlinked

> AeroSpace config is located at `~/.config/aerospace/aerospace.toml`. The default modifier key is `Alt`.

## Linux (i3)

1. Run the bootstrap script:
   ```bash
   wget -qO - https://raw.githubusercontent.com/AndresArcones/.dotfiles/refs/heads/main/bootstrap.sh | bash`
   ```
2. Enjoy - all packages installed and dotfiles symlinked

>If error when executing `1.` or you want a clean nix installation:

```bash
sudo rm -rf /nix ~/.nix-profile ~/.nix-defexpr ~/.nix-channels ~/.local/state/nix ~/.dotfiles && wget -qO - https://raw.githubusercontent.com/AndresArcones/.dotfiles/refs/heads/main/bootstrap.sh | bash
```

# Setting up the aerospace submodule repo

The `aerospace/.config/aerospace` submodule points to `https://github.com/AndresArcones/aerospace`.
Create that repo and push the config with these commands:

```bash
# 1. Create the repo on GitHub (requires gh CLI)
gh repo create AndresArcones/aerospace --public --description "AeroSpace window manager config"

# 2. Clone and add the config
git clone https://github.com/AndresArcones/aerospace.git /tmp/aerospace
cat > /tmp/aerospace/aerospace.toml << 'EOF'
# AeroSpace configuration
# See https://github.com/nikitabobko/AeroSpace for documentation

# Start AeroSpace at login
start-at-login = true

# Accordion padding
accordion-padding = 30

# Default root container layout
default-root-container-layout = 'tiles'

# Default root container orientation
default-root-container-orientation = 'auto'

# Automatically move mouse to focused window
on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

# Key mapping
[key-mapping]
preset = 'qwerty'

# Gaps
[gaps]
inner.horizontal = 8
inner.vertical = 8
outer.left = 8
outer.bottom = 8
outer.top = 8
outer.right = 8

# Workspace names
[workspace-to-monitor-force-assignment]

# Mode: main (default)
[mode.main.binding]
# Launch terminal
alt-enter = 'exec-and-forget open -a kitty'

# Focus window
alt-h = 'focus left'
alt-j = 'focus down'
alt-k = 'focus up'
alt-l = 'focus right'

# Move window
alt-shift-h = 'move left'
alt-shift-j = 'move down'
alt-shift-k = 'move up'
alt-shift-l = 'move right'

# Resize window
alt-shift-minus = 'resize smart -50'
alt-shift-equal = 'resize smart +50'

# Change layout
alt-slash = 'layout tiles horizontal vertical'
alt-comma = 'layout accordion horizontal vertical'

# Toggle fullscreen
alt-f = 'fullscreen'

# Switch workspace
alt-1 = 'workspace 1'
alt-2 = 'workspace 2'
alt-3 = 'workspace 3'
alt-4 = 'workspace 4'
alt-5 = 'workspace 5'
alt-6 = 'workspace 6'
alt-7 = 'workspace 7'
alt-8 = 'workspace 8'
alt-9 = 'workspace 9'

# Move window to workspace
alt-shift-1 = 'move-node-to-workspace 1'
alt-shift-2 = 'move-node-to-workspace 2'
alt-shift-3 = 'move-node-to-workspace 3'
alt-shift-4 = 'move-node-to-workspace 4'
alt-shift-5 = 'move-node-to-workspace 5'
alt-shift-6 = 'move-node-to-workspace 6'
alt-shift-7 = 'move-node-to-workspace 7'
alt-shift-8 = 'move-node-to-workspace 8'
alt-shift-9 = 'move-node-to-workspace 9'

# Reload config
alt-shift-c = 'reload-config'

# Enter service mode
alt-shift-semicolon = 'mode service'

# Mode: service
[mode.service.binding]
esc = ['reload-config', 'mode main']
r = ['flatten-workspace-tree', 'mode main']
f = ['layout floating tiling', 'mode main']
backspace = ['close-all-windows-but-current', 'mode main']
alt-shift-h = ['join-with left', 'mode main']
alt-shift-j = ['join-with down', 'mode main']
alt-shift-k = ['join-with up', 'mode main']
alt-shift-l = ['join-with right', 'mode main']
EOF

# 3. Push
cd /tmp/aerospace
git add aerospace.toml
git commit -m "Initial aerospace config"
git push -u origin main

# 4. Back in .dotfiles, update the submodule pointer
cd ~/.dotfiles
git submodule update --init aerospace/.config/aerospace
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
