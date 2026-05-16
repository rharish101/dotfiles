<!--
SPDX-FileCopyrightText: 2018 Harish Rajagopal <harish.rajagopals@gmail.com>

SPDX-License-Identifier: MIT
-->

# dotfiles

This is a repository containing all of my configurations of my current rice.
I use [GNU Stow](https://www.gnu.org/software/stow/) to manage my dotfiles (for a tutorial, [click here](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/)).

## Available Configs

- [Bash](https://www.gnu.org/software/bash/) - backup shell
- [Fish](https://fishshell.com) - main shell
- [Flameshot](https://github.com/flameshot-org/flameshot) - powerful screenshot tool
- [Hyprland](https://hypr.land/) - Wayland compositor
  - [hypridle](https://github.com/hyprwm/hypridle) - idle daemon
  - [hyprlock](https://github.com/hyprwm/hyprlock) - lockscreen
- [IPython](https://github.com/ipython/ipython) - interactive Python shell
- [Kitty](https://sw.kovidgoyal.net/kitty/) - terminal emulator
- [Kvantum](https://github.com/tsujan/Kvantum) - QT theme engine
- [NeoVim](https://neovim.io/) - text editor
- [OpenCode](https://opencode.ai/) - LLM harness
- [Ruff](https://docs.astral.sh/ruff/) - Python linter, formatter and LSP
- [Tmux](https://github.com/tmux/tmux) - terminal multiplexer
- [Wofi](https://hg.sr.ht/~scoopta/wofi) - GTK-based app launcher
- [ashell](https://malpenzibo.github.io/ashell/) - status bar
- [latexmk](https://miktex.org/packages/latexmk) - LaTeX build tool
- [wpaperd](https://github.com/danyspin97/wpaperd) - Wayland wallpaper daemon

## Requirements

- [GNU Stow](https://www.gnu.org/software/stow/) - tool used for managing dotfiles
- Hyprland plugins:
  - [hy3](https://github.com/outfoxxed/hy3) - Hyprland plugin for i3-like layout
  - [hyprexpo](https://github.com/colonelpanic8/hyprexpo) - Hyprland plugin for a workspace overview like Gnome or KDE
  - [hypr-dynamic-cursors](https://github.com/VirtCode/hypr-dynamic-cursors) - Hyprland plugin for cursor shake-to-find
- Fish plugins:
  - [fisher](https://github.com/jorgebucaran/fisher) - plugin manager
  - [tide](https://github.com/IlanCosman/tide) - plugin for the prompt
- Fish config:
  - [Fortune](https://github.com/shlomif/fortune-mod) - tool for random adages
  - [Cowsay](https://github.com/tnalpgge/rank-amateur-cowsay) - tool for making Tux say the random adages
  - [Dotacat](https://gitlab.scd31.com/stephen/dotacat) - tool for colouring Tux saying the random adages
- Themes and fonts:
  - [vimix-dark-beryl](https://github.com/vinceliuice/vimix-gtk-themes) - GTK theme
  - [VimixBerylDark](https://github.com/vinceliuice/vimix-kde) - Kvantum theme (for Qt applications)
  - [Papirus-Dark](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) - icon theme
  - [papirus-folders](https://github.com/PapirusDevelopmentTeam/papirus-folders) - tool for setting folder icon colours
  - Breeze Light (from KDE Plasma) - cursor theme
  - [Roboto](https://fonts.google.com/specimen/Roboto) - font
  - [JetBrainsMono](https://www.jetbrains.com/lp/mono/) [Nerd Font](https://github.com/ryanoasis/nerd-fonts) - monospace font

## Instructions

Simply use Stow on all the folders in this repository (except for the screenshots and the `nvim` folder).
For example, for using my Fish config, do:

```sh
stow -t ~ fish
```

For my NeoVim setup, use Stow on the `config` folder inside the `nvim` folder as follows:

```sh
cd nvim
stow -t ~ config
```

Further instructions can be found in the README of that repo: <https://github.com/rharish101/vim-config>.

### Papirus Folders

Run the following command to set the folder colors of the Papirus-Dark theme to match the Vimix GTK theme's colorscheme:

```sh
papirus-folders -C teal --theme Papirus-Dark
```

### Fish plugins

To install and configure the fish plugins:

1. Install [fisher](https://github.com/jorgebucaran/fisher).
2. Install all plugins:
   ```sh
   fisher update
   ```
3. Follow the configure wizard of tide to set up your prompt the way you want it. If you missed it, or accidentally cancelled it, then run:
   ```sh
   tide configure
   ```

## Screenshots

### Current Desktop

![desktop](./screenshots/desktop.png)

### Lockscreen

![lockscreen](./screenshots/lockscreen.png)

### Terminal

#### Colourscheme

![colourscheme](./screenshots/colourscheme.png)

#### Fortune + Cowsay + Dotacat

![cowsay](./screenshots/cowsay.png)

#### Fish

![fish-1](./screenshots/fish-1.png)
![fish-2](./screenshots/fish-2.png)

#### Bash

![bash](./screenshots/bash.png)

### NeoVim

![nvim-1](./screenshots/nvim-1.png)
![nvim-2](./screenshots/nvim-2.png)
![nvim-3](./screenshots/nvim-3.png)

### IPython

![ipython](./screenshots/ipython.png)

### Tmux

![tmux](./screenshots/tmux.png)

## Licenses

This repository uses [REUSE](https://reuse.software/) to document licenses.
Each file either has a header containing copyright and license information, or has an entry in the [TOML file](https://reuse.software/spec-3.3/#reusetoml) at [REUSE.toml](./REUSE.toml).
The license files that are used in this project can be found in the [LICENSES](./LICENSES) directory.

The MIT license is placed in [LICENSE](./LICENSE), to signify that it constitutes the majority of the codebase, and for compatibility with GitHub.
All screenshots are under the [CC-BY-SA-4.0 license](https://creativecommons.org/licenses/by-sa/4.0/legalcode).
