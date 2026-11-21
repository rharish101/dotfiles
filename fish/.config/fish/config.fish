# SPDX-FileCopyrightText: 2023 Harish Rajagopal <harish.rajagopals@gmail.com>
#
# SPDX-License-Identifier: MIT

function fish_greeting
    cowsay -f tux -W 72 "$(fortune -as)" | dotacat -p 3.0
end

# Environment variables
set -gx EDITOR nvim
set -gx MANPAGER "less -R --use-color -Dd+r -Dk+r -Du+g -DSky"
set -gx MANROFFOPT "-P -c"
set -gx NNN_PLUG "f:finder"

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
alias vim=nvim
alias vimdiff="nvim -d"

# Keybinds
bind ctrl-space accept-autosuggestion # Ctrl+Space
bind ctrl-space -M insert accept-autosuggestion # Ctrl+Space

# Function to configure the prompt
# NOTE: This needs to be run only once per system.
function setup_tide
    tide configure \
        --auto \
        --style=Rainbow \
        --prompt_colors='True color' \
        --show_time='24-hour format' \
        --rainbow_prompt_separators=Angled \
        --powerline_prompt_heads=Sharp \
        --powerline_prompt_tails=Round \
        --powerline_prompt_style='Two lines, character and frame' \
        --prompt_connection=Solid \
        --powerline_right_prompt_frame=Yes \
        --prompt_connection_andor_frame_color=Dark \
        --prompt_spacing=Sparse \
        --icons='Many icons' \
        --transient=Yes
end

# Set custom colors
set -g fish_color_command blue
