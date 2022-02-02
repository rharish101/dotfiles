cowsay -f tux -W 72 "$(fortune -as)" | dotacat -p 3.0

# Setup pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
