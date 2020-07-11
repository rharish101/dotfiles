# dotfiles

This is a repository containing all of my configurations of my current rice.
I use GNU Stow to manage my dotfiles (for a tutorial, [click here]( https://alexpearce.me/2016/02/managing-dotfiles-with-stow/)).
Simply use Stow on all the folders in this repository (except for the screenshots and vim folder).

For my vim setup, use Stow on the `config` folder inside the vim folder as follows:
```
cd vim
stow -t ~ config
```

## Requirements
* GNU Stow
* Xfce4
* Compiz 0.9
* The [Plata-Noir-Compact](https://gitlab.com/tista500/plata-theme) GTK theme
* The [Papirus-Dark](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme) icon theme
  * The [papirus-folders](https://github.com/PapirusDevelopmentTeam/papirus-folders) tool
* The Breeze Light cursor theme
* i3lock-color
  * eog (optional; used in combination with Compiz as a hack for a fade-in/fade-out effect)
  * xss-lock (optional; for locking on screen blank)
* Roboto Font
* Terminator
  * Fortune
  * Cowsay
  * Lolcat
  * Roboto Mono NerdFont
* Zsh
  * [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
  * [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
  * [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
  * [powerlevel10k](https://github.com/romkatv/powerlevel10k)

### Optional
* My wallpaper scripts (warning: hacky code)
  * Pillow (PIL fork)
  * python-xlib
* Cava GUI (a.k.a. [XAVA](https://github.com/nikp123/xava))
  * devilspie2
* Vim (probably should be required :stuck_out_tongue:)
* IPython
  * Powerline
* Tmux
* R
  * The [colorout](https://github.com/jalvesaq/colorout) package
* LaTeX

## Instructions
* **Compiz**  
  1. Load the file "ccsm-settings.profile":
    1. Open Compiz Settings (CCSM)
    2. Go to Preferences > Profile & Backend
    3. Under Profile, click "Import"
    4. Select the profile "ccsm-settings.profile" from the "compiz" directory
  2. Run the provided script to fix issues with Compiz and Xfce:
    0. Ensure Xfce is installed
    1. Go to the "compiz" directory
    2. Run the script:
      ```sh
      ./compiz-xfce-setup.sh
      ```

* **Papirus Folder**
  Run the following command to set the folder colors of the Papirus-Dark theme to match the Plata GTK theme's colorscheme:
  ```sh
  papirus-folders -C indigo --theme Papirus-Dark
  ```

* **Wallpaper Scripts**  
  The script ".blur-desktop.py" blurs the wallpaper when the active/focused window is not the desktop.
  The script ".wallpaper.py" enables the wallpaper to be smoothly changed every X seconds.
  <br>

  The wallpaper changing script is adapted from [xfce-wallpaper-transition](https://github.com/c4tz/xfce-wallpaper-transition).
  <br>

  Both the scripts use argparse to parse commandline arguments.
  Simpy type `~/.blur-desktop.py -h` or `~/.wallpaper.py -h` to get the list of available commandline arguments.
  <br>

* **i3lock-color**  
  This uses [i3lock-multimonitor](https://github.com/ShikherVerma/i3lock-multimonitor) for multi-monitor support.
  How to use:
    * Run `~/.i3locker.sh -h` to get the list of available commandline arguments.
    * Run the script with the necessary arguments.
    * You can change the argument defaults in the script itself.
  <br>

  You can also setup xss-lock so that i3lock is called whenever the screen blanks as follows:
  ```
  xss-lock ~/.i3locker.sh
  ```

## Screenshots (Outdated)
### **Current Desktop**
![desktop](./screenshots/desktop.png)

### **Individual Software**
* **XAVA**  
  ![cava](./screenshots/cava.png)

* **i3lock**  
  ![i3lock](./screenshots/i3lock.png)

* **Terminator**
  * Colorscheme  
    ![colorscheme](./screenshots/colorscheme.png)

  * Cowsay (with fortune and lolcat)  
    ![cowsay](./screenshots/cowsay.png)

  * Zsh  
    ![zsh-1](./screenshots/zsh-1.png)
    <br>

    ![zsh-2](./screenshots/zsh-2.png)

  * Bash  
    ![bash-1](./screenshots/bash-1.png)
    <br>

    ![bash-2](./screenshots/bash-2.png)

* **Wallpaper Scripts**  
  ![wallpaper-scripts](./screenshots/scripts.gif)  

* **Vim**  
  ![vim-1](./screenshots/vim-1.png)
  <br>

  ![vim-2](./screenshots/vim-2.png)
  <br>

  ![vim-3](./screenshots/vim-3.png)

* **IPython + Powerline**  
(WIP)

* **Tmux**  
  ![tmux](./screenshots/tmux.png)

* **R**  
  ![r](./screenshots/r.png)
