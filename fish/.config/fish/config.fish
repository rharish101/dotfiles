# SPDX-FileCopyrightText: 2023 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: MIT

if status is-interactive
    # Replace fish's greeting with a fun one.
    set -U fish_greeting
    cowsay -f tux -W 72 "$(fortune -as)" | dotacat -p 3.0
end

# Environment variables
set -Ux EDITOR vim
set -Ux PYENV_ROOT $HOME/.pyenv
set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/gcr/ssh # Required for using the SSH agent
set -Ux TF_CPP_MIN_LOG_LEVEL 1 # Hide TensorFlow INFO and DEBUG logs.
set -Ux WINEDLLOVERRIDES "mshtml d" # Don't bug about missing Gecko.
set -Ux WINEPREFIX $HOME/.wine/default

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
