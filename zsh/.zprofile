# SPDX-FileCopyrightText: 2020 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: MIT

cowsay -f tux -W 72 "$(fortune -as)" | dotacat -p 3.0

# Setup pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Required for using the SSH agent
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
