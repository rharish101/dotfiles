# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
ZSH=/usr/share/oh-my-zsh/

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"

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
plugins=(vi-mode colored-man-pages history-substring-search)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi
export EDITOR='vim'

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias update-grub='grub-mkconfig -o /boot/grub/grub.cfg'
alias sudo="sudo "
alias restart="reboot"
alias cmatrix="cmatrix -bs"
alias black="black --line-length=79"
alias xelatex="xelatex -shell-escape"
alias latexmk="latexmk -pdf -shell-escape -xelatex"

# Custom scripts
alias with-cuda="/mnt/Data/Programs/Shell/with-cuda.zsh"
alias check-bitrate="/mnt/Data/Programs/Shell/check-bitrate.zsh"
alias capitalize-mp3="/mnt/Data/Programs/Shell/capitalize-mp3.zsh"
alias find-numeric-genres="/mnt/Data/Programs/Shell/find-numeric-genres.zsh"
alias compress-video="/mnt/Data/Programs/Shell/compress-video.zsh"
alias imgdiff="/mnt/Data/Programs/Python/imgdiff.py"
alias dup-img-rm="TF_CPP_MIN_LOG_LEVEL=3 /mnt/Data/Programs/Python/dup_img_rm.py"
alias dhash="/mnt/Data/Programs/Python/dhash.py"
alias chromedriver="/mnt/Data/Programs/Python/chromedriver.py"
alias mount-mtp="/mnt/Data/Programs/Shell/mtp_mount.sh"
alias umount-mtp="fusermount -u $HOME/mtp && rmdir $HOME/mtp"

# Environment variables
export LS_COLORS="$LS_COLORS:di=1;34:ln=1;36:so=1;35:pi=33:ex=32:bd=1;33:cd=1;33:su=0;41:sg=0;43:tw=0;44:ow=1;34"
export QT_QPA_PLATFORMTHEME=gtk2  # Qt apps use GTK2 themeing
export PS2=$'\e[1;34m...  \e[0m'
export VIRTUAL_ENV_DISABLE_PROMPT=false # force themeing of virtual envs
export VGL_READBACK=pbo # increase bumblebee performance
export PRIMUS_SYNC=1 # primus fix for compositing window managers
export WINEPREFIX="$HOME/.wine"
export WINEDLLOVERRIDES="mscoree=d;mshtml=d" # don't bug about mono and gecko
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/lib64  # include CUDA
export FFF_TRASH_CMD="trash-put" # Use `trash-put` to trash in fff
export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs"

# Enable zsh plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10' # looks better with solarized-dark
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh # to customize prompt, run `p10k configure` or edit ~/.p10k.zsh.

# Settings for zsh history
unsetopt LIST_AMBIGUOUS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
unsetopt SHARE_HISTORY

setopt extended_glob

# Custom keybindings
bindkey '^ ' autosuggest-accept # ctrl-space for autosuggestion completion
bindkey -M vicmd 'k' history-substring-search-up # k in vi-mode for cycling up matching commands
bindkey -M vicmd 'j' history-substring-search-down # j in vi-mode for cycling down matching commands
bindkey '^[[Z' reverse-menu-complete # shift-tab for previous selection / reverse of tab

# ==========================================================
# ==================== CUSTOM FUNCTIONS ====================
# ==========================================================

# Set an ad-hoc GUI timer
timer ()
{
    local target="$1"
    local message="${2:-BING}"

    if [[ -z "$target" ]]; then
        echo "Usage: timer TIME [MESSAGE]"
    fi

    echo "Setting timer for: $target"
    _timer_helper "$target" "$message"
}

# Set an ad-hoc GUI alarm
alarm ()
{
    local target="$1"
    local message="${2:-BING}"

    if [[ -z "$target" ]]; then
        echo "Usage: alarm TIME [MESSAGE]"
    fi

    target_unix="$(date -d "$target" "+%s")"
    now_unix=$(date "+%s")
    difference=$((target_unix - now_unix))

    if (( difference < 0 )); then
        echo "Cannot set alarm for the past"
    fi

    echo "Setting alarm for: $(date -d "$target")"
    _timer_helper "$difference" "$message"
}

# Helper function for timer and alarm
_timer_helper ()
{
    local target="$1"
    local message="$2"

    main ()
    {
        sleep "$target" || return 1
        zenity --info --icon-name="appointment-soon" --title="Time's Up" --text="$message" &!
        canberra-gtk-play --id alarm-clock-elapsed --description="Time's Up"
    }

    main &!
    local pid=$!
    # Wait for 0.2s before checking if the main function succeeded
    sleep 0.2
    # `main` is not running => it has failed, so indicate this function's failure
    ps -p $pid &>/dev/null || return 1
}

gpu-info()
{
    pushd "/mnt/Data/Programs/Python/gpu-usage-info" > /dev/null
    ./gpu_info.py $@
    return_code=$?
    popd &> /dev/null
    return $return_code
}

cseproj-info()
{
    hosts=()
    for num in 145 146 147 148 149 150 152; do
        hosts+=("cseproj${num}.cse.iitk.ac.in")
    done
    gpu-info $hosts
}

# cd to directory on exit of fff
old_fff=$(which fff)
fff()
{
    eval "$old_fff" "$@"
    cd "$(cat "${XDG_CACHE_HOME:=${HOME}/.cache}/fff/.fff_d")"
}
