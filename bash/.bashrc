# SPDX-FileCopyrightText: 2018 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: MIT

shopt -s autocd # cd to directory when the name is given as a command
shopt -s cmdhist lithist # store multi-line commands with newlines in history

export EDITOR=vim
export HISTCONTROL=ignoredups

alias ls='ls --color=auto'
alias restart="reboot"

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
