shopt -s cmdhist lithist
complete -cf sudo
shopt -s autocd

export EDITOR=vim
export HISTCONTROL=ignoredups
export PATH=$HOME/.local/bin:/usr/local/bin:$PATH
export LS_COLORS="$LS_COLORS:di=1;34:ln=1;36:so=1;35:pi=33:ex=32:bd=1;33:cd=1;33:su=0;41:sg=0;43:tw=0;44:ow=1;34"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/cuda/lib64  # include CUDA

alias ls='ls --color=auto'
alias update-grub='grub-mkconfig -o /boot/grub/grub.cfg'
alias sudo="sudo "
alias restart="reboot"

# Bumblebee aliases
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

# Colorful man pages
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

# Setting the prompts
case $UID in
    0) user_color='31' ;;
    *) user_color='32' ;;
esac
export PS1="\[\e[1;${user_color}m\]\u\[\e[1;37m\]@\[\e[1;33m\]\h\[\e[m\] \[\e[1;34m\]\W\[\e[m\]: "
export PS2="\[\e[1;34m\]...  \[\e[m\]"
