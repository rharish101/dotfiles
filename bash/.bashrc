#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

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
#longcat
shopt -s cmdhist lithist
alias update-grub='grub-mkconfig -o /boot/grub/grub.cfg'
alias sudo="sudo "
alias restart="reboot"
alias mvg="mvg -g"
alias cpg="cpg -g"
alias yo="longcat Yo!"
alias why="longcat 'Why not?'"
alias ls='ls --color=auto'
export LS_COLORS="$LS_COLORS:di=1;34:ln=1;36:so=1;35:pi=33:ex=32:bd=1;33:cd=1;33:su=0;41:sg=0;43:tw=0;44:ow=1;34"
export EDITOR=vim
# For Tensorflow with MKL
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/opt/cuda/lib64
complete -cf sudo
alias cmatrix="cmatrix -bs"
alias octave="octave --no-gui"
# alias python='python2'
# alias pip='pip2'
#alias ipython="ipython2"
alias mount-mtp="$HOME/.mtp_mount.sh"
alias umount-mtp="fusermount -u $HOME/Galaxy\ S5"
alias mp3gaingui="xdg-open $HOME/MP3Gain/MP3GainGUI.exe > /dev/null 2>&1"
alias tagscanner="xdg-open $HOME/TagScan-old/Tagscan.exe > /dev/null 2>&1"
alias check-bitrate="$HOME/.check-bitrate.sh"
alias capitalize-mp3="$HOME/.capitalize-mp3.sh"
alias compress-video="$HOME/.compress-video.sh"
alias gpu-avail="/mnt/Data/Programs/Bash/gpu_avail.sh"
alias on-nvidia="sudo tee /proc/acpi/bbswitch <<< ON"
alias off-nvidia="sudo rmmod nvidia_uvm; sudo rmmod nvidia; sudo tee /proc/acpi/bbswitch <<< OFF"

#optirun aliases
alias nvtop='optirun -b none nvtop'
alias nvidia-bug-report.sh="optirun --no-xorg nvidia-bug-report.sh"
alias nvidia-cuda-mps-control="optirun --no-xorg nvidia-cuda-mps-control"
alias nvidia-cuda-mps-server="optirun --no-xorg nvidia-cuda-mps-server"
alias nvidia-debugdump="optirun --no-xorg nvidia-debugdump"
alias nvidia-modprobe="optirun --no-xorg nvidia-modprobe"
alias nvidia-persistenced="optirun --no-xorg nvidia-persistenced"
alias nvidia-settings="optirun -b none nvidia-settings -c :8"
alias nvidia-smi="optirun --no-xorg nvidia-smi"
alias nvidia-xconfig="optirun --no-xorg nvidia-xconfig"

export QT_QPA_PLATFORMTHEME=qgnomeplatform
source /usr/share/doc/pkgfile/command-not-found.bash
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

export THEME=~/.bash/themes/agnoster-bash/agnoster.bash
if [[ -f $THEME ]]; then
    export DEFAULT_USER=`whoami`
    source $THEME
fi
#case $UID in
   #0)
       #export PS1='\[\e[1;31m\]\u\[\e[m\] \[\e[1;34m\]\W\[\e[m\]: '
       #;;
   #*)
       #export PS1='\[\e[1;32m\]\u\[\e[m\] \[\e[1;34m\]\W\[\e[m\]: '
       #;;
#esac
export PS2='\[\e[1;34m\]...  \[\e[m\]'

export HISTCONTROL=ignoredups
shopt -s autocd
