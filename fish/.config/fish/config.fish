# SPDX-FileCopyrightText: 2023 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: MIT

if status is-interactive
    cowsay -f tux -W 72 "$(fortune -as)" | dotacat -p 3.0
end

# Environment variables
set -Ux EDITOR vim
set -Ux MANPAGER "less -R --use-color -Dd+r -Dk+r -Du+g -DSky"
set -Ux PYENV_ROOT $HOME/.pyenv

# Extra locations for path variables
fish_add_path $PYENV_ROOT/bin $HOME/.local/bin
set -Uxa --path LD_LIBRARY_PATH /opt/cuda/lib64

# Vi mode config
fish_vi_key_bindings
set -g fish_escape_delay_ms 10

# Cursor setup
set fish_cursor_default block
set fish_cursor_insert line
set fish_vi_force_cursor # Needed for tmux

# Aliases
alias restart=reboot

# pyenv setup
pyenv init --path --no-rehash fish | source

# Keybinds
bind -k nul accept-autosuggestion # Ctrl+Space
bind -k nul -M insert accept-autosuggestion # Ctrl+Space
