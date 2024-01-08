<!--
SPDX-FileCopyrightText: 2018 Harish Rajagopal <harish.rajagopals@gmail.com>

SPDX-License-Identifier: MIT
-->

# dotfiles

This is a repository containing all of my configurations of my current rice.
I use [GNU Stow](https://www.gnu.org/software/stow/) to manage my dotfiles (for a tutorial, [click here](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/)).

## Requirements
* [GNU Stow](https://www.gnu.org/software/stow/) - tool used for managing dotfiles
* [Xfce](https://gitlab.xfce.org) - desktop environment
* [i3](https://github.com/i3/i3) - window manager
    * [picom](https://github.com/yshui/picom) - compositor
* [vimix-dark-beryl](https://github.com/vinceliuice/vimix-gtk-themes) - GTK theme
    * [VimixBerylDark](https://github.com/vinceliuice/vimix-kde) - Kvantum theme (for Qt applications)
* [Papirus-Dark](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) - icon theme
    * [papirus-folders](https://github.com/PapirusDevelopmentTeam/papirus-folders) - tool for setting folder icon colours
* Breeze Light (from KDE Plasma) - cursor theme
* [i3lock-color](https://github.com/Raymo111/i3lock-color) - lockscreen
    * [xss-lock](https://bitbucket.org/raymonad/xss-lock/src/master/) (optional) - tool for locking on screen blank
* [Roboto](https://fonts.google.com/specimen/Roboto) - font
* [Kitty](https://sw.kovidgoyal.net/kitty/) - terminal emulator
    * [Tmux](https://github.com/tmux/tmux) - terminal multiplexer
    * [Fortune](https://github.com/shlomif/fortune-mod) - tool for random adages
    * [Cowsay](https://github.com/tnalpgge/rank-amateur-cowsay) - tool for making Tux say the random adages
    * [Dotacat](https://gitlab.scd31.com/stephen/dotacat) - tool for colouring Tux saying the random adages
    * [JetBrainsMono](https://www.jetbrains.com/lp/mono/) [Nerd Font](https://github.com/ryanoasis/nerd-fonts) - monospace font
* [Fish](https://fishshell.com) - shell
    * [fisher](https://github.com/jorgebucaran/fisher) - plugin manager
    * [tide](https://github.com/IlanCosman/tide) - plugin for the prompt

### Optional
* [Vim](https://github.com/vim/vim/) 8+ (probably should be required :stuck_out_tongue:) - text editor
* [IPython](https://github.com/ipython/ipython) - interactive Python shell

## Instructions
Simply use Stow on all the folders in this repository (except for the screenshots and the `vim` folder).
For my Vim setup, use Stow on the `config` folder inside the `vim` folder as follows:
```sh
cd vim
stow -t ~ config
```

### Papirus Folders
Run the following command to set the folder colors of the Papirus-Dark theme to match the Vimix GTK theme's colorscheme:
```sh
papirus-folders -C teal --theme Papirus-Dark
```

### Lockscreen Script
How to use:
1. Run `~/.i3locker.zsh -h` to get the list of available commandline arguments.
2. Run the script with the necessary arguments.

You can also setup `xss-lock` so that this script is called whenever the screen blanks as follows:
```sh
xss-lock ~/.i3locker.zsh
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
All screenshots under the [CC-BY-SA-4.0 license](https://creativecommons.org/licenses/by-sa/4.0/legalcode).

### Current Desktop
![desktop](https://github.com/rharish101/dotfiles/assets/25344287/51dc1b32-2370-4f2f-9052-09363d4970ce)

### i3lock
![i3lock](./screenshots/i3lock.png)

### Terminal
#### Colourscheme
![colourscheme](https://user-images.githubusercontent.com/25344287/222915927-96398692-42d6-49d3-87b4-d795acae44bb.png)

#### Fortune + Cowsay + Dotacat
![cowsay](https://user-images.githubusercontent.com/25344287/222915930-72de3307-a36f-4eed-9707-ce880c7f2a4d.png)

#### Fish
![fish-1](https://user-images.githubusercontent.com/25344287/222915943-3ec85e6c-e3a9-40ae-8fba-430c08ffd114.png)
![fish-2](https://user-images.githubusercontent.com/25344287/222915946-31735e08-95c0-4d53-9510-36409b1ca9b6.png)

#### Bash
![bash](./screenshots/bash.png)

### Vim
![vim-1](./screenshots/vim-1.png)
![vim-2](./screenshots/vim-2.png)
![vim-3](./screenshots/vim-3.png)

### IPython
![ipython](./screenshots/ipython.png)

### Tmux
![tmux](./screenshots/tmux.png)

## Licenses
This repository uses [REUSE](https://reuse.software/) to document licenses.
Each file either has a header containing copyright and license information, or has an entry in the [DEP5 file](https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/) at [.reuse/dep5](./.reuse/dep5).
The license files that are used in this project can be found in the [LICENSES](./LICENSES) directory.

The MIT license is placed in [LICENSE](./LICENSE), to signify that it constitutes the majority of the codebase, and for compatibility with GitHub.
