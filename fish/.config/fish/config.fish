# SPDX-FileCopyrightText: 2023 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: MIT

if status is-interactive
    cowsay -f tux -W 72 "$(fortune -as)" | dotacat -p 3.0
end

# Environment variables
set -Ux EDITOR vim
set -Ux MANPAGER "less -R --use-color -Dd+r -Dk+r -Du+g -DSky"

# Extra locations for path variables
fish_add_path $HOME/.local/bin

# Vi mode config
fish_vi_key_bindings
set -g fish_escape_delay_ms 10
function _reset_vi_mode --on-event fish_prompt
    fish_vi_key_bindings insert
end

# Cursor setup
set fish_cursor_default block
set fish_cursor_insert line
set fish_vi_force_cursor # Needed for tmux

# Aliases
alias restart=reboot

# Keybinds
bind -k nul accept-autosuggestion # Ctrl+Space
bind -k nul -M insert accept-autosuggestion # Ctrl+Space
