# If you come from bash you might have to change your $PATH.
 export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting archlinux history-substring-search vi-mode ssh-agent python)

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_IN.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='mvim'
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
longcat()
{
    if [[ $1 == "" ]]; then
        cowsay -f ~/.longcat.cow -W 79 $(fortune -as) | lolcat -t
    else
        str=""
        while [[ $1 != "" ]]; do
            if [[ $str == "" ]]; then
                str="${str}$1"
            else
                str="${str} $1"
            fi
            shift
        done
        cowsay -f ~/.longcat.cow -W 79 $str | lolcat -t
    fi
}
longcat
alias update-grub='grub-mkconfig -o /boot/grub/grub.cfg'
# alias python='python2'
# alias pip='pip2'
# alias ipython='ipython2'
alias ls='ls --color=auto'
export EDITOR=vim
setopt extended_glob
source /usr/share/doc/pkgfile/command-not-found.bash
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
man()
{
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}
alias sudo="sudo "
alias restart="reboot"
alias yo="longcat Yo!"
alias why="longcat 'Why not?'"
alias cmatrix="cmatrix -bs"
alias mount-mtp="/mnt/Data/Programs/Bash/mtp_mount.sh"
alias umount-mtp="fusermount -u /home/rharish/mtp; rm -r /home/rharish/mtp"
alias mp3gaingui="xdg-open /home/rharish/MP3Gain/MP3GainGUI.exe > /dev/null 2>&1"
alias check-bitrate="/mnt/Data/Programs/Bash/check-bitrate.sh"
alias capitalize-mp3="/mnt/Data/Programs/Bash/capitalize-mp3.sh"
alias concatenate-mp3="/mnt/Data/Programs/Bash/concatenate-mp3.sh"
alias compress-video="/mnt/Data/Programs/Bash/compress-video.sh"
alias gpu-avail="/mnt/Data/Programs/Bash/gpu_avail.sh"
alias on-nvidia="sudo tee /proc/acpi/bbswitch <<< ON"
alias off-nvidia="sudo rmmod nvidia_uvm; sudo rmmod nvidia; sudo tee /proc/acpi/bbswitch <<< OFF"
alias black="black --line-length=79"
alias xelatex="xelatex -shell-escape"
alias mysql="mysql -p"
alias imgdiff="/mnt/Data/Programs/Python/imgdiff.py"
alias dup-img-rm="/mnt/Data/Programs/Python/dup-img-rm.py"

#aliases for gemos (CS330A)
alias start-gemos="docker run -dit --name gemos --rm=true -p 1234:3456 -v /mnt/Data/gem5:/root/gem5 -e M5_PATH=\"/root/gem5/gemos\" -e GEM5_LOC=\"/root/gem5\" gem5"
alias stop-gemos="docker kill gemos"
alias connect-gemos="telnet localhost 1234"
# alias kernel-gemos="cp -t /mnt/Data/gem5/gemos/binaries/"
kernel-gemos ()
{
    cp $1 /mnt/Data/gem5/gemos/binaries
    start-gemos && sleep 2 && connect-gemos
}

#optirun aliases
alias nvtop='optirun --no-xorg nvtop'
alias nvidia-bug-report.sh="optirun --no-xorg nvidia-bug-report.sh"
alias nvidia-cuda-mps-control="optirun --no-xorg nvidia-cuda-mps-control"
alias nvidia-cuda-mps-server="optirun --no-xorg nvidia-cuda-mps-server"
alias nvidia-debugdump="optirun --no-xorg nvidia-debugdump"
alias nvidia-modprobe="optirun --no-xorg nvidia-modprobe"
alias nvidia-persistenced="optirun --no-xorg nvidia-persistenced"
alias nvidia-settings="optirun -b none nvidia-settings -c :8"
alias nvidia-smi="optirun --no-xorg nvidia-smi"
alias nvidia-xconfig="optirun --no-xorg nvidia-xconfig"

LS_COLORS=$LS_COLORS:'ow=01;34:ex=32:' ;
export LS_COLORS
#alias mtp-mount="simple-mtpfs ~/Galaxy\ S5"
export PS2=$'\e[1;34m...  \e[0m'
export QT_QPA_PLATFORMTHEME=qgnomeplatform
export VGL_READBACK=pbo     # increase bumblebee performance
export NLTK_DATA="/mnt/Data/Datasets/nltk_data"
export WINEDLLOVERRIDES="mscoree=d;mshtml=d"
export WINEPREFIX="/home/rharish/.wine"

ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
  mkdir $ZSH_CACHE_DIR
fi

source $ZSH/oh-my-zsh.sh

ZSH_HIGHLIGHT_STYLES[path]=none
unsetopt LIST_AMBIGUOUS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
unsetopt SHARE_HISTORY
# DISABLE_AUTO_TITLE="true"
# precmd ()
# {
#     if [[ $(print -Pn "\e]0;%x\a") != 'zsh' ]]
#     then
#         print -Pn "\e]0;%x\a"
#     fi
# }
# chpwd () {print -Pn "\e]0;%1d\a"}
export ZSH_THEME_TERM_TITLE_IDLE="%1d"
# dconf write /org/gnome/terminal/legacy/profiles:/:cb008e84-0e36-4cc8-85e1-4bbab63f3beb/scrollbar-policy "'never'"

# For Tensorflow with MKL
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/opt/cuda/lib64

# set an ad-hoc GUI timer
timer()
{
    local target=$1; shift
    if [[ -z $target ]]; then
        echo "Usage: timer time"
    else
        ((sleep $target && zenity --info --icon-name="appointment-soon" --title="Time's Up" --text="${*:-BING}" & cvlc --play-and-exit /usr/share/sounds/Borealis/Kopete_notify.ogg) & ) &>/dev/null
        echo "Timer set for: $target"
    fi
}
# set an ad-hoc GUI alarm
alarm()
{
    local target=$1; shift
    if [[ -z $target ]]; then
        echo "Usage: alarm time"
    else
        N=$(date -d "$target" +"%s")
        now=$(date +"%s")
        difference=$((N-now))
        if (( $difference < 0 )); then
            echo "Cannot set alarm for the past"
        else
            ((sleep $difference && zenity --info --icon-name="appointment-soon" --title="Time's Up" --text="${*:-BING}" & cvlc --play-and-exit /usr/share/sounds/Borealis/Kopete_notify.ogg) & ) &>/dev/null
            echo "Alarm set for: $(date -d $target)"
        fi
    fi
}

# X11 clipboard support
function x11-clip-wrap-widgets() {
    # NB: Assume we are the first wrapper and that we only wrap native widgets
    # See zsh-autosuggestions.zsh for a more generic and more robust wrapper
    local copy_or_paste=$1
    shift

    for widget in $@; do
        # Ugh, zsh doesn't have closures
        if [[ $copy_or_paste == "copy" ]]; then
            eval "
            function _x11-clip-wrapped-$widget() {
                zle .$widget
                xclip -in -selection clipboard <<<\$CUTBUFFER
            }
            "
        else
            eval "
            function _x11-clip-wrapped-$widget() {
                CUTBUFFER=\$(xclip -out -selection clipboard)
                zle .$widget
            }
            "
        fi

        zle -N $widget _x11-clip-wrapped-$widget
    done
}

local copy_widgets=(
    vi-yank vi-yank-eol vi-delete vi-backward-kill-word vi-change-whole-line
)
local paste_widgets=(
    vi-put-{before,after}
)

# NB: can atm. only wrap native widgets
x11-clip-wrap-widgets copy $copy_widgets
x11-clip-wrap-widgets paste  $paste_widgets
bindkey '^[[Z' reverse-menu-complete

export VIRTUAL_ENV_DISABLE_PROMPT=false
